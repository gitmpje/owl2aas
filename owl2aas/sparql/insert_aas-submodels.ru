INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas/template> {
    ?AAS aasaas:submodels [
      a aas:Reference ;
      aasref:type aasreft:ModelReference ;
      aasref:keys [
        a aas:Key ;
        aaskey:type aaskeyt:Submodel ;
        aaskey:value ?SubmodelReference ;
      ]
    ] .
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

  BIND(STR(?Submodel) AS ?SubmodelReference)
}