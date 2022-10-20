INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?SMC aassmc:value ?Value .
  }
}
WHERE {
  ?SubmodelElementType rdfs:subClassOf+ aas:SubmodelElement .

  {
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Class .

    ?Class a owl:Class .
    ?Property rdfs:domain ?Class .

    ?Value a ?SubmodelElementType ;
      prov:wasDerivedFrom ?Property .

    # The value object should not be derived from a NodeShape, unless it is a cardinality one property
    FILTER ( 
      NOT EXISTS { ?Value prov:wasDerivedFrom/a owl:Class } ||
      EXISTS { ?Property a owl:FunctionalProperty }
    )
  } UNION {
    # Non cardinality one properties
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Property .
    FILTER NOT EXISTS { ?SMC prov:wasDerivedFrom/a owl:Class }

    ?Value a ?SubmodelElementType ;
      prov:wasDerivedFrom ?Property .
  }

  FILTER (?Value != ?SMC)
}