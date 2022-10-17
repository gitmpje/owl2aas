INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?ElementSemanticReference aasref:keys [
      a aas:Key ;
      aaskey:idType aaskeyt:Iri ;
      aaskey:value ?SemanticId ;
    ] .
  }
}
WHERE {
  VALUES ?ElementType { aas:Submodel aas:SubmodelElementCollection }
  ?Element a ?ElementType ;
    aassem:semanticId ?ElementSemanticReference ;
    prov:wasDerivedFrom ?SemanticId .

  # A Submodel and its child elements should not have a class semantic identifier
  FILTER NOT EXISTS {
    { ?Element a aas:Submodel ; aassem:semanticId/aasref:keys/aaskey:value/a owl:Class }
    UNION
    { ?Element a aas:Submodel ; (aassm:submodelElements|aassmc:value)/aassem:semanticId/aasref:keys/aaskey:value/a owl:Class }
  }

  # An element or its parent element should not have the semantic identifier
  FILTER NOT EXISTS {
    { ?Element ^(aassm:submodelElements|aassmc:value)/aassem:semanticId/aasref:keys/aaskey:value ?SemanticId }
    UNION
    { ?Element aassem:semanticId/aasref:keys/aaskey:value ?SemanticId }
  }

  # The semantic identifier should not be a class for which an AAS is constructed
  FILTER NOT EXISTS { ?SemanticId mas4ai:hasInterface []}
}