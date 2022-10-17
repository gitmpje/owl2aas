INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Object aasrefer:idShort ?idShort ;
      rdfs:label ?label ;
      aasrefer:description ?description ;
      aasrefer:displayName ?displayName ;
    .
  }
}
WHERE {
  # Join Property and Class label
  { SELECT
      ?Object
      (CONCAT(?propertyLabel, "__", ?classLabel) as ?_idShort)
      (IF(bound(?Class), ?Class, ?_Property) as ?Resource)
      (IF(BOUND(?_Property), ?_Property, BNODE()) AS ?Property)
    WHERE {
        ?Object a/rdfs:subClassOf* aas:Referable ;
        OPTIONAL {
          ?Object aassem:semanticId/aasref:keys/aaskey:value ?Class .
          ?Class a owl:Class ;
            rdfs:label ?classLabel .
        }
        OPTIONAL {
          ?Object aassem:semanticId/aasref:keys/aaskey:value ?_Property .
          { ?_Property a owl:DatatypeProperty } UNION { ?_Property a owl:ObjectProperty }
          ?_Property rdfs:label ?propertyLabel .
        }
  } }

  ?Object prov:wasDerivedFrom ?Resource .
  ?Resource rdfs:label ?label .
  OPTIONAL {
    ?Resource rdfs:label ?label_en .
    FILTER(lang(?label_en)='en')
  }

  BIND ( REPLACE(str(?Resource), ".+[//#]([a-z0-9_]+)$", "$1") as ?noLabel)
  BIND ( REPLACE(COALESCE(?_idShort, ?label_en, ?label, ?noLabel), "[-//(), ]", "_") AS ?_idShort )

  # Plural idShort on Submodel or SMC of not cardinality one properties
  BIND (
    IF(
      EXISTS {
        ?Object prov:wasDerivedFrom ?Class , ?Property ;
          (aassm:submodelElements|aassmc:value)/prov:wasDerivedFrom ?Class , ?Property .
        ?Class a owl:Class .
        { ?Property a owl:ObjectProperty } UNION { ?Property a owl:DatatypeProperty }
      } &&
      NOT EXISTS { ?Property a owl:FunctionalProperty },
      CONCAT(?_idShort, "s"),
      ?_idShort
    ) AS ?idShort
  )

  OPTIONAL {
    ?Resource rdfs:comment ?comment .
    # If comment has no language tag, add default "en" tag
    BIND ( IF(langMatches( lang(?comment), "*" ), ?comment, STRLANG(?comment, "en")) AS ?description )
  }

  OPTIONAL {
    ?Resource skos:prefLabel ?prefLabel .
    OPTIONAL { ?Object aasrefer:displayName ?_displayName }
    BIND ( COALESCE(?_displayName, ?prefLabel) AS ?displayName )
  }
}