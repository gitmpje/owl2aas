# OWL2AAS

OWL2AAS is a tool to convert an [RDF based OWL 2](https://www.w3.org/TR/2012/REC-owl2-rdf-based-semantics-20121211/) ontology to a basic Asset Administration Shell (AAS) Template for Industry 4.0 Systems,
compliant with the meta model specification provided in
[“Details of the Asset Administration Shell” (v3.0RC02)](https://www.plattform-i40.de/IP/Redaktion/EN/Downloads/Publikation/Details_of_the_Asset_Administration_Shell_Part1_V3.html).


## Features

* Conversion of OWL 2 ontology to a basic AAS, both using RDF syntax.


<!-- ### Project Structure -->


<!-- ## License -->


## Dependencies

OWL2AAS requires the following Python packages to be installed for production usage. These dependencies are listed in
`setup.py` to be fetched automatically when installing with `pip`:
* `rdflib` and its dependencies (BSD 3-clause License)


## Getting Started

### Installation

You can install OWL2AAS using pip:

```bash
pip install -r requirements.txt
```


### Example

Example usage `python -m owl2aas.cli 'test/resources/mas4aiDEMO.ttl' -c 'http://www.tno.nl/mas4aiDEMO#RoboticArm' -o test/mas4aiDEMO_template.aas.ttl`
Generates `mas4aiDEMO_template.aas.ttl` file with the basic AAS template for a 'Robotic Arm'.
If we also need an AAS Template for a 'Tool', we can use `python -m owl2aas.cli 'test/resources/mas4aiDEMO.ttl' -c 'http://www.tno.nl/mas4aiDEMO#RoboticArm' 'http://www.tno.nl/mas4aiDEMO#Tool' -o test/mas4aiDEMO_templates.aas.ttl`.


## Contributing

If you would like to contribute, please get in touch with us: mark.van.der.pas@semaku.com


<!-- ### Codestyle and Testing

Our code follows the [PEP 8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/).
Additionally, we use [PEP 484 -- Type Hints](https://www.python.org/dev/peps/pep-0484/) throughout the code to enable type checking the code.


### Contribute Code/Patches

TBD -->