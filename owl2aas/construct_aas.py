import os

from xmlrpc.client import Boolean
from rdflib import ConjunctiveGraph, Dataset, Graph, URIRef
from pathlib import Path

from owl2aas.helpers import add_prefixes, infer_properties, drop_inverse_properties

# Main directory
MAIN_DIR = os.path.dirname(os.path.abspath(__file__))

# Directory for storing logs and debug files
LOGS_DIR = os.path.join(MAIN_DIR, "logs")


def initialize_dataset(g_in: Graph):

    # Initialize a Dataset
    dataset = Dataset()

    # Add input ontology graph to dataset (assume has identifier "http://mas4ai.eu/id/graph/owl")
    g_owl = dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/owl"))
    g_owl.parse(data=g_in.serialize())

    # Add AAS RDF ontology graph to dataset
    g_AAS_ont = dataset.graph(identifier=URIRef("https://admin-shell.io/aas/3/0/RC02/"))
    g_AAS_ont.parse(os.path.join(MAIN_DIR, "rdf-ontology_V3.0.5RC02.ttl"), format="text/turtle")
    # g_AAS_ont.parse("https://raw.githubusercontent.com/admin-shell-io/aas-specs/master/schemas/rdf/rdf-ontology.ttl", format="text/turtle")

    # Add graph to store the AAS Template graph in
    dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/aas/template"))

    return dataset, g_owl


def construct_aas(g_in: Graph, g_in_path: str, debug: Boolean):

    # Initialize graphs and dataset
    dataset, g_owl = initialize_dataset(g_in)
    g_out = Graph(dataset.store, identifier="http://mas4ai.eu/id/graph/aas/template")
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

    drop_inverse_properties(g_owl)
    infer_properties(g_owl)

    if debug:
        g_owl.serialize(os.path.join(LOGS_DIR, "g_owl.ttl"))
        print(f"Stored enriched ontology to {os.path.join(LOGS_DIR, 'g_owl.ttl')}")

    # Load SPARQL files into memory
    sparql_files = list(Path("owl2aas/sparql/").rglob("*.r[qu]"))
    for file in sparql_files:
        file_var_name = file.name.rstrip('.rqu').lower().replace('-','_')
        globals()[file_var_name] = open(file, 'r').read()


    # Run SPARQL to construct AAS elements
    # TODO: use SPARQL INSERT?
    g_out.parse(data=g_owl.query(construct_property).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_multi_lang_property).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_reference_element).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_smc_non_aas_class).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_smc_cardinality_prop).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_submodel).graph.serialize())
    add_prefixes(dataset)
    g_out.parse(data=g_owl.query(construct_asset_administration_shell).graph.serialize())
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "aas_components.ttl"))

    # SMC relations
    add_prefixes(dataset)
    g_conj.update(insert_smc_value)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_smc_value.ttl"))
    g_out.update(delete_smc_no_values)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "delete_smc_no_values.ttl"))

    # Submodel relations
    g_conj.update(insert_sm_submodelelements)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_sm_submodelelements.ttl"))

    # Convert and remove circular elements
    g_conj.update(convert_smc_to_reference_element)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "convert_smc_to_reference_element.ttl"))
    g_out.update(replace_smc_value)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "replace_smc_value.ttl"))

    # AAS relations
    g_conj.update(insert_aas_submodels)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_aas_submodels.ttl"))
    g_conj.update(insert_refe_value)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_refe_value.ttl"))
    g_conj.update(insert_aas_environment)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_aas_environment.ttl"))

    # Remove redundant elements
    g_conj.update(delete_redundant_submodelelements)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "delete_redundant_submodelelements.ttl"))

    # Element attributes
    g_conj.update(insert_haskind)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_haskind.ttl"))
    g_conj.update(insert_additional_semantic_refs)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_additional_semantic_refs.ttl"))
    g_conj.update(insert_identifiable_attributes)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_identifiable_attributes.ttl"))
    g_conj.update(insert_referable_attributes)
    if debug: g_out.serialize(os.path.join(LOGS_DIR, "insert_referable_attributes.ttl"))

    return g_out