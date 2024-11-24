## Generic Variables

variable "project_id" {
  type        = string
  description = "The project ID to deploy the resources"
}

variable "region" {
  type        = string
  description = "Region of the dataproc cluster"
}

variable "force_delete" {
  type        = bool
  description = "Force delete Dataproc job. Default is false"
  default     = false
}

##################################################################
########### Dataproc Cluster related variables ###################
variable "cluster_name" {
  type        = string
  description = "Dataproc cluster Name"
}
variable "create_cluster" {
  type        = bool
  description = "True/False: If we want to create a Dataproc cluster"
  default     = true
}

variable "graceful_decommission_timeout" {
  type        = string
  description = "Graceful decomissioning time in 's' or 'ms' when you change the number of worker nodes directly through a terraform appiv. "
  default     = null
}

variable "cluster_labels" {
  type        = map(string)
  description = "Labels to be attached to the Dataproc cluster"
  default     = {}
}

variable "cluster_staging_bucket" {
  type        = string
  default     = ""
  description = "The Cloud Storage staging bucket used to stage files, such as Hadoop jars, between client machines and the cluster"
}

variable "cluster_version" {
  type        = string
  description = "The image version of DataProc to be used"
  default     = "2.1.27-debian11"
}

variable "cluster_optional_components" {
  description = "Optional components to enable for the cluster."
  type        = list(string)
  default     = []
}

variable "kms_key_name" {
  type        = string
  description = "The Cloud kMS key name to use for D disk encryption for all instances in the cluster."
  default     = ""
}

variable "cluster_temp_bucket" {
  description = "The Cloud Storage temp bucket used to store ephemeral cluster and jobs data, such as spark and MapReduce history files"
  type        = string
  default     = null
}

variable "cluster_override_properties" {
  description = " A list of override and additional properties(key/value) used to modify the common configuration files used when creating a cluster."
  type        = map(string)
  default     = {}
}

variable "initialization_action" {
  type = list(object({
    script      = string
    timeout_sec = optional(number, 300)
  }))
  description = "Script: The script to be executed during initialization of the cluster; timeout: Maximum duration(sec) in which script is allowed to take to execute its action."
  default     = []
}

# Master/Manager node configuration Variables
variable "master_ha" {
  type        = bool
  description = "Set to 'true' to enable 3 master nodes (HA) or 'false' for only 1 master node"
  default     = false
}

variable "worker_nodes" {
  type        = number
  description = "Set to 'true' to disable master nodes"
  default     = 2
}
variable "master_instance_type" {
  type        = string
  description = "The instance type of the master node"
  default     = "n1-standard-4"
}

variable "master_disk_type" {
  type        = string
  description = "The disk type of the primary disk attached to each master node. One of 'pd-ssd' or 'pd-standard' "
  default     = "pd-standard"
}

variable "master_disk_size" {
  type        = number
  description = "size of the primary disk attached to each master node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, It also contains the HDFS data blocks and Hadoop working directories."
  default     = 500
}

variable "master_local_ssd" {
  type        = number
  description = "The amount of local SSD disks that will be attached to each master cluster node."
  default     = 0
}

variable "master_min_cpu_platform" {
  type        = string
  description = " The name of a minimum generation of CPU family for the master."
  default     = null
}

variable "master_accelerator" {
  description = "Accelerator configurations for the master node."
  type        = list(object({
    count = number
    type  = string
  }))
  default = []
}
# Worker Nodes Configuration variables
variable "image_uri" {
  type        = string
  description = "Use a custom image to load pre-installed packages"
  default     = null
}

variable "worker_instance_type" {
  type        = string
  description = "The instance type of the worker nodes"
  default     = "n1-standard-4"
}

variable "worker_disk_type" {
  type        = string
  description = "The disk type of the primary disk attached to each worker node. One of 'pd-ssd' or 'pd-standard'."
  default     = "pd-standard"
}

variable "worker_disk_size" {
  type        = number
  description = "Size of the primary disk attached to each worker node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories."
  default     = "500"
}

variable "worker_min_cpu_platform" {
  type        = string
  description = "The name of a minimum generation of CPU family for the worker."
  default     = null
}

variable "worker_local_ssd" {
  type        = number
  description = "The amount of local SSD disks that will be attached to each worker cluster node."
  default     = 0
}

variable "worker_accelerator" {
  description = "Accelerator configurations for the worker nodes."
  type        = list(object({
    count = number
    type  = string
  }))
  default = []
}

# Secondary Worker Configs
variable "secondary_worker_min_instances" {
  description = "The number of preemptible worker nodes."
  type        = number
  default     = 0
}

variable "secondary_worker_disk_type" {
  type        = string
  description = "The disk type of the primary disk attached to each worker node. One of 'pd-ssd' or 'pd-standard'."
  default     = "pd-standard"
}

variable "secondary_worker_disk_size" {
  type        = number
  description = "Size of the primary disk attached to each worker node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories."
  default     = "500"
}

variable "secondary_worker_local_ssd" {
  type        = number
  description = "The amount of local SSD disks that will be attached to each worker cluster node."
  default     = 0
}

variable "preemptibility" {
  description = "The preemptibility configuration for the secondary workers."
  type        = string
  default     = "NON_PREEMPTIBLE"
}

