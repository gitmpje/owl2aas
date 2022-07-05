import argparse

from owl2aas.construct_aas import construct_aas

from rdflib import BNode, Graph, URIRef


def parse_cli_arguments() -> argparse.ArgumentParser:
    """
    This function returns the argument-parser for the converter cli
    """
    parser = argparse.ArgumentParser(
        prog='owl2aas',
        description='Tool for creating a basic Asset Administration Shell template adhering to "Details of the '
                    'Asset Administration Shell" specification of Plattform Industrie 4.0.\n'
                    'The tool checks for statements with predicate <http://example.org/MAS4AI_GenericModel#hasInterface> '
                    'to determine for what classes to generate an AAS '
                    'alternatively, those classes can be provided using --aas_class or -c argument',
        formatter_class=argparse.RawTextHelpFormatter)

    parser.add_argument('input_file', help="path to OWL2 RDF file")
    parser.add_argument('-o', '--output', help="path to store output AAS RDF file")
    parser.add_argument('-c', '--aas_class', help="list of classes for which to generate an AAS", nargs='+', action='append', default=None)
    parser.add_argument('-v', '--verbose', help="Print detailed information for each step in the process.", default=0)
    parser.add_argument('-l', '--logfile', help="Log file to be created in addition to output to stdout", default=None)
    # group = parser.add_mutually_exclusive_group(required=True)
    # group.add_argument('--json', help="Use AAS json format when checking or creating files", action='store_true')
    # group.add_argument('--xml', help="Use AAS xml format when checking or creating files", action='store_true')
    return parser


def main():
    parser = parse_cli_arguments()
    args = parser.parse_args()

    # Initialize a graph and parse the input file
    g_input = Graph()
    g_input.parse(args.input_file)

    aas_classes = args.aas_class
    if aas_classes:
        for c in aas_classes:
            g_input.add((URIRef(c), URIRef("http://example.org/MAS4AI_GenericModel#hasInterface"), BNode()))

    g_aas = construct_aas(g_input)

    if args.output:
        output_file = args.output
    else:
        output_file = f"{args.input_file.strip('.ttl')}_template.aas.ttl"
    
    g_aas.serialize(output_file)


if __name__=="__main__":
    main()