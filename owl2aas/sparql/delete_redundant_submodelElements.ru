DELETE {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?Submodel aassm:submodelElements ?SMC2 .
}
}
WHERE {
  ?Submodel aassm:submodelElements ?SMC , ?SMC2.
  ?SMC aassmc:value ?SMC2 .

  MINUS {
    ?Submodel prov:wasDerivedFrom ?Class , ?Property .
    ?SMC2 prov:wasDerivedFrom ?Class , ?Property .
    ?Class a owl:Class .
    ?Property a owl:ObjectProperty .
  }
  MINUS {
    ?Submodel prov:wasDerivedFrom/a owl:FunctionalProperty .
  }
}