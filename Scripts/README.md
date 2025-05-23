## OCR and GPT-3.5 Scripts Documentation

*La version française se trouve dans [README_FR.md](https://inf203.gricad-gitlab.univ-grenoble-alpes.fr/ziebelid/wwiiheritage/-/blob/main/Scripts/README_FR.md)*

This document provides instructions on setting up, configuring, and using the OCR and GPT-3.5 Turbo scripts. These scripts work in tandem to perform Optical Character Recognition (OCR) on files and generate text-based responses using GPT-3.5.

### Prerequisites

Before setting up and using the OCR and GPT-3.5 Turbo scripts, ensure you have the following prerequisites:

- Python 3.x installed on your machine. [(Install Python)](https://www.python.org/downloads/)
- Access to an OCR API service and an API key. [(OCR.space)](https://ocr.space/ocrapi/freekey)
- An OpenAI GPT-3.5 Turbo API key. [(OpenAI API)](https://platform.openai.com/docs/api-reference)

### Quickstart guide
1. Download ui.zip from the dist folder
2. Extract the zip folder
3. Double click ui.exe

*If you just want to use the software, that's all you have to do.
Keep reading if you want to modify the scripts or see examples.*

### Table of Contents

1. [Installation](#installation)
2. [Configuration](#configuration)
3. [Usage](#usage)
4. [Examples](#examples)


<a name="installation"></a>
### 2. Installation

Follow these steps to install and configure the OCR and GPT-3.5 Turbo scripts:

1. Clone the repository containing the scripts to your local machine:

   ```
   git clone <repository_url>
   ```

2. Navigate to the cloned repository directory:

   ```
   cd <repository_directory>
   ```
   
3. Install the required Python dependencies using `pip`:

   ```
   pip install -r requirements.txt
   ```

Once you have completed these steps, you should have all the dependencies installed and can proceed with running the OCR and GPT-3.5 Turbo scripts.
<a name="configuration"></a>
### 3. Configuration

When using the scripts, you need to configure the OCR and GPT-3.5 Turbo settings. This can be done from a UI by running:

   ```
   python ui.py
   ```
<br/>

### (Below this point is optional)

If you don't want to use the UI, follow these steps:

1. OCR Script Configuration:

   - Open the `config.json` script in a text editor.
   - Configure the OCR API settings:
     - Set the `api_url` variable to the URL of the OCR API service.
     - Set the `api_key` variable to your OCR API key.
     - Set the `language` variable to the desired OCR language.
     - Set the `output_format` variable to the desired OCR output format.
   - Configure the input and output file paths:
     - Set the `input_file` variable to the path of the input file.
     - Set the `output_dir` variable to the directory where output files will be saved.
   - Optionally, adjust other settings such as `max_file_size` and logging configuration as needed.

2. GPT-3.5 Turbo Script Configuration:

   - Open the `config.json` script in a text editor.
   - Configure the GPT-3.5 Turbo API settings:
     - Set the `jsonConfig.openai.api_key` variable to your GPT-3.5 Turbo API key.
   - Configure the input and output file paths:
     - Set the `jsonConfig.gpt.input_file` variable to the path of the input file for GPT-3.5 Turbo.
     - Set the `jsonConfig.gpt.output_file` variable to the path where GPT-3.5 Turbo output will be saved.
   - Optionally, adjust other settings such as the prompt or chunk size.

<a name="usage"></a>
### 4. Usage

To use the OCR and GPT-3.5 Turbo scripts, follow these steps (**You could alternatively use ui.py**):

1. Prepare the input file:
   - Ensure the input file is in a supported format (PDF, JPG, JPEG, or PNG).
   - Place the input file in "input-data".

2. Run the OCR script:
   - Open a terminal or command prompt.
   - Navigate to the directory where the OCR script is located.
   - Execute the following command:

     ```
     python ocr.py
     ```

   - The OCR script will process the input file, perform OCR, and generate output in the specified format.

3. Run the GPT-3.5 Turbo script:
   - Open a terminal or command prompt.
   - Navigate to the directory where the GPT-3.5 Turbo script is located.
   - Execute the following command:

     ```
     node gptapi.js
     ```

   - The GPT script will read the input file generated by the OCR script, generate responses using the GPT-3.5, and save the output to the specified file.

<a name="examples"></a>
### 5. Examples

## Generic Example:
1. OCR:
   - Input: A PDF file containing scanned pages of a book.
   - Output: Individual PDF files for each page, saved in the specified output directory. The OCR text will be appended to the `ocr_output.txt` file.

2. GPT-3.5 Turbo:
   - Input: OCR-generated text from a book, a prompt asking for the text to be put in a database format.
   - Output: GPT-3.5 Turbo-generated text, saved in the specified output file.

## Specific Example:

1. OCR:
    - Input: A png from a scanned zoo book containing pictures of animals and text about the animals.
    - Output: dog, cat, walrus
              brown, red, grey,
              5, 2, 4

2. GPT-3.5 Turbo:
   - Input: The OCR-generated text above, the prompt: "Can you put the below text into more of a database format?".
   - Output: 
   
        | Animal | Color | Quantity |
        |--------|-------|----------|
        | Dog    | Brown | 5        |
        | Cat    | Red   | 2        |
        | Walrus | Grey  | 4        |


You can modify the configuration and adapt the scripts to fit your specific use cases, file formats, and API services.

Please note that these scripts provide a basic implementation, and you may need to customize them further based on your specific requirements and use cases.

---
