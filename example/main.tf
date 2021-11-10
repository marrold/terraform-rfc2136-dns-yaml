module "dns" {
  
  source = "github.com/marrold/terraform-rfc2136-dns-yaml?ref=v0.1"

  zone_yaml_dirs  = ["./zones1", "./zones2"]
  default_ttl = 600

}
