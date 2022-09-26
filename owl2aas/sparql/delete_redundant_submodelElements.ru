DELETE {
  ?Submodel aassm:submodelElements ?SMC2 .
}
WHERE {
  ?Submodel aassm:submodelElements ?SMC , ?SMC2.
  ?SMC aassmc:value ?SMC2 .
}