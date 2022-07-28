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
  # Prefer attributes from owl:Class
  { SELECT ?Object (if(bound(?Class), ?Class, ?Property) as ?Resource) {
    ?Object a/rdfs:subClassOf* aas:Referable ;
    OPTIONAL {
      ?Object prov:wasDerivedFrom ?Class .
      { ?Class a owl:Class } UNION { ?Class a rdfs:Class }
    }
    OPTIONAL {
      ?Object prov:wasDerivedFrom ?Property .
      { ?Property a owl:DatatypeProperty } UNION { ?Property a owl:ObjectProperty }
    }
  } }

  ?Object prov:wasDerivedFrom ?Resource .
  OPTIONAL { ?Resource rdfs:label ?label }
  OPTIONAL { ?Resource owl:maxCardinality ?maxCardinality }
  OPTIONAL {
    ?Resource rdfs:label ?label_en .
    FILTER(lang(?label_en)='en')
  }

  BIND ( REPLACE(str(?Resource), ".+[//#]([a-z0-9_]+)$", "$1") as ?noLabel)
  BIND ( REPLACE(COALESCE(?_idShort, ?label_en, ?label, ?noLabel), "[-//(), ]", "_") AS ?_idShort )
  # Plural idShort on SMC for cardinality>1 properties
  BIND (
    IF( EXISTS{?Object a aas:SubmodelElementCollection} && (!BOUND(?maxCardinality) || (?maxCardinality > 1)),
      CONCAT(?_idShort, "s"),
      ?_idShort )
    AS ?idShort
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