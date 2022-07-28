import re

from rdflib import Graph, URIRef

# Add prefixes to RDFlib Graph
def add_prefixes(graph: Graph()):
    with open("owl2aas/sparql/prefixes.sparql", "r") as f:
        prefixes = f.read().split('\n')

    for prefix in prefixes:

        prefix.strip()
        k = re.findall("^PREFIX ([a-z0-9]+)", prefix)[0]
        v = re.findall("<(.+)>$", prefix)[0]

        graph.bind(k, URIRef(v))


def infer_properties(g_owl: Graph):
    g_owl.update('''
INSERT {
  ?Property rdfs:domain ?SubClass
}
WHERE {
  VALUES ?PropertyType {owl:ObjectProperty owl:DatatypeProperty}
  ?Property a ?PropertyType ;
    rdfs:domain ?Class .
  ?SubClass rdfs:subClassOf+ ?Class .
}
''')