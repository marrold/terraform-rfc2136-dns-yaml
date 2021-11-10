variable "zone_yaml_dirs" {
  description = "List of paths to directories containing zone yaml files"
  type = list
}

variable "default_ttl" {
  description = "The default TTL to use if it's not defined"
  default = 3600
}

locals {
  zone_file_full_paths = flatten([

    for path in var.zone_yaml_dirs : [
      for file in fileset(path, "**") :
        format("%s/%s", path, file)
    ]
  ])

  decoded_zone_yaml_files = flatten([
    for full_path in local.zone_file_full_paths :
      try(yamldecode(file(full_path)), {})
  ])

  merged_zones = [
    
    for index, rule in flatten([
      for file in local.decoded_zone_yaml_files : [
        for zone in try(keys(file), []) : [
          for rules_list in file[zone] : [
            merge(rules_list, {"zone" = zone})
          ]
        ]
      ]
    ]) : rule
  ]

  a_records = [
    for k, v in local.merged_zones :  v if v.type == "a"
  ]

  aaaa_records = [
    for k, v in local.merged_zones :  v if v.type == "aaaa"
  ]

  cname_records = [
    for k, v in local.merged_zones :  v if v.type == "cname"
  ]

  mx_records = [
    for k, v in local.merged_zones :  v if v.type == "mx"
  ]

  ns_records = [
    for k, v in local.merged_zones :  v if v.type == "ns"
  ]

  ptr_records = [
    for k, v in local.merged_zones :  v if v.type == "ptr"
  ]

  srv_records = [
    for k, v in local.merged_zones :  v if v.type == "srv"
  ]

  txt_records = [
    for k, v in local.merged_zones :  v if v.type == "txt"
  ]

}