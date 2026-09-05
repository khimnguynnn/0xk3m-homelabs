output "tunnel_id" {
  description = "ID of the 0xk3m-homelabs tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
}

output "tunnel_cname" {
  description = "CNAME target to point DNS records at this tunnel"
  value       = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
}

output "tunnel_token" {
  description = "Token used to run cloudflared for this tunnel"
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.homelab.token
  sensitive   = true
}

output "tunnel_ingress_api_token" {
  description = "API token for the cloudflare-tunnel-ingress-controller"
  value       = cloudflare_account_token.tunnel_ingress.value
  sensitive   = true
}

# ---- mTLS ----
# Retrieve with: terraform output -raw mtls_ca_cert  (etc.)
# Install the client cert + key on the client (browser: bundle as PKCS#12).

output "mtls_ca_cert" {
  description = "Public CA certificate (PEM). Uploaded to Cloudflare; keep for reference."
  value       = tls_self_signed_cert.mtls_ca.cert_pem
}

output "mtls_client_cert" {
  description = "Client certificate (PEM) to present when connecting."
  value       = tls_locally_signed_cert.mtls_client.cert_pem
}

output "mtls_client_key" {
  description = "Client private key (PEM)."
  value       = tls_private_key.mtls_client.private_key_pem
  sensitive   = true
}
