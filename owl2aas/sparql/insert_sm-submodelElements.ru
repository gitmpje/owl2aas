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

    # Exclude nested submodel elements
    MINUS {
      ?Submodel a aas:Submodel .

      # Only if the submodel is derived from a cardinality >1 property
      FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/a owl:FunctionalProperty }

      # Only if the submodel is not derived from a AAS class
      FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom /mas4ai:hasInterface [] }
    }
  } UNION {
    # Cardinality >1 (object) properties
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
  }
}