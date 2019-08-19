variable "location" {
    description = "Location where Resources will be deployed"
}

variable "application_plan_tier" {
    description = "Tier of the Application Plan (Free, Shared, Basic, Standard, Premium, Isolated)"
}

variable "application_plan_size" {
    description = "Instance Size of the Application Plan (F1, D1, B1, B2, B3, S1, S2, S3, P1v2, P2v2, P3v2, PC2, PC3, PC4, I1, I2, I3)"
}

variable "application_name" {
    description = "Name of the Application"
}

variable "sql_administrator_login" {
    description = "Login for the Managed SQL Instance"
}

variable "sql_administrator_password" {
    description = "Password for the Managed SQL Instance"
}

variable "environment" {
    description = "Environment of all deployed resources"
}