import requests
import pandas as pd

FUSEKI_URL = "http://localhost:3030"  
DATASET_NAME = "rdf-dataset"  
SPARQL_QUERY_ENDPOINT = f"{FUSEKI_URL}/{DATASET_NAME}/sparql"  

def run_sparql_query(query):
    params = {"query": query}
    headers = {"Accept": "application/sparql-results+json"} 
    response = requests.get(SPARQL_QUERY_ENDPOINT, headers=headers, params=params)
    if response.status_code == 200:
        return response.json()  
    else:
        print(f"Failed to execute SPARQL query. Status code: {response.status_code}\n{response.text}")
        return None

# Main
if __name__ == "__main__":
    query = """
    PREFIX : <http://example.org/crepes#>
    PREFIX schema: <http://schema.org/>

    SELECT ?stepNumber ?duration ?text ?resultantState (GROUP_CONCAT(?utensilName; SEPARATOR=", ") AS ?utensils) (GROUP_CONCAT(?utensilPurpose; SEPARATOR=", ") AS ?purposes) WHERE {
    :Crepes :hasInstruction ?instruction .
    ?instruction schema:stepNumber ?stepNumber ;
                 schema:duration ?duration ;
                 schema:text ?text ;
                 :resultantState ?resultantState ;
                 :usesUtensil ?utensil .
    ?utensil schema:name ?utensilName ;
            schema:purpose ?utensilPurpose .
    }
    GROUP BY ?stepNumber ?duration ?text ?resultantState
    ORDER BY ?stepNumber
    """
   
    results = run_sparql_query(query)
    if results:
        # Prepare data for the DataFrame
        data = []
        for result in results["results"]["bindings"]:
            stepNumber = result.get('stepNumber', {}).get('value', 'N/A')
            duration = result.get('duration', {}).get('value', 'N/A')
            text = result.get('text', {}).get('value', 'N/A')
            resultantState = result.get('resultantState', {}).get('value', 'N/A')
            utensils = result.get('utensils', {}).get('value', 'N/A')
            purposes = result.get('purposes', {}).get('value', 'N/A')
            data.append({
                "Step Number": stepNumber,
                "Duration": duration,
                "Text": text,
                "Resultant State": resultantState,
                "Utensils": utensils,
                "Purposes": purposes
            })
        
        # Create a DataFrame
        df = pd.DataFrame(data)
        
        # Save to CSV
        output_csv = "crepes_recipe_steps.csv"
        df.to_csv(output_csv, index=False)
        print(f"Results saved to {output_csv}\n")

        # Display output in a readable block format
        print("Step-by-step Instructions:")
        for _, row in df.iterrows():
            print(f"Step Number: {row['Step Number']}")
            print(f"Duration: {row['Duration']}")
            print(f"Instruction: {row['Text']}")
            print(f"Resultant State: {row['Resultant State']}")
            print(f"Utensils: {row['Utensils']}")
            print(f"Purposes: {row['Purposes']}")
            print("-" * 80)