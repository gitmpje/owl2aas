DELETE {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Submodel aassm:submodelElements ?SME_redundant .
}
}
WHERE {
  ?Submodel aassm:submodelElements ?SME , ?SME_redundant.
  ?SME prov:wasDerivedFrom/^rdfs:domain/^prov:wasDerivedFrom ?SME_redundant .
  FILTER(?SME != ?SME_redundant)

  MINUS {
    ?Submodel prov:wasDerivedFrom ?Class , ?Property .
    ?SME_redundant prov:wasDerivedFrom ?Class , ?Property .
    ?Class a owl:Class .
    ?Property rdfs:range ?Class .
  }
  MINUS {
    ?Submodel prov:wasDerivedFrom ?Class , ?Property .
    ?SME_redundant prov:wasDerivedFrom ?Class , ?Property .
    ?Class mas4ai:hasInterface [] .
    ?Property a sh:ObjectProperty .
  }
}