from rdflib import BNode, ConjunctiveGraph, Dataset, Graph, URIRef
from pathlib import Path

from owl2aas.helpers import add_prefixes, infer_properties

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


def construct_aas(g_in: Graph):

    # Initialize graphs and dataset
    dataset, g_owl = initialize_dataset(g_in)
    g_out = dataset.graph(identifier=URIRef("http://mas4ai.eu/id/graph/aas"))
    g_conj = ConjunctiveGraph(dataset.store)
    add_prefixes(dataset)


    # Enrich input graph (consider relocating to separate function)
    imports = [o for o in g_owl.objects(predicate=URIRef("http://www.w3.org/2002/07/owl#imports"))]
    for file in imports:
        try:
            g_owl.parse(file.toPython())
            print('imported: ', file.toPython())
        except:
            print('Cannot import ', file.toPython())

    infer_properties(g_owl)


    # Load SPARQL files into memory
    sparql_files = list(Path("owl2aas/sparql/").rglob("*.r[qu]"))
    for file in sparql_files:
        file_var_name = file.name.strip('.rqu').lower().replace('-','_')
        globals()[file_var_name] = open(file, 'r').read()


    # Run SPARQL to construct AAS
    # TODO: use SPARQL INSERT?
    g_out.parse(data=g_owl.query(construct_property).graph.serialize())

    g_out.parse(data=g_owl.query(construct_reference_element).graph.serialize())

    g_out.parse(data=g_owl.query(construct_smc_non_aas_class).graph.serialize())
    g_out.parse(data=g_owl.query(construct_smc_cardinality).graph.serialize())
    g_out.parse(data=g_owl.query(construct_smc_cardinality_object_prop).graph.serialize())
    g_conj.update(insert_smc_value)

    g_out.parse(data=g_owl.query(construct_submodel).graph.serialize())
    g_conj.update(insert_sm_submodelelements)

    g_out.parse(data=g_owl.query(construct_asset_administration_shell).graph.serialize())
    g_conj.update(insert_aas_submodels)

    g_conj.update(insert_aas_environment)

    g_conj.update(insert_haskind)
    g_conj.update(insert_referable_attributes)

    return g_out