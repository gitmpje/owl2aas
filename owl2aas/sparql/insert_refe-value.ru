INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?ReferenceElement aasrefe:value [
        a aas:Reference ;
        aasref:keys [
          a aas:Key ;
          aaskey:idType aaskeyt:AssetAdministrationShell ;
          aaskey:value ?_ReferenceAAS ;
        ] ;
      ] ;
    .
  }
}
WHERE {
  ?ReferenceElement a aas:ReferenceElement ;
    prov:wasDerivedFrom ?Class, ?Property .

  ?Property rdfs:range ?Class .

  ?ReferenceAAS a aas:AssetAdministrationShell ;
    prov:wasDerivedFrom ?Class .

  FILTER EXISTS {?Class mas4ai:hasInterface []}

  BIND(str(?ReferenceAAS) as ?_ReferenceAAS)
}