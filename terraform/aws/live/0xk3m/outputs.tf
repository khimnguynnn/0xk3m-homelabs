output "loki_s3_access_key_id" {
  description = "Access key ID for the Loki S3 user"
  value       = module.iam_user.iam_access_key_id
}

output "loki_s3_secret_access_key" {
  description = "Secret access key for the Loki S3 user"
  value       = module.iam_user.iam_access_key_secret
  sensitive   = true
}
