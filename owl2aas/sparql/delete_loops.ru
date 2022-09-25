DELETE {
    ?SMC_parent aassmc:value ?SMC .
}
WHERE {
    # ?Submodel a aas:Submodel ;
    #     aassm:submodelElements ?SMC .
    ?SMC a aas:SubmodelElementCollection ;
        aassmc:value+ ?SMC .

    ?SMC_parent a aas:SubmodelElementCollection ;
        aassmc:value ?SMC .
}