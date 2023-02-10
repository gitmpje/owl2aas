WITH <http://mas4ai.eu/id/graph/aas/template>
DELETE {
  ?SMC_parent aassmc:value ?SMC .
}
INSERT {
  ?SMC_parent aassmc:value ?ReferenceElement_iri .

  ?ReferenceElement_iri a aas:ReferenceElement ;
    aassem:semanticId [
      a aas:Reference ;
      aasref:type aasreft:GlobalReference ;
      aasref:keys [
        a aas:Key ;
        aaskey:type aaskeyt:GlobalReference ;
        aaskey:value ?semanticIdValueStr ;
      ] ;
    ] ;
    aasrefe:value [
      a aas:Reference ;
      aasref:type aasreft:ModelReference ;
      aasref:keys [
        a aas:Key ;
        aaskey:type aaskeyt:SubmodelElementCollection ;
        aaskey:value ?SMCStr ;
      ] ;
    ] ;
    prov:wasDerivedFrom ?Class, ?Property ;
    mas4ai:constructedByQuery "convert_smc_to_reference-element.ru" ;
  .
}
WHERE {
  ?SMC a aas:SubmodelElementCollection ;
    aassem:semanticId/aasref:keys/aaskey:value ?_semanticIdValue ;
    prov:wasDerivedFrom ?Class, ?Property .

  GRAPH <http://mas4ai.eu/id/graph/owl> {
    ?Class a owl:Class .
    ?Property a owl:ObjectProperty .
  }

  # SMC should be in a circular reference
  FILTER EXISTS { ?SMC aassmc:value+ ?SMC }

  BIND(strdt(str(?semanticIdValue), xsd:string) AS ?semanticIdValueStr)
  BIND(strdt(str(?SMC), xsd:string) AS ?SMCStr)
  BIND(iri(concat( "http://mas4ai.eu/id/referenceElement/template/", struuid() )) as ?ReferenceElement_iri)
}