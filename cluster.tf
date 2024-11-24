resource "google_dataproc_cluster" "cluster" {
  count                         = var.create_cluster ? 1 : 0
  name                          = var.cluster_name
  region                        = var.region
  project                       = var.project_id
  graceful_decommission_timeout = var.graceful_decommission_timeout
  labels                        = var.cluster_labels

  cluster_config {
    staging_bucket = var.cluster_staging_bucket

    software_config {
      image_version       = var.cluster_version
      override_properties = var.cluster_override_properties
      optional_components = var.cluster_optional_components
    }

    encryption_config {
      kms_key_name = var.kms_key_name
    }

    temp_bucket = var.cluster_temp_bucket

    master_config {
      num_instances    = var.master_ha ? 3 : 1
      machine_type     = var.master_instance_type
      min_cpu_platform = var.master_min_cpu_platform
      image_uri        = var.image_uri

      disk_config {
        boot_disk_type    = var.master_disk_type
        boot_disk_size_gb = var.master_disk_size
        num_local_ssds    = var.master_local_ssd
      }

      dynamic "accelerators" {
        for_each = var.master_accelerator
        content {
          accelerator_count = accelerators.value.count
          accelerator_type  = accelerators.value.type
        }
      }
    }

    worker_config {
      num_instances    = var.worker_nodes
      machine_type     = var.worker_instance_type
      min_cpu_platform = var.worker_min_cpu_platform
      image_uri        = var.image_uri

      disk_config {
        boot_disk_type    = var.worker_disk_type
        boot_disk_size_gb = var.worker_disk_size
        num_local_ssds    = var.worker_local_ssd
      }

      dynamic "accelerators" {
        for_each = var.worker_accelerator
        content {
          accelerator_count = accelerators.value.count
          accelerator_type  = accelerators.value.type
        }
      }
    }

    preemptible_worker_config {
      num_instances = var.secondary_worker_min_instances
      disk_config {
        boot_disk_type    = var.secondary_worker_disk_type
        boot_disk_size_gb = var.secondary_worker_disk_size
        num_local_ssds    = var.secondary_worker_local_ssd
      }
      preemptibility = var.preemptibility
    }

    gce_cluster_config {
      network          = var.network
      subnetwork       = var.subnetwork
      zone             = var.gce_zone
      tags             = var.gce_cluster_tags
      service_account  = var.service_account
      internal_ip_only = var.internal_ip_only
      metadata         = var.cluster_metadata

      dynamic "shielded_instance_config" {
        for_each = var.shield_enable_secure_boot == null && var.shield_enable_vtpm == null && var.shield_enable_integrity_monitoring == null ? [] : [1]
        content {
          enable_secure_boot          = var.shield_enable_secure_boot
          enable_vtpm                 = var.shield_enable_vtpm
          enable_integrity_monitoring = var.shield_enable_integrity_monitoring
        }
      }

      dynamic "node_group_affinity" {
        for_each = var.node_group_uri == null ? [] : [1]
        content {
          node_group_uri = var.node_group_uri
        }
      }
    }

    dynamic "autoscaling_config" {
      for_each = var.autoscaling_policy_uri == null ? [] : [1]
      content {
        policy_uri = var.autoscaling_policy_uri
      }
    }

    dynamic "initialization_action" {
      for_each = var.initialization_action
      content {
        script      = initialization_action.value["script"]
        timeout_sec = initialization_action.value["timeout_sec"]
      }
    }

    dynamic "lifecycle_config" {
      for_each = var.idle_delete_ttl == null && var.auto_delete_time == null ? [] : [1]
      content {
        idle_delete_ttl  = var.idle_delete_ttl
        auto_delete_time = var.auto_delete_time
      }
    }

    endpoint_config {
      enable_http_port_access = var.enable_http_port_access
    }

    dynamic "metastore_config" {
      for_each = var.dataproc_metastore_service == null ? [] : [1]
      content {
        dataproc_metastore_service = var.dataproc_metastore_service
      }
    }

    dynamic "dataproc_metric_config" {
      for_each = var.metric_source == null ? [] : [1]
      content {
        dynamic "metrics" {
          for_each = var.metric_source == null ? [] : [1]
          content {
            metric_source    = var.metric_source
            metric_overrides = var.metric_overrides
          }
        }
      }
    }
  }
}
