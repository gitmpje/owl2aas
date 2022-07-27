INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?AAS aasaas:submodels ?Submodel .
  }
}
WHERE {
  ?AAS a aas:AssetAdministrationShell ;
    prov:wasDerivedFrom ?AASClass .

  ?Submodel a aas:Submodel .

  {
    ?Submodel prov:wasDerivedFrom ?Class, ?Property .
    ?Property a owl:ObjectProperty ;
      rdfs:domain ?AASClass ;
      rdfs:range ?Class .
  } UNION {
    ?Submodel prov:wasDerivedFrom ?AASClass .
    ?AASClass mas4ai:hasInterface [] .
  
    FILTER NOT EXISTS { ?Submodel prov:wasDerivedFrom/a owl:ObjectProperty }
  }
}