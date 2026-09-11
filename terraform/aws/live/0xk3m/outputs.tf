output "loki_s3_access_key_id" {
  description = "Access key ID for the Loki S3 user"
  value       = module.iam_user.access_key_id
}

output "loki_s3_secret_access_key" {
  description = "Secret access key for the Loki S3 user"
  value       = module.iam_user.access_key_secret
  sensitive   = true
}

# Open WebUI
output "open_webui_s3_bucket_name" {
  description = "S3 bucket name for Open WebUI"
  value       = module.open_webui_s3_bucket.s3_bucket_id
}

output "open_webui_s3_region" {
  description = "S3 bucket region for Open WebUI"
  value       = module.open_webui_s3_bucket.s3_bucket_region
}

output "open_webui_s3_access_key_id" {
  description = "Access key ID for the Open WebUI S3 user"
  value       = module.open_webui_iam_user.access_key_id
}

output "open_webui_s3_secret_access_key" {
  description = "Secret access key for the Open WebUI S3 user"
  value       = module.open_webui_iam_user.access_key_secret
  sensitive   = true
}
