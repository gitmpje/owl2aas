INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?AAS aasaas:submodels ?Submodel .
  }
}
WHERE {
  ?AAS a aas:AssetAdministrationShell ;
    prov:wasDerivedFrom ?AASClass .

  ?Submodel a aas:Submodel ;
    prov:wasDerivedFrom ?Class .

  {
    ?Property a owl:ObjectProperty ;
      rdfs:domain ?AASClass ;
      rdfs:range ?Class .
  } UNION {
    ?AASClass mas4ai:hasInterface [] .
  }
}