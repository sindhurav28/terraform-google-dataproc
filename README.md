# terraform-google-dataproc
Terraform module for creating Dataproc jobs and Dataproc cluster on Google Cloud.

## Features
This module creates a Dataproc Cluster(currently only clusters on Compute Engine is supported) and a Dataproc job. If you want to use an existing cluster to create a dataproc job, the value for create cluster should be set "false" and call the existing cluster from data/locals block.

### Dataproc Cluster
1. The Dataproc cluster created with the default image dataproc cluster _version:2.1-debian11[The latest cluster version during module development]. You can override this variable with the required Dataproc cluster image version.
2. The Dataproc cluster has three types: Standard(1 master, N workers), single Node(1 master, © workers), High availability(3 masters, N workers).
By default, a standard cluster: 1 master, 2 workers are created.
For High availability clusters, please set the variable master_ha = true.
For single node clusters, please set the worker_ nodes = 0.
ou can also increase/decrease the worker nodes count by setting the variable: "worker _nodes".
3. It is recommended to use a service account for the cluster by calling it in the locals block. For project security, the service account scopes are not enabled inside the module. This Service account requires the cloud KMS Encrypter/Decrypter Role.
4. By default, clusters are not restricted to internal IP addresses, and will have ephemeral external IP addresses assigned to each instance. If set to true, all instances in the cluster will only have internal I addresses. Note: Private Google Access (also known as privateIpGoogleAccess) must be enabled in the subnetwork that the cluster will be launched in.
5. If you don't explicitly specify a cluster staging bucket then GCP will auto create / assign one for you. However, you are not guaranteed an auto generated bucket which is solely dedicated to your cluster; it may be shared with other clusters in the same region/zone also choosing to use the auto generation option.
6. This module supports autposcaling policy. Provide the policy details in locals block as an input to the module.
7. Reservation affinity for zonal reservation is not yet supported by the module. Defaults to "any"
8. Kerberos and Hadoop Secure Mode is not yet supported by the module.

### Dataproc Job
The below dataproc job configurations are supported by the module:
    a. Pyspark job
    b. Spark job
    c. Hadoop job
    d. Hive job
    e. Pig job
    f. SparkSql Jobs
    g. Presto jobs




Sample Usage
------------
```hcl
module "dataproc" {
    source       = "REPO_URL"
    version      = "{LATEST MODULE_VERSION}"
    project_id   = "{YOUR_PROJECT_ID}"
    region       = "{YOUR_REGION}"
    kms_key_name = "{KMS_KEY_NAME}"

    #Dataproc Cluster variables
    cluster_name = "cluster-dataproc-test1"
    cluster_staging_bucket = "gs://staging-bucket"
    cluster_temp_bucket = "gs://temp-bucket"
    initialization_action = [
        {
            script = "gs://dataproc-initialization-actions/stackdriver/stackdriver.sh"
            timeout_sec = 500
        },
        {
            script = "gs://dataproc-initialization-actions/python/conda-install.sh"
        }
    ]
    
    node_group_uri = "sample_node_group_uri"
    idle_delete_ttl = "10m"
    dataproc_metastore_service = "projects/projectId/locations/region/services/serviceName"
    metric_source = "SPARK"
    metric_overrides = ["yarn:ResourceManager:JvmMetrics:MemHeapMaxM", "yarn:ResourceManager:JvmMetrics:MemHeapmaxM"]

    # Dataproc Job Variables
    dataproc_job_labels = {
        "env" = "poc"
        }
    scheduling = {
        max_failures_per_hour = "1",
        max_failures_total = "5"
        }
    hadoop_config = {
        main_jar_file_uri = "file:///usr/lib/hadoop-mapreduce/hadoop-mapreduce-examples.jar"
        args = [
            "wordcount",
            "file:///usr/lib/spark/NOTICE",
            "gs://dataproc-staging-<region›-<project_id>-fhmninzv/hadoopjob_output"
            ]            
        logging_config = {
            driver_log_levels = {
            "root" = "INFO"
            }
        }
    }
}
```

