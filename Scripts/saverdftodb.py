import json
import requests


config_path = "config.json"  
with open(config_path, "r") as config_file:
    config = json.load(config_file)


output_file_path = config["mistral"]["output_file"]
rdf_output_path = output_file_path.replace("result.txt", "rdf_graph.ttl")  

with open(output_file_path, "r") as result_file:
    content = result_file.readlines()

rdf_content = []
is_rdf = False

for line in content:
    stripped_line = line.strip()
    if stripped_line.startswith("```turtle"):
        is_rdf = True  
        continue  
    if stripped_line.startswith("```") and is_rdf:
        break  
    if is_rdf:
        rdf_content.append(line)

if rdf_content:
    rdf_content = "".join(rdf_content).strip()  
    with open(rdf_output_path, "w") as rdf_file:
        rdf_file.write(rdf_content)
    print(f"Valid RDF graph successfully saved to: {rdf_output_path}")
else:
    print("No valid RDF graph found in the file.")

