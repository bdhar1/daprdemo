# All Variables listed here

variable "rg_name" {
  type        = string
  description = "The name of the resource group"
  default     = "dev-vdi-vm005-sandbox-rg"
}

variable "rg_location" {
  type        = string
  description = "The location where the resource will be created"
  default     = "centralus"
}

variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
  default     = "acrdaprdemo1001aa"
}

variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster"
  default     = "aks-dapr-demo"
}

variable "evgt_name" {
  type        = string
  description = "The name of the Event Grid topic"
  default     = "daprdemo1aa-evgt"
}

variable "sbns_name" {
  type        = string
  description = "The name of the Service Bus namespace"
  default     = "daprdemo1-sbns"
}

variable "pgsql_name" {
  type        = string
  description = "Name of the PostgreSQL Flexible Server"
  default     = "daprdemo1aaa"
}

variable "cmdb_name" {
  type        = string
  description = "Name of the Cosmos DB Account"
  default     = "cmdb-daprdemoaa"
}