Inputs
========
| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| project \_id | The ID of the project to create the Dataproc Cluster & Job | 'string' | n/a | yes |
| region | Region of the dataproc Cluster & Job | 'string' | n/a | yes |
| force_delete | Force delete Dataproc job. Default is false | 'bool' | False | no |
| cluster_name | Dataproc Cluster Name | 'string' | n/a | yes |
| create_cluster | True/False: If we want to create a Dataproc cluster along with the job | 'bool' | True | yes |
| graceful_decommission_timeout | Graceful decomissioning time in 's' or 'ms when you change the number of worker nodes directly through terraform apply. | 'string' | null | no |
| cluster_labels | Labels to be attached to the Dataproc Cluster | 'map(string)' | null | no |
| cluster_staging_bucket | The cloud storage staging bucket used to stage files, such as Hadoop jars, between client machines and the cluster | 'string' | auto-created by GCP | no |
| cluster_version | The image version of DataProc to be used | 'string' | "2.1.27-debian11" | no |
| kms_location | KMS key location to populate your local variable for KMS key | 'string' | "us-east4" | no |
| cluster_temp_bucket | The Cloud storage temp bucket used to store ephemeral cluster and jobs data, such as Spark and MapReduce history files | 'string' | auto-created by GCP | no |
| cluster_optional_comp | The set of optional components to activate on the cluster like Anaconda, Docker, etc | 'set(string)' | None | no |
| cluster_override_properties | A list of override and additional properties(key/value) used to modify the common configuration files used when creating a cluster. See cluster properties under references | 'map(string)' | None | no |
| initialization_action | Script: The script to be executed during initialization of the cluster; timeout: Maximum duration(sec) in which script is allowed to take to execute its action | 'list(object({ script = string, timeout_ sec = optional(number, 300)  }))' | [] | no |
| master_ha | set to 'true' to enable 3 master nodes (HA) or 'false' for only 1 master node | 'bool' | False | no |
| master_instance_type | The instance type of the master node | 'string' | "n1-standard-4" | no |
| master_disk_type | The disk type of the primary disk attached to each master node, one of 'pd-ssd' or 'pd-standard' | 'string' | "pd-standard" | no |
| master_disk_size | size of the primary disk attached to each master node, specified in GB | 'number' | "500" | no |
| master_local_ssd | The local SSD disks that will be attached to each master cluster node | 'number | 0 | no |
| master_min_cpu_platform | The name of a minimum generation of cpu family for the master | 'string' | None | no |
| master_accelerator | The number and type of the accelerator cards exposed to the master instance |'list(object({ count = number, type= string }))' | [] | no |
| image_uri | Use a custom image to load pre-installed packages | 'string' | None | no |
| worker_instance_type | The disk type of the primary disk attached to each worker node. One of 'pd-ssd" or 'pd-standard'. | 'string' |"pd-standard" | no |
| worker_disk_size | size of the primary disk attached to each worker node, specified in GB. | 'number' | 500 | no |
| worker_min_cpu_platform | The name of a minimum generation of CPU family for the worker. | 'string' | None | no
| worker_local_ssd | Local SSD disks that will be attached to each worker cluster node. | 'number' | 0 | no |
| worker_accelerator | The number and type of the accelerator cards exposed to the worker instance | 'list(object({count = number, type = string }))' | [] | no |
| secondary_worker_min_instances | The minimum number of secondary worker instances | 'number' | 0 | no |
| preemptibility | Preemptibility of the secondary workers. If specified the secondary worker VMs | string | "PREEMPTIBLE" | no |   
| secondary_worker_disk_type | The disk type of the primary disk attached to each secondary worker node. One of 'pd-ssd' or 'pd-standard' |'string' | "pd-standard" | no |
| secondary_worker_disk _size | size of the primary disk attached to each secondary worker node, specified in GB. | 'number' | 500 | no |
| secondary_worker_local_ssd | The amount of local SSD disks that will be attached to each secondary worker cluster node. | 'number' | 0 | no |
| network | The name or self_link of the Google Compute Engine network to the cluster will be part of. Conflicts with subnetwork | 'string' | default | no |
| gce_zone | The GCP zone where your data is stored and used (i.e. where the master and the worker nodes will be created in) | 'string' | null | no |
| gce_cluster_tags | The list of instance tags applied to instances in the cluster. Tags are used to identify valid sources or targets for network firewalls | 'set(string)' | [] | no |
| service_account | The service account for the cluster | 'string' | <default-sa> | no |
| internal_ip_only | If set to true, all instances in the cluster will only have internal IP addresses | 'bool' | True | no | 
| cluster_metadata | A map of the compute Engine metadata entries to add to all instances | 'map(string)' | {} | no |
| sheild_enable_secure_boot | Defines whether instances have secure Boot enabled | 'bool' | null | no | 
| shield_enable_vtpm | Defines whether instances have the VTPM enabled. | 'bool' | null | no | 
| shield_intergrity_mon | Defines whether instances have integrity monitoring enabled. | 'bool' | null | no | 
| node_group_uri | The URI of a sole-tenant node group resource that the cluster will be created on. | 'string' |null | no |
| idle_delete_ttl | The duration to keep the cluster alive while idling (no jobs running). After this TTL, the cluster will be deleted. Valid range: [10m, 14d] | 'string' | null | no |
| auto_delete_time | The time when cluster will be auto-deleted. A timestamp in RFC3339 UTC 'Zulu' format, accurate to nanoseconds |'string' | null | no |
| enable_http_port_access | The flag to enable http access to specific ports on the cluster from external sources (aka ComponentGateway). | 'bool' | False | no |
| dataproc_metastore_service | Resource name of an existing Dataproc Metastore service. Only resource names including projectid and location (region) are valid | 'string' | null | no |
| metric_source | Required to enable custom metric collection. Specify one or more of the following metric sources: [MONITORING_AGENT_DEFAULTS HDFS SPARK YARN SPARK_HISTORY_SERVER HIVESERVER2] | 'string' | <default-sa> | no |
| metric_overrides | One or more available OSs metrics to collect for the metric course | 'set(string)' | [] | no |
| dataproc_job_labels | Labels to be attached to the Dataproc Cluster | 'map(string)' | {} | no |
| scheduling | Maximun driver restarts per hour and in total | 'object({ max_failures_per_ hour = string, max_failures_total=string})' | null | no |
| pyspark_config | pyspark job configuration | 'any' | {} | no |
| spark_config | spark job configuration | 'any | {} | no |
| hadoop_config | hadoop job configuration | 'any' | {} | no |
| hive_config | Hive job configuration | 'any' | {} | no | 
| pig_config | Pig job configuration | 'any' | {} | no | 
| sparksql_config | sparkSql job configuration | 'any' | {} | no | 
| presto_config | Presto job configuration | 'any | {} | no |

