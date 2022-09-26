DELETE {
    ?SMC_parent aassmc:value ?SMC .
}
WHERE {
    ?SMC a aas:SubmodelElementCollection ;
        aassmc:value+ ?SMC .

    ?SMC_parent a aas:SubmodelElementCollection ;
        aassmc:value ?SMC .
}