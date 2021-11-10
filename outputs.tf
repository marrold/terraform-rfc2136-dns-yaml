output "compiled_records" {
  value = local.merged_zones
}

output "compiled_a_records" {
  value = local.a_records
}

output "compiled_aaaa_records" {
  value = local.aaaa_records
}

output "compiled_cname_records" {
  value = local.cname_records
}

output "compiled_mx_records" {
  value = local.mx_records
}

output "compiled_ns_records" {
  value = local.ns_records
}

output "compiled_ptr_records" {
  value = local.ptr_records
}

output "compiled_srv_records" {
  value = local.srv_records
}

output "compiled_txt_records" {
  value = local.txt_records
}

output "created_a_records" {
  value = dns_a_record_set.a_record
}

output "created_aaaa_records" {
  value = dns_aaaa_record_set.aaaa_record
}

output "created_cname_records" {
  value = dns_cname_record.cname_record
}

output "created_mx_records" {
  value = dns_mx_record_set.mx_record
}

output "created_ns_records" {
  value = dns_ns_record_set.ns_record
}

output "created_ptr_records" {
  value = dns_ptr_record.ptr_record
}

output "created_srv_records" {
  value = dns_srv_record_set.srv_record
}

output "created_txt_records" {
  value = dns_txt_record_set.txt_record
}