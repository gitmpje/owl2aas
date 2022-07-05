INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Submodel aassm:submodelElements ?SubmodelElement .
  }
}
WHERE {
  {
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?Class .

    ?Property a owl:DatatypeProperty ;
      rdfs:domain ?Class .

    ?SubmodelElement prov:wasDerivedFrom ?Property .
  } UNION {
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?Property .

    ?SubmodelElement a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Property .
    FILTER NOT EXISTS { ?Property owl:maxCardinality 1 }
  }

  #exclude nested submodel elements
  FILTER NOT EXISTS {
    [] a aas:SubmodelElementCollection ;
      aassmc:value ?SubmodelElement .
  }
}