Outputs
========
| Name | Description |
| ---- | ----------- |
| cluster_name | Name of the Dataproc cluster |

Caveats[Terraform Level]
=========================
1. The terraform resource for dataproc job does not support 'update' and changing any attributes will cause the dataproc job resource to be recreated.
2. Note that Dataproc Cluster metric source is case sensitive: "SPARK" is accepted but "spark" is not accepted.
3. The cloud Dataproc API can return unintuitive error messages when using accelerators; even when you have defined an accelerator, Auto Zone Placement does not exclusively select zones that have that accelerator available. If you get a 400 error that the accelerator can't be found, this is a likely cause, Make sure you check accelerator availability by zone(https://cloud.google.com/compute/docs/reference/rest/v1/acceleratortypes/list) if you are trying to use accelerators in a given zone.

## Requirements
Before this module can be used on a project, you must ensure that the following pre-requisites are fulfilled:
1. Terraform is installed on the environment where Terraform is being executed.
2. The Service Account you execute the module with has the right permissions.
3. The necessary APIs are active on the project.
4. A working Dataflow template in uploaded in a GCS bucket
The project factory can be used to provision projects with the correct APIs active.

### Software
The following dependencies must be available:
- Terraform >= 0.13.0 you can choose the binary here:
https://releases.hashicorp.com/terraform/
- terraform-provider-google plugin v2.18.0

## APIs
A project with the following APIs enabled must be used to host the resources of this module:
- Dataproc API: 'dataproc.googleapis.com'
Note: If you want to use a Customer Managed Encryption Key, the cloud key Management Service (KMS) API must be enabled:
- Cloud Key Management Service (KMS) API: 'cloudkms.googleapis.com'

## References
1. https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dataproc_job
2. Minimun CPU Platform for master and worker nodes:
    https://cloud.google.com/compute/docs/instances/specify-min-cpu-platform
3. Dataproc cluster image versions list:
    https://cloud.google.com/dataproc/docs/concepts/versioning/dataproc-version-clusters
4. Dataproc cluster properties:
    https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/cluster-properties
5. Dataproc autozone placement:
    https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/auto-zone
6. Avalable Dataproc OSS metrics for the cluster:
    https://cloud.google.com/dataproc/docs/guides/dataproc-metrics#available_os_metrics
7. Dataproc cluster custom network firewall requirements:
    https://cloud.google.com/dataproc/docs/concepts/configuring-clusters/network#firewall_rule_requirement
8. Dataproc Cluster optional components:
    https://cloud.google.com/dataproc/docs/concepts/components/overview#available_optional_components

Authors
==========
{CODEOWNER}