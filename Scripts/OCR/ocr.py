import io
import json
import logging
import os
import requests
from pathlib import Path
from PIL import Image, ImageEnhance, ImageFilter
import PyPDF2

# Configure logging
logging.basicConfig(filename='ocr.log', level=logging.ERROR)

# Read the configuration file
config_path = Path("../config.json")
if not config_path.is_file():
    logging.error("Configuration file not found.")
    exit()

with config_path.open() as config_file:
    config = json.load(config_file)["ocr"]

# Set the OCR API endpoint URL
api_url = config["api_url"]

# Set your API key
api_key = config["api_key"]

# Set the OCR language
language = config["language"]

# Set the OCR output format
output_format = config["output_format"]

# Set the input file path
input_file = config["input_file"]
input_path = Path(input_file)

# Check if the input file exists
if not input_path.is_file():
    logging.error(f"Input file not found: {input_path}")
    exit()

# Set the output directory path
output_dir = config["output_dir"]
output_path = Path(output_dir)
output_path.mkdir(parents=True, exist_ok=True)

# Set the maximum size of each output file in bytes
max_file_size = config["max_file_size"]

# Ensure the output file is empty initially
with open('ocr_output.txt', 'w') as out:
    out.write('')

# Determine the file extension
file_ext = input_path.suffix.lower()

if file_ext == ".pdf":
    # Process PDF file
    try:
        with input_path.open('rb') as f:
            pdf_reader = PyPDF2.PdfReader(f)

            # Split the input file into chunks
            page_num = 0
            chunk_size = 1  # 1 page per chunk
            while page_num < len(pdf_reader.pages):
                # Set the output file name
                output_file = output_path / f'chunk_{page_num}.pdf'

                # Create a new PDF file writer
                pdf_writer = PyPDF2.PdfWriter()

                # Add pages to the new PDF writer until the chunk size limit is reached
                total_size = 0
                while page_num < len(pdf_reader.pages) and len(pdf_writer.pages) < chunk_size:
                    pdf_writer.add_page(pdf_reader.pages[page_num])
                    total_size += len(pdf_reader.pages[page_num].get_contents())
                    page_num += 1

                # Write the new PDF file
                with output_file.open('wb') as out:
                    pdf_writer.write(out)

                # Check the size of the output file
                if output_file.stat().st_size <= max_file_size:
                    # Send the OCR request using the requests module
                    try:
                        response = requests.post(api_url,
                                                 files={'image': output_file.open('rb')},
                                                 data={'apikey': api_key,
                                                       'language': language,
                                                       'OCREngine': 2,
                                                       'isOverlayRequired': False,
                                                       'isTable': False,
                                                       'detectOrientation': False,
                                                       'scale': True,
                                                       'isCreateSearchablePdf': False,
                                                       'isSearchablePdfHideTextLayer': False,
                                                       'filetype': output_format})

                        # Append the OCR output to the output file
                        if response.status_code == 200:
                            parsed_text = response.json()['ParsedResults'][0]['ParsedText']
                            with io.open('ocr_output.txt', 'a', encoding='utf-8') as out:
                                out.write(parsed_text)
                        else:
                            logging.error(f'Error processing {output_file}: {response.status_code} {response.reason}')
                    except requests.RequestException as e:
                        logging.error(f'Error processing {output_file}: {e}')
                else:
                    logging.error(f'File {output_file} exceeds the maximum file size of {max_file_size} bytes.')

                # Delete the chunk
                output_file.unlink()

    except FileNotFoundError:
        logging.error(f"Input file not found: {input_path}")

elif file_ext in [".png", ".jpg", ".jpeg"]:
    # Process image file
    try:
        img = Image.open(input_path)

        # Enhance the image if needed here:
        # img = img.convert('L') - Convert the image to grayscale
        
        # img = img.filter(ImageEnhance.Contrast(img)) - Increase contrast

        # enhancer = ImageEnhance.Sharpness(img)
        # img = enhancer.enhance(2.0) - Sharpen the image

        # img = img.filter(ImageFilter.MedianFilter) - Noise removal using median filter

        # Save the preprocessed image to a temporary file
        temp_file = output_path / 'preprocessed_image.png'
        img.save(temp_file)

        # Send the OCR request using the requests module
        try:
            response = requests.post(api_url,
                                     files={'image': temp_file.open('rb')},
                                     data={'apikey': api_key,
                                           'language': language,
                                           'OCREngine': 2,
                                           'isOverlayRequired': False,
                                           'isTable': False,
                                           'detectOrientation': False,
                                           'scale': True,
                                           'filetype': output_format})

            # Append the OCR output to the output file
            if response.status_code == 200:
                with io.open('ocr_output.txt', 'a', encoding='utf-8') as out:
                    out.write(response.json()['ParsedResults'][0]['ParsedText'])
            else:
                logging.error(f'Error processing {input_file}: {response.status_code} {response.reason}')
        except requests.RequestException as e:
            logging.error(f'Error processing {input_file}: {e}')

        # Remove the temporary file
        temp_file.unlink()

    except FileNotFoundError:
        logging.error(f"Input file not found: {input_path}")

else:
    logging.error(f"Unsupported file extension: {file_ext}")
