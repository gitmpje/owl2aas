DELETE {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?Submodel aassm:submodelElements ?SME_redundant .
  }
}
WHERE {
  ?Submodel aassm:submodelElements ?SME , ?SME_redundant.
  ?SME prov:wasDerivedFrom/^rdfs:domain/^prov:wasDerivedFrom ?SME_redundant .
  FILTER(?SME != ?SME_redundant)

  FILTER NOT EXISTS {
    ?Submodel prov:wasDerivedFrom ?Class , ?Property .
    ?SME_redundant prov:wasDerivedFrom ?Class , ?Property .
    ?Class a owl:Class .
    ?Property rdfs:range ?Class .
  }
  FILTER NOT EXISTS {
    ?Submodel prov:wasDerivedFrom ?Class , ?Property .
    ?SME_redundant prov:wasDerivedFrom ?Class , ?Property .
    ?Class mas4ai:hasInterface [] .
    ?Property a owl:ObjectProperty .
  }
  FILTER NOT EXISTS {
    ?Submodel prov:wasDerivedFrom/a owl:FuntionalProperty .
    MINUS { ?Submodel prov:wasDerivedFrom/mas4ai:hasInterface [] }
  }
}