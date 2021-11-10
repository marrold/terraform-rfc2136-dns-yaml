resource "dns_a_record_set" "a_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.a_records != null ? { for record in local.a_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  name = each.value.name
  addresses = each.value.records
  ttl = lookup(each.value, "ttl", var.default_ttl)
}

resource "dns_aaaa_record_set" "aaaa_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.aaaa_records != null ? { for record in local.aaaa_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  name = each.value.name
  addresses = each.value.records
  ttl = lookup(each.value, "ttl", var.default_ttl)
}

resource "dns_cname_record" "cname_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.cname_records != null ? { for record in local.cname_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  name = each.value.name
  cname = try(length(regexall("\\.$", each.value.cname)) > 0 ?  each.value.cname : "${each.value.cname}.")
  ttl = lookup(each.value, "ttl", var.default_ttl)
}

# Note: If an MX record references another record inside the same zone, Bind9 will check if it exists first and fail if it doesn't.
resource "dns_mx_record_set" "mx_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.mx_records != null ? { for record in local.mx_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  ttl = lookup(each.value, "ttl", var.default_ttl)

  dynamic "mx" {
    for_each = each.value.records
      content {
        exchange = try(length(regexall("\\.$", mx.key)) > 0 ?  mx.key : "${mx.key}.")
        preference = mx.value.preference
      }
    }

  # We force dependency on A and AAAA records to ensure they already exist before we create the MX records, due to the afore mentioned validation.
  depends_on = [
    dns_a_record_set.a_record,
    dns_aaaa_record_set.aaaa_record,
  ]

}

resource "dns_ns_record_set" "ns_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.ns_records != null ? { for record in local.ns_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  name = each.value.name
  nameservers =  [ for nameserver in each.value.records: try(length(regexall("\\.$", nameserver)) > 0 ?  nameserver : "${nameserver}.") ]
  ttl = lookup(each.value, "ttl", var.default_ttl)
}

resource "dns_ptr_record" "ptr_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.ptr_records != null ? { for record in local.ptr_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  name = each.value.name
  ptr = try(length(regexall("\\.$", each.value.ptr)) > 0 ?  each.value.ptr : "${each.value.ptr}.")
  ttl = lookup(each.value, "ttl", var.default_ttl)
}

resource "dns_srv_record_set" "srv_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.srv_records != null ? { for record in local.srv_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  name = each.value.name
  ttl = lookup(each.value, "ttl", var.default_ttl)

  dynamic "srv" {
    for_each = each.value.records
      content {
        priority = srv.value.priority
        weight = srv.value.weight
        target = srv.key
        port = srv.value.port
      }
    }
}

resource "dns_txt_record_set" "txt_record" {

  #for_each insists on a map, so we convert the list of maps into a map, using the zone, name, and type (concatenated) as the key.
  for_each = try(local.txt_records != null ? { for record in local.txt_records: "${record.zone}.${record.name}.${record.type}" => record } : tomap(false), {} )

  zone = try(length(regexall("\\.$", each.value.zone)) > 0 ?  each.value.zone : "${each.value.zone}.")
  txt = each.value.records
  ttl = lookup(each.value, "ttl", var.default_ttl)
}

