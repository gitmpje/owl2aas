INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?ElementSemanticReference aasref:keys [
      a aas:Key ;
      aaskey:idType aaskeyt:Iri ;
      aaskey:value ?SemanticId ;
    ] .
  }
}
WHERE {
  VALUES ?ElementType { aas:Submodel aas:SubmodelElementCollection aas:ReferenceElement }
  ?Element a ?ElementType ;
    aassem:semanticId ?ElementSemanticReference ;
    prov:wasDerivedFrom ?SemanticId .

  FILTER EXISTS {
    {
      # An element should already have a semantic identifier for a cardinality one property
      ?ElementSemanticReference aasref:keys/aaskey:value/a owl:FunctionalProperty .
    } UNION {
      # Or a class, but then the new semantic id should be a cardinality one property
      ?ElementSemanticReference aasref:keys/aaskey:value/a owl:Class .
      ?SemanticId a owl:FunctionalProperty .
    }
  }

  # The semantic identifier should not be a class for which an AAS is constructed
  FILTER NOT EXISTS { ?SemanticId mas4ai:hasInterface []}

  # An element should not already have the semantic identifier
  FILTER NOT EXISTS { ?ElementSemanticReference aasref:keys/aaskey:value ?SemanticId }
}