variable "network" {
  description = "The network for the cluster."
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork for the cluster."
  type        = string
  default     = null
}

variable "gce_zone" {
  description = "The GCE zone for the cluster."
  type        = string
}

variable "gce_cluster_tags" {
  description = "The tags to assign to GCE instances in the cluster."
  type        = list(string)
  default     = []
}

variable "service_account" {
  description = "The service account for the cluster."
  type        = string
  default     = null
}

variable "internal_ip_only" {
  description = "Whether the cluster uses internal IPs only."
  type        = bool
  default     = false
}

variable "cluster_metadata" {
  description = "Metadata to assign to the cluster."
  type        = map(string)
  default     = {}
}

variable "shield_enable_secure_boot" {
  description = "Enable secure boot for shielded instances."
  type        = bool
  default     = null
}

variable "shield_enable_vtpm" {
  description = "Enable vTPM for shielded instances."
  type        = bool
  default     = null
}

variable "shield_enable_integrity_monitoring" {
  description = "Enable integrity monitoring for shielded instances."
  type        = bool
  default     = null
}

variable "node_group_uri" {
  description = "The URI for the node group affinity."
  type        = string
  default     = null
}

variable "autoscaling_policy_uri" {
  description = "The URI for the autoscaling policy."
  type        = string
  default     = null
}


variable "idle_delete_ttl" {
  description = "Time-to-live for idle clusters."
  type        = string
  default     = null
}

variable "auto_delete_time" {
  description = "The auto-delete time for the cluster."
  type        = string
  default     = null
}

variable "enable_http_port_access" {
  description = "Whether to enable HTTP port access."
  type        = bool
  default     = false
}

variable "dataproc_metastore_service" {
  description = "The Dataproc Metastore service for the cluster."
  type        = string
  default     = null
}

variable "metric_source" {
  description = "The metric source for the Dataproc metrics configuration."
  type        = string
  default     = null
}

variable "metric_overrides" {
  description = "Overrides for Dataproc metrics."
  type        = list(string)
  default     = []
}

##################################################################
########### Dataproc Job related variables ###################

variable "dataproc_job_labels" {
  description = "Labels to assign to the Dataproc job."
  type        = map(string)
  default     = {}
}

variable "scheduling" {
  description = "Scheduling configuration for the Dataproc job."
  type = object({
    max_failures_per_hour = optional(number)
    max_failures_total    = optional(number)
  })
  default = null
}

variable "pyspark_config" {
  description = "Configuration for a PySpark job."
  type = object({
    main_python_file_uri = optional(string)
    args                 = optional(list(string))
    properties           = optional(map(string))
    python_file_uris     = optional(list(string))
    jar_file_uris        = optional(list(string))
    file_uris            = optional(list(string))
    archive_uris         = optional(list(string))
    logging_config = optional(object({
      driver_log_levels = map(string)
    }))
  })
  default = {}
}

variable "spark_config" {
  description = "Configuration for a Spark job."
  type = object({
    main_class        = optional(string)
    main_jar_file_uri = optional(string)
    args              = optional(list(string))
    properties        = optional(map(string))
    jar_file_uris     = optional(list(string))
    file_uris         = optional(list(string))
    archive_uris      = optional(list(string))
    logging_config = optional(object({
      driver_log_levels = map(string)
    }))
  })
  default = {}
}

variable "hadoop_config" {
  description = "Configuration for a Hadoop job."
  type = object({
    main_class        = optional(string)
    main_jar_file_uri = optional(string)
    args              = optional(list(string))
    properties        = optional(map(string))
    jar_file_uris     = optional(list(string))
    file_uris         = optional(list(string))
    archive_uris      = optional(list(string))
    logging_config = optional(object({
      driver_log_levels = map(string)
    }))
  })
  default = {}
}

variable "hive_config" {
  description = "Configuration for a Hive job."
  type = object({
    query_file_uri      = optional(string)
    query_list          = optional(list(string))
    continue_on_failure = optional(bool)
    properties          = optional(map(string))
    script_variables    = optional(map(string))
    jar_file_uris       = optional(list(string))
  })
  default = {}
}

variable "pig_config" {
  description = "Configuration for a Pig job."
  type = object({
    query_file_uri      = optional(string)
    query_list          = optional(list(string))
    continue_on_failure = optional(bool)
    properties          = optional(map(string))
    script_variables    = optional(map(string))
    jar_file_uris       = optional(list(string))
    logging_config = optional(object({
      driver_log_levels = map(string)
    }))
  })
  default = {}
}

variable "sparksql_config" {
  description = "Configuration for a Spark SQL job."
  type = object({
    query_file_uri   = optional(string)
    query_list       = optional(list(string))
    properties       = optional(map(string))
    jar_file_uris    = optional(list(string))
    script_variables = optional(map(string))
    logging_config = optional(object({
      driver_log_levels = map(string)
    }))
  })
  default = {}
}

variable "presto_config" {
  description = "Configuration for a Presto job."
  type = object({
    query_file_uri      = optional(string)
    query_list          = optional(list(string))
    continue_on_failure = optional(bool)
    properties          = optional(map(string))
    client_tags         = optional(list(string))
    output_format       = optional(string)
    logging_config = optional(object({
      driver_log_levels = map(string)
    }))
  })
  default = {}
}