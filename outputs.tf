output "cluster_name" {
  description = "Dataproc Cluster Name"
  value       = google_dataproc_cluster.cluster[0].name
}