INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
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

    MINUS {
      ?Value prov:wasDerivedFrom/a owl:Class ;
        prov:wasDerivedFrom ?Property .
      FILTER NOT EXISTS { ?Property a owl:FunctionalProperty }
    }
  } UNION {
    # Cardinality>1 (datatype) properties
    ?SMC a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Property .
    FILTER NOT EXISTS { ?SMC prov:wasDerivedFrom/a owl:Class }

    ?Value a ?SubmodelElementType ;
      prov:wasDerivedFrom ?Property .
  }

  FILTER (?Value != ?SMC)
}