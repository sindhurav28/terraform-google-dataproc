resource "google_dataproc_job" "dataproc_job" {
    region          = var.region
    force_delete    = var.force_delete
    project         = var.project_id
    labels          = var.dataproc_job_labels
    placement {
        cluster_name = var.create_cluster == true ? google_dataproc_cluster.cluster[0].name : var_cluster_name
    }
    dynamic "scheduling" {
        for_each = var_scheduling == null ? toset ([]) : toset ([var.scheduling])
        content {
            max_failures_per_hour = lookup(scheduling.value, "max_failures_per_hour", null)
            max_failures_total = lookup(scheduling.value, "max_failures_total", null)
        }
    }
    dynamic "pyspark_config" {
        for_each = length(keys(var.pyspark_config)) == 0 ? toset([]) : toset([var.pyspark config])
        content {
            main_python_file_uri = lookup(pyspark_config.value, darin p then, file unt", nola)
        = lookup (pyspark_ config. value,
        properties
        lookup(pyspark_config. value,
        "properties", null)
        python file uris
        = 100kup (pyspark_config. value,
        "python_file_uris", null)
        jar_file_uris
        = 100kup (pyspark_ config. value,
        "jar _file uris™, null)
        file uris
        10okup (pyspark config. value, "file unis", null)
        archive uris
        = 100kup (pyspark_config. value,
        "archive _uris", null)
        dynamic
        "logging_config" {
        for _each = lookup (pyspark config.value, "logging config", null) =- null ? toset ([J) : toset ([Lookup (pyspark config.value,
        "logging
        content {
        driver_log levels = logging_ config. value. driver_log_levels