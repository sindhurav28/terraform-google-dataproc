resource "google_dataproc_job" "dataproc_job" {
  region       = var.region
  force_delete = var.force_delete
  project      = var.project_id
  labels       = var.dataproc_job_labels
  placement {
    cluster_name = var.create_cluster == true ? google_dataproc_cluster.cluster[0].name : var.cluster_name
  }
  dynamic "scheduling" {
    for_each = var.scheduling == null ? toset([]) : toset([var.scheduling])
    content {
      max_failures_per_hour = lookup(scheduling.value, "max_failures_per_hour", null)
      max_failures_total    = lookup(scheduling.value, "max_failures_total", null)
    }
  }
  dynamic "pyspark_config" {
    for_each = length(keys(var.pyspark_config)) == 0 ? toset([]) : toset([var.pyspark_config])
    content {
      main_python_file_uri = lookup(pyspark_config.value, "main_python_file_uri", null)
      args                 = lookup(pyspark_config.value, "args", null)
      properties           = lookup(pyspark_config.value, "properties", null)
      python_file_uris     = lookup(pyspark_config.value, "python_file_uris", null)
      jar_file_uris        = lookup(pyspark_config.value, "jar_file_uris", null)
      file_uris            = lookup(pyspark_config.value, "file_uris", null)
      archive_uris         = lookup(pyspark_config.value, "archive_uris", null)
      dynamic "logging_config" {
        for_each = lookup(pyspark_config.value, "logging_config", null) == null ? toset([]) : toset([lookup(pyspark_config.value, "logging_config")])
        content {
          driver_log_levels = logging_config.value.driver_log_levels
        }
      }
    }
  }
  dynamic "spark_config" {
    for_each = length(keys(var.spark_config)) == 0 ? toset([]) : toset([var.spark_config])
    content {
      main_class        = lookup(spark_config.value, "main_class", null)
      main_jar_file_uri = lookup(spark_config.value, "main_jar_file_uri", null)
      args              = lookup(spark_config.value, "args", null)
      properties        = lookup(spark_config.value, "properties", null)
      jar_file_uris     = lookup(spark_config.value, "jar_file_uris", null)
      file_uris         = lookup(spark_config.value, "file_uris", null)
      archive_uris      = lookup(spark_config.value, "archive_uris", null)
      dynamic "logging_config" {
        for_each = lookup(spark_config.value, "logging_config", null) == null ? toset([]) : toset([lookup(spark_config.value, "logging_config")])
        content {
          driver_log_levels = logging_config.value.driver_log_levels
        }
      }
    }
  }
  dynamic "hadoop_config" {
    for_each = length(keys(var.hadoop_config)) == 0 ? toset([]) : toset([var.hadoop_config])
    content {
      main_class        = lookup(hadoop_config.value, "main_class", null)
      main_jar_file_uri = lookup(hadoop_config.value, "main_jar_file_uri", null)
      args              = lookup(hadoop_config.value, "args", null)
      properties        = lookup(hadoop_config.value, "properties", null)
      jar_file_uris     = lookup(hadoop_config.value, "jar_file_uris", null)
      file_uris         = lookup(hadoop_config.value, "file_uris", null)
      archive_uris      = lookup(hadoop_config.value, "archive_uris", null)
      dynamic "logging_config" {
        for_each = lookup(hadoop_config.value, "logging_config", null) == null ? toset([]) : toset([lookup(hadoop_config.value, "logging_config")])
        content {
          driver_log_levels = logging_config.value.driver_log_levels
        }
      }
    }
  }
  dynamic "hive_config" {
    for_each = length(keys(var.hive_config)) == 0 ? toset([]) : toset([var.hive_config])
    content {
      query_file_uri      = lookup(hive_config.value, "query_file_uri", null)
      query_list          = lookup(hive_config.value, "query_list", null)
      continue_on_failure = lookup(hive_config.value, "continue_on_failure", null)
      properties          = lookup(hive_config.value, "properties", null)
      jar_file_uris       = lookup(hive_config.value, "jar_file_uris", null)
      script_variables    = lookup(hive_config.value, "script_variables", null)
    }
  }
  dynamic "pig_config" {
    for_each = length(keys(var.pig_config)) == 0 ? toset([]) : toset([var.pig_config])
    content {
      query_file_uri      = lookup(pig_config.value, "query_file_uri", null)
      query_list          = lookup(pig_config.value, "query_list", null)
      continue_on_failure = lookup(pig_config.value, "continue_on_failure", null)
      properties          = lookup(pig_config.value, "properties", null)
      script_variables    = lookup(pig_config.value, "script_variables", null)
      jar_file_uris       = lookup(pig_config.value, "jar_file_uris", null)
      dynamic "logging_config" {
        for_each = lookup(pig_config.value, "logging_config", null) == null ? toset([]) : toset([lookup(pig_config.value, "logging_config")])
        content {
          driver_log_levels = logging_config.value.driver_log_levels
        }
      }
    }
  }
  dynamic "sparksql_config" {
    for_each = length(keys(var.sparksql_config)) == 0 ? toset([]) : toset([var.sparksql_config])
    content {
      query_file_uri   = lookup(sparksql_config.value, "query_file_uri", null)
      query_list       = lookup(sparksql_config.value, "query_list", null)
      properties       = lookup(sparksql_config.value, "properties", null)
      script_variables = lookup(sparksql_config.value, "script_variables", null)
      jar_file_uris    = lookup(sparksql_config.value, "jar_file_uris", null)
      dynamic "logging_config" {
        for_each = lookup(sparksql_config.value, "logging_config", null) == null ? toset([]) : toset([lookup(sparksql_config.value, "logging_config")])
        content {
          driver_log_levels = logging_config.value.driver_log_levels
        }
      }
    }
  }
  dynamic "presto_config" {
    for_each = length(keys(var.presto_config)) == 0 ? toset([]) : toset([var.presto_config])
    content {
      query_file_uri      = lookup(presto_config.value, "query_file_uri", null)
      query_list          = lookup(presto_config.value, "query_list", null)
      continue_on_failure = lookup(presto_config.value, "continue_on_failure", null)
      properties          = lookup(presto_config.value, "properties", null)
      client_tags         = lookup(presto_config.value, "client_tags", null)
      output_format       = lookup(presto_config.value, "output_format", null)
      dynamic "logging_config" {
        for_each = lookup(presto_config.value, "logging_config", null) == null ? toset([]) : toset([lookup(presto_config.value, "logging_config")])
        content {
          driver_log_levels = logging_config.value.driver_log_levels
        }
      }
    }
  }
}