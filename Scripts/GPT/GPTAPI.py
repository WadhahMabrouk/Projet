import json 
import asyncio
from mistralai import Mistral

# Load configuration from config.json
with open("../config.json") as config_file:
    json_config = json.load(config_file)

# Initialize the Mistral client
api_key = json_config["mistral"]["api_key"]
model = json_config["mistral"]["model_name"]
client = Mistral(api_key=api_key)



async def generate_completion(chunk):
    prompt = json_config["mistral"]["prompt"] + chunk
    try:
        # Send chat completion request to Mistral API
        chat_response = client.chat.complete(
            model=model,
            messages=[
                {"role": "user", "content": prompt}
            ]
        )
        # Return the content of the response
        return chat_response.choices[0].message.content
    except Exception as error:
        print(f"Mistral API Error: {error}")
        exit(1)

async def main():
    # Read input file
    with open(json_config["mistral"]["input_file"], "r") as input_file:
        input_text = input_file.read()

    # Split input text into chunks
    chunk_size = json_config["mistral"]["chunk_size"]
    chunks = [input_text[i : i + chunk_size] for i in range(0, len(input_text), chunk_size)]

    # Generate completions for all chunks
    promises = [generate_completion(chunk) for chunk in chunks]
    outputs = await asyncio.gather(*promises)

    # Write outputs to the output file
    with open(json_config["mistral"]["output_file"], "a", encoding="utf-8") as output_file:
        for output in outputs:
            output_file.write(output)

# Run the main coroutine
asyncio.run(main())