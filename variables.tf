## Generic Variables

variable "project_id" {
    type        = string
    description = "The project ID to deploy the resources"
}

variable "region" {
    type        = string
    description =  "Region of the dataproc cluster"
}

variable "force_delete" {
    type        = bool
    description = "Force delete Dataproc job. Default is false"
    default     = false
}

##################################################################
########### Dataproc Cluster related variables ###################
variable "cluster name" {
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

variable "cluster_optional_comp" {
    description = "The set of optional components to activate on the cluster."
    type        = set(string)
    default     = []
}

variable "cluster_override_properties" {
    description = " A list of override and additional properties(key/value) used to modify the common configuration files used when creating a cluster."    
    type        = map(string)
    default     = {}
}

variable "initialization_action" {
    type = list(object({
        script  = string
        timeout_sec = optional (number, 300)
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
    default = "pd-standard" 
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

variable "master accelerator" {
    type  = list(object({
        count = number
        type = string
    }))
    description = "The number and type of the accelerator cards exposed to the master instance."
    default     = []
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
    description = "Size of the primary disk attached to each worker node, specified in GB. The primary disk contains the boot volume and system libraries, and the smallest allowed disk size is 10GB. GCP will default to a predetermined computed value if not set (currently 500GB). Note: If SSDs are not attached, it also contains the HDFS data blocks and Hadoop working directories.
    default     = 500
}

variable "worker_min _cpu_platform" {
    type        = string
    description = "The name of a minimum generation of CPU family for the worker."
    default     = null
}

variable "worker_local_ssd"
