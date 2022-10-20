WITH <http://mas4ai.eu/id/graph/aas/template>
DELETE {
  ?SMC_parent aassmc:value ?SMC .
}
INSERT {
  ?SMC_parent aassmc:value ?ReferenceElement_iri .

  ?ReferenceElement_iri a aas:ReferenceElement ;
    aassem:semanticId [
      a aas:Reference ;
      aasref:keys [
        a aas:Key ;
        aaskey:idType aaskeyt:Iri ;
        aaskey:value ?semanticIdValue ;
      ] ;
    ] ;
    aasrefe:value [
      a aas:Reference ;
      aasref:keys [
        a aas:Key ;
        aaskey:idType aaskeyt:Iri ;
        aaskey:value ?SMC ;
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

  BIND(iri(concat( "http://mas4ai.eu/id/referenceElement/template/", struuid() )) as ?ReferenceElement_iri)
}