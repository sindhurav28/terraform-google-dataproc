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
| region | Region of the dataproc Cluster & Job | 'string | n/a | yes |
| force_delete | Force delete Dataproc job. Default is false | 'bool' | False | no |
| cluster_name | Dataproc Cluster Name | 'string' | n/a | yes |
| create_cluster | True/False: If we want to create a Dataproc cluster along with the job | 'bool' | True | yes |
| graceful_decommission_timeout | Graceful decomissioning time in 's' or 'ms when you change the number of worker nodes directly through a terraform apply. | 'string' | null | no |
| cluster_labels | Labels to be attached to the Dataproc Cluster | map(string) | null | no |
| cluster_staging_bucket | The cloud storage staging bucket used to stage files, such as Hadoop jars, between client machines and the cluster string auto-created by GCP i no 1
| cluster_version | The image version of DataProc to be used I string | "2.1.27-debian11" | no I
1 kms_location | KMs key location to populate your local variable for KMS key I 'string | "us-east4" | no I I cluster_temp _bucket | The Cloud storage temp bucket used to store ephemeral cluster and jobs data, such as Spark and MapReduce history files string auto-created by GCP I no
| cluster_optional_comp | The set of optional components to activate on the cluster like Anaconda, Docker, etc | set(string) | None | no
I cluster_override_properties | A list of override and additional properties(key/value) used to modify the common configuration files used when creating a cluster. See cluster properties in reference.
I map(string) | None | no I
I initialization_action | Script: The script to be executed during initialization of the cluster; timeout: Maximum duration(sec) in which script is allowed to take to execute its action.
I list (object ( script - string, timeout_ sec = optional (number, 300) 7) | [1 I
no I
I master ha | set to 'true to enable 3 master nodes (HA) or 'false' for only 1 master node | bool' | False | no I I master_ instance_type | The instance type of the master node | 'string | "na-standard-4" | no I
I parastardarak type | The disk type of the primary disk attached to each master node, one of pd-ssd' or 'pd-standard'. I string I
master _disk_size | size of the primary disk attached to each master node, specified in GB I number' | "500" | no I | master_local_sed | The amount of local SSD disks that will be attached to each master cluster node | 'number | "" | no I I master_min_cu_platform | The name of a minimum generation of cu family for the master | string | None | no I master_accelerator | The number and type of the accelerator cards exposed to the master instance
'list (object ({ count = number, type
= string 3) I TI I no I
| image _uri I Use a custom image to load pre-installed packages 'string | None I no I