variable "location" {
  description = "The supported Azure location where the resource deployed"
  type        = string
}

variable "environment_name" {
  description = "The name of the azd environment to be deployed"
  type        = string
}

variable "principal_id" {
  description = "The Id of the azd service principal to add to deployed keyvault access policies"
  type        = string
  default     = "e55fd960-0a37-471f-bc20-0e636d737258"
}

variable "useAPIM" {
  description = "Flag to use Azure API Management to mediate the calls between the Web frontend and the backend API."
  type        = bool
  default     = false
}
