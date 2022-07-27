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
  OPTIONAL {
    ?Resource rdfs:label ?label_en .
    FILTER(lang(?label_en)='en')
  }
  OPTIONAL { ?Object aasrefer:idShort ?_idShort }
  BIND ( REPLACE(str(?Resource), ".+[//#]([a-z0-9_]+)$", "$1") as ?noLabel)
  BIND ( REPLACE(COALESCE(?_idShort, ?label_en, ?label, ?noLabel), "[-//(), ]", "_") AS ?idShort )

  OPTIONAL {
    ?Resource rdfs:comment ?comment .
    OPTIONAL { ?Object aasrefer:description ?_description }
    BIND ( COALESCE(?_description, ?comment) AS ?description )
  }

  OPTIONAL {
    ?Resource skos:prefLabel ?prefLabel .
    OPTIONAL { ?Object aasrefer:displayName ?_displayName }
    BIND ( COALESCE(?_displayName, ?prefLabel) AS ?displayName )
  }
}