import os

from xmlrpc.client import Boolean
from rdflib import BNode, ConjunctiveGraph, Dataset, Graph, URIRef
from pathlib import Path

from owl2aas.helpers import add_prefixes, infer_properties

# Directory for storing logs and debug files
LOGS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "logs")


def initialize_dataset(g_in: Graph):

    # Initialize a Dataset
    dataset = Dataset()

    # Add input ontology graph to dataset (assume has identifier "http://mas4ai.eu/id/graph/owl")
    g_owl = dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/owl"))
    g_owl.parse(data=g_in.serialize())

    # Add AAS RDF ontology graph to dataset
    g_AAS_ont = dataset.graph(identifier=URIRef("https://admin-shell.io/aas/3/0/RC01/"))
    g_AAS_ont.parse("https://raw.githubusercontent.com/admin-shell-io/aas-specs/master/schemas/rdf/rdf-ontology.ttl", format="text/turtle")
    # g_AAS_ont.parse("https://raw.githubusercontent.com/admin-shell-io/aas-specs/draft-V3RC02-schemas/schemas/rdf/rdf-ontology.ttl", format="text/turtle")

    # Add graph to store the AAS Template graph in
    dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/aas/template"))

    return dataset, g_owl


def construct_aas(g_in: Graph, g_in_path: str, debug: Boolean):

    # Initialize graphs and dataset
    dataset, g_owl = initialize_dataset(g_in)
    g_out = dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/aas"))
    g_conj = ConjunctiveGraph(dataset.store)
    add_prefixes(dataset)


    # Enrich input graph (consider relocating to separate function)
    imports = [o for o in g_owl.objects(predicate=URIRef("http://www.w3.org/2002/07/owl#imports"))]
    for file in imports:
        # First check if file is in same folder as input graph
        try:
            local_file = os.path.join(os.path.split(g_in_path)[0], file.toPython().strip('#/').split('/')[-1])
            g_owl.parse(local_file)
            print('imported: ', local_file)
        except FileNotFoundError:
            try:
                g_owl.parse(file.toPython())
                print('imported: ', file.toPython())
            except:
                print('Cannot import ', file.toPython())

    infer_properties(g_owl)

    if debug:
        g_owl.serialize(os.path.join(LOGS_DIR, "g_owl.ttl"))
        print(f"Stored enriched ontology to {os.path.join(LOGS_DIR, 'g_owl.ttl')}")

    # Load SPARQL files into memory
    sparql_files = list(Path("owl2aas/sparql/").rglob("*.r[qu]"))
    for file in sparql_files:
        file_var_name = file.name.strip('.rqu').lower().replace('-','_')
        globals()[file_var_name] = open(file, 'r').read()


    # Run SPARQL to construct AAS
    # TODO: use SPARQL INSERT?
    g_out.parse(data=g_owl.query(construct_property).graph.serialize())

    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_reference_element).graph.serialize())

    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_smc_non_aas_class).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_smc_cardinality).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_smc_cardinality_object_prop).graph.serialize())
    add_prefixes(dataset)
    g_conj.update(insert_smc_value)

    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_submodel).graph.serialize())
    add_prefixes(dataset)
    g_conj.update(insert_sm_submodelelements)

    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_asset_administration_shell).graph.serialize())
    add_prefixes(dataset)
    g_conj.update(insert_aas_submodels)
    add_prefixes(dataset)
    g_conj.update(insert_refe_value)

    add_prefixes(dataset)
    g_conj.update(insert_aas_environment)

    add_prefixes(dataset)
    g_conj.update(insert_haskind)
    add_prefixes(dataset)
    g_conj.update(insert_referable_attributes)

    return g_out