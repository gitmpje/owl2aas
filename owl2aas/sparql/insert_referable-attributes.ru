INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?Object aasrefer:idShort ?idShort ;
      rdfs:label ?label ;
      aasrefer:description ?description ;
      aasrefer:displayName ?displayName ;
    .
  }
}
WHERE {
  ?Object a/rdfs:subClassOf* aas:Referable .

  { SELECT DISTINCT ?Object (GROUP_CONCAT(DISTINCT ?resourceLabel) as ?_idShort) {
    {
      # In case of a Reference Element, always use both Resource labels in the idShort (independent of the semanticId)
      ?Object a aas:ReferenceElement ;
        prov:wasDerivedFrom ?Resource .

      OPTIONAL { ?Resource rdfs:label ?_resourceLabel }
    } UNION {
      # Get idShort from semanticId Class and/or Property labels
      ?Object aassem:semanticId/aasref:keys/aaskey:value ?semanticId ;
        prov:wasDerivedFrom ?Resource .

      BIND(IRI(?semanticId) AS ?ResourceIri)
      FILTER(?Resource = ?ResourceIri)

      OPTIONAL { ?Resource rdfs:label ?_resourceLabel }

      FILTER NOT EXISTS { ?Object a aas:ReferenceElement }
    } UNION {
      # Get idShort from derived from Resource if there is no semanticId
      ?Object prov:wasDerivedFrom ?Resource .
      OPTIONAL { ?Resource rdfs:label ?_resourceLabel }

      FILTER NOT EXISTS { ?Object aassem:semanticId [] }      
    }

    # Prefer English labels to be used for idShort
    FILTER(lang(?_resourceLabel)="en" || lang(?_resourceLabel)="")
    BIND ( COALESCE(?_resourceLabel, REPLACE(str(?Resource), ".+[//#]([a-zA-Z0-9_-]+)$", "$1")) as ?resourceLabel )
  } GROUP BY ?Object }

  # Plural idShort on Submodel or SMC of not cardinality one properties
  BIND ( REPLACE(?_idShort, "[-//(), ]", "_") AS ?__idShort )
  BIND (
    IF(
      EXISTS {
        ?Object prov:wasDerivedFrom ?Property ;
          (aassm:submodelElements|aassmc:value)/prov:wasDerivedFrom ?Property .
        { ?Property a owl:ObjectProperty } UNION { ?Property a owl:DatatypeProperty }
      } &&
      NOT EXISTS { ?Property a owl:FunctionalProperty },
      CONCAT(?__idShort, "s"),
      ?__idShort
    ) AS ?idShort
  )

  # Get other attributes from a (derived from) Resource
  OPTIONAL {
    ?Object a/rdfs:subClassOf* aas:Referable .

    { SELECT DISTINCT ?Object (SAMPLE(?_description) AS ?description) (SAMPLE(?__displayName) AS ?displayName) {
      ?Object aassem:semanticId/aasref:keys/aaskey:value ?semanticId .

      BIND(IRI(?semanticId) AS ?Resource)
      OPTIONAL {
        ?Resource rdfs:comment ?comment .
        # If comment has no language tag, add default "en" tag
        BIND ( IF(langMatches( lang(?comment), "*" ), ?comment, STRLANG(?comment, "en")) AS ?_description )
      }

      OPTIONAL {
        ?Resource skos:prefLabel ?prefLabel .
        OPTIONAL { ?Object aasrefer:displayName ?_displayName }
        BIND ( COALESCE(?_displayName, ?prefLabel) AS ?__displayName )
      }
    } GROUP BY ?Object }
  }
}