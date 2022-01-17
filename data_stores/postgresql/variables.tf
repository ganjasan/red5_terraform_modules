variable "snapshot_db_instance_identifier" {
  description = "If setted will be used last snapshot for db restore"
  type        = string
  default     = null
}

variable "db_name" {
  description = "Name of the database without environment postfix"
  type        = string
}

variable "port" {
  description = "DB open port"
  type        = string
  default     = 3306
}

variable "environment" {
  description = "Environment name"
  type        = string
}

# All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL
variable "engine_version" {
  description = "PostgreSQL engine version."
  type        = string
}

variable "db_family" {
  description = "Postgresql family. Example-postgres12"
  type        = string
}

variable "major_engine_version" {
  description = "Major postgresql version. Example-12 "
  type        = string
}

variable "instance_class" {
  description = "DB instance class"
  type        = string
}

variable "subnets_ids" {
  description = "Subnets ids list"
  type        = list(string)
}

variable "db_security_groups" {
  description = "VPC security groups for this db"
  type        = list(string)
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}
