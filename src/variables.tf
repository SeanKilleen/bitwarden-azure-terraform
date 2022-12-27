variable "envName" {
  type = string
}

variable "dbSAAccountName" {
  type        = string
  description = "the SA Account name for the SQL DB that BitWarden uses"
}
variable "dbSAAccountPassword" {
  type        = string
  description = "the SA Account password for the SQL DB that BitWarden uses"
}
