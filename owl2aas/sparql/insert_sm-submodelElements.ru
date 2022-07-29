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

    MINUS {
      ?Submodel prov:wasDerivedFrom/a owl:ObjectProperty ;
        prov:wasDerivedFrom/mas4ai:hasInterface [] .
    }
  } UNION {
    VALUES ?SubmodelElementType {aas:ReferenceElement aas:SubmodelElementCollection}

    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?Resource .

    ?SubmodelElement a ?SubmodelElementType ;
      prov:wasDerivedFrom ?Resource .
  }

  # Exclude nested submodel elements
  MINUS {
    [] a aas:SubmodelElementCollection ;
      aassmc:value ?SubmodelElement .

    # Only if they are not linked to a 'main' AAS class
    FILTER NOT EXISTS {
      ?SubmodelElement prov:wasDerivedFrom/a owl:Class ;
        prov:wasDerivedFrom/rdfs:domain/mas4ai:hasInterface [] .
    }
  }
}