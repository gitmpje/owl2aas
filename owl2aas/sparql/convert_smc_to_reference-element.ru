INSERT {
  GRAPH <http://mas4ai.eu/id/graph/aas> {
    ?SMC_parent aassmc:value ?ReferenceElement_iri .

    ?ReferenceElement_iri a aas:ReferenceElement ;
      aassem:semanticId [
        a aas:Reference ;
        aasref:keys [
          a aas:Key ;
          aaskey:idType aaskeyt:IRI ;
          aaskey:value ?semanticIdValue ;
        ] ;
      ] ;
      aasrefe:value [
        a aas:Reference ;
        aasref:keys [
          a aas:Key ;
          aaskey:idType aaskeyt:SubmodelElementCollection ;
          aaskey:value ?SMC ;
        ] ;
      ] ;
      prov:wasDerivedFrom ?Class, ?Property ;
      mas4ai:constructedByQuery "convert_smc_to_reference-element.ru" ;
    .
  }
}
WHERE {
  ?SMC a aas:SubmodelElementCollection ;
    aassem:semanticId/aasref:keys/aaskey:value ?semanticIdValue ;
    prov:wasDerivedFrom ?Class, ?Property .

  ?Class a owl:Class .
  ?Property a owl:ObjectProperty .
  FILTER EXISTS { ?SMC aassmc:value+ ?SMC }

  ?SMC_parent aassmc:value ?SMC .
  MINUS { ?SMC_parent aassmc:value+ ?SMC_parent }

  BIND(iri(concat( "http://mas4ai.eu/id/referenceElement/template/", struuid() )) as ?ReferenceElement_iri)
}