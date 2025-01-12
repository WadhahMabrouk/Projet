# RDF Graph Parser and Query Automation

This project demonstrates the process of:
1. Parsing the output from **Mistral** into an RDF graph.
2. Saving the RDF graph in Turtle format into a local RDF database (**Apache Jena Fuseki**).
3. Sending SPARQL queries to the dataset endpoint using Python's `requests` library.

---

## **Setup and Requirements**

### **Prerequisites**
- **Apache Jena Fuseki** installed and running locally.
- **Python 3.7+** installed with the following libraries:
  ```bash
  pip install requests

