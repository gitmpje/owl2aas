INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
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

    # Exclude nested submodel elements
    MINUS {
      ?Submodel a aas:Submodel .

      # Only if the submodel is derived from a not cardinality one property
      FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/a owl:FunctionalProperty }

      # Only if the submodel is not derived from an AAS class
      FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/mas4ai:hasInterface [] }
    }
  } UNION {
    # Nested properties for 'cardinality one submodel'
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom/a owl:FunctionalProperty ;
      prov:wasDerivedFrom ?Class .

    ?SubmodelElement a/rdfs:subClassOf+ aas:SubmodelElement ;
      prov:wasDerivedFrom ?Property .

    ?Property rdfs:domain ?Class .

    # The element should not be derived from a class, unless it is a cardinality one property
    FILTER ( 
      NOT EXISTS { ?SubmodelElement prov:wasDerivedFrom/a owl:Class } ||
      EXISTS { ?Property a owl:FunctionalPropertys }
    )
  } UNION {
    # Non cardinality one object properties
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?Class, ?Property .

    ?SubmodelElement a aas:SubmodelElementCollection ;
      prov:wasDerivedFrom ?Class, ?Property .

    ?Class rdfs:range ?Property .
  } UNION {
    ?Submodel a aas:Submodel ;
      prov:wasDerivedFrom ?Property .

    ?SubmodelElement a aas:ReferenceElement ;
      prov:wasDerivedFrom ?Property .

    ?Property a owl:ObjectProperty .
  }
}