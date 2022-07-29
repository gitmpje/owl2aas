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
  { SELECT ?Object (if(bound(?Class), ?Class, ?_Property) as ?Resource) (IF(BOUND(?_Property), ?_Property, BNODE()) AS ?Property) ?maxCardinality {
    ?Object a/rdfs:subClassOf* aas:Referable ;
    OPTIONAL {
      ?Object prov:wasDerivedFrom ?Class .
      ?Class a owl:Class .
    }
    OPTIONAL {
      ?Object prov:wasDerivedFrom ?_Property .
      { ?_Property a owl:DatatypeProperty } UNION { ?_Property a owl:ObjectProperty }
      OPTIONAL { ?_Property owl:maxCardinality ?maxCardinality }
    }
  } }

  ?Object prov:wasDerivedFrom ?Resource .
  OPTIONAL { ?Resource rdfs:label ?label }
  OPTIONAL {
    ?Resource rdfs:label ?label_en .
    FILTER(lang(?label_en)='en')
  }

  BIND ( REPLACE(str(?Resource), ".+[//#]([a-z0-9_]+)$", "$1") as ?noLabel)
  BIND ( REPLACE(COALESCE(?_idShort, ?label_en, ?label, ?noLabel), "[-//(), ]", "_") AS ?_idShort )
  # Plural idShort on SMC for cardinality>1 properties
  BIND (
    IF( EXISTS{?Object (aassm:submodelElements|aassmc:value)/prov:wasDerivedFrom ?Property} &&
      (!BOUND(?maxCardinality) || (?maxCardinality > 1)),
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