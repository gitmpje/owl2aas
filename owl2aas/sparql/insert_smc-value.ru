INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?SMC aassmc:value ?Value .
  }
}
WHERE {
  {
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Class .

    ?Class a owl:Class .
    ?Property rdfs:domain ?Class .
  } UNION {
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Property .
  }

  ?SubmodelElementType rdfs:subClassOf+ aas:SubmodelElement .
  ?Value a ?SubmodelElementType ;
    prov:wasDerivedFrom ?Property .

  FILTER (?Value != ?SMC)
}