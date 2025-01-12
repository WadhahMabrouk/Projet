import requests


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
    PREFIX ex: <http://example.org/recipe#>
    SELECT ?step ?actionName ?ingredient ?tool
    WHERE {
        ?step a ex:RecipeStep ;
              ex:actionName ?actionName ;
              ex:targetIngredient ?ingredient ;
              ex:toolUsed ?tool .
    }
    """
   
    results = run_sparql_query(query)
    if results:
        for result in results["results"]["bindings"]:
            step = result.get('step', {}).get('value', 'N/A')
            action_name = result.get('actionName', {}).get('value', 'N/A')
            ingredient = result.get('ingredient', {}).get('value', 'N/A')
            tool = result.get('tool', {}).get('value', 'N/A')
            print(f"Step: {step}, Action: {action_name}, Ingredient: {ingredient}, Tool: {tool}")
