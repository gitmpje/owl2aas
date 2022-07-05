# OWL2AAS

The PyI40AAS project aims to provide a tool to convert an OWL2 ontology to a basic Asset Administration Shell (AAS) Template for Industry 4.0 Systems,
compliant with the meta model specification provided in
[the document “Details of the Asset Administration Shell” (v2.0.1)](https://www.plattform-i40.de/PI40/Redaktion/DE/Downloads/Publikation/Details-of-the-Asset-Administration-Shell-Part1.html).


## Features

* Conversion of OWL2 ontology to a basic AAS, both using RDF syntax.


### Project Structure


## License


## Dependencies

OWL2AAS requires the following Python packages to be installed for production usage. These dependencies are listed in
`setup.py` to be fetched automatically when installing with `pip`:
* `rdflib` and its dependencies (BSD 3-clause License)


## Getting Started

### Installation

For production usage and building applications with OWL2AAS, we recommended installation from PyPI:

```bash
pip install 
```


### Examples and Tutorials

Example usage `python -m owl2aas.cli 'owl2aas/examples/mas4aiDEMO.ttl' -c 'http://www.tno.nl/mas4aiDEMO#RoboticArm'`
Generates `mas4aiDEMO_template.aas.ttl` file with the basic AAS template.

## Contributing

If you plan contributing code to this repository, please get in touch with us via e-mail first: mark.van.der.pas@semaku.ccom


### Codestyle and Testing

Our code follows the [PEP 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/).
Additionally, we use [PEP 484 -- Type Hints](https://www.python.org/dev/peps/pep-0484/) throughout the code to enable type checking the code.


### Contribute Code/Patches

TBD