# terraform-rfc2136-dns-yaml

terraform-rfc2136-dns-yaml is a terraform configuration for updating DNS records using RFC 2136. It uses the native [DNS Prvoider](https://registry.terraform.io/providers/hashicorp/dns/latest/docs) from Terraform.

## Caveats

- Due to the abstraction layer between Terraform and the yaml files, errors may be difficult to troubleshoot.
- The module assumes all zones share the same server and authentication keys. If you have multiple servers and/or keys you'll need to use the module multiple times with a different provider for each.
- I've only tested the module on Terraform version 0.15.5 and version 3.2.1 of the DNS Provider.
## Usage

## Importing the Module 

To use the module, add it as a resource and use the git repo as the source. Releases are tagged enabling you to pin a version.

### Module Options

-  **zone_yaml_dirs**:  A list of paths to directories containing YAML files ( [See Zone Directories](####-Zone-Directories) )  [Mandatory]

-  **default_ttl**: The default TTL to use if it's not supplied at the record level. If ommited from the module, it'll default to 3600 [Optional]


Your .tf file should look something like this:

    module "dns" {
      
      source = "github.com/marrold/terraform-rfc2136-dns-yaml?ref=v0.1"
    
      zone_yaml_dirs  = ["./zones"]
      default_ttl = 600
    
    }

## Configuring the provider

As well as importing the module you'll also need to configure the provider.
### Provider Options

-  **server**:  A list of paths to directories containing YAML files ( [See Zone Directories](####-Zone-Directories) )  [Mandatory]
-  **key_name**: The default TTL to use if it's not supplied at the record level. If ommited from the module, it'll default to 3600 [Optional]
-  **key_algorithm**: The default TTL to use if it's not supplied at the record level. If ommited from the module, it'll default to 3600 [Optional]
-  **key_secret**: The default TTL to use if it's not supplied at the record level. If ommited from the module, it'll default to 3600 [Optional]

Your .tf should look something like this:

    provider "dns" {
      update {
        server        = "10.0.144.4"
        key_name      = "update."
        key_algorithm = "hmac-sha256"
        key_secret    = "u/ULUGT0p7GPnpXYEVkWztv3fKi5hURD9PyJnvqMhZQ="
      }
    }
  

## Defining Zones and Records

### Zone Directories

Each directory passed to the module can contain multiple YAML files or nested directories. It's possible to define the zone in more than one YAML file - records will be merged before creation (Watch out for duplicates)

#### Example
```
.
├── zones1
│   ├── example.org
│   │   ├── example.org.yaml
│   │   └── subdomain.example.org
│   │       └── subdomain.example.org.yaml
│   └── lan.yaml
└── zones2
    ├── example.co.uk
    └── others
```

### Zone YAML Files
Each YAML file can contain one or more zones. The top level key for each object will be used as the zone name.

#### Example

```
--- 
github.com:
  - 
    name: a
    records: 
      - "10.0.130.1"
      - "192.168.1.1"
    type: a
    ttl: 50

terraform.io:
  - 
    name: a
    records: 
      - "10.0.130.1"
      - "192.168.1.1"
    type: a
    ttl: 50
```


### Records

#### A Records

##### Example

```
name: www
records:
- "10.0.130.1"
- "192.168.1.1"
type: a
ttl: 50
```

##### Options

-  **name**: The record name / domain. [Mandatory]
-  **records**: A list of entries to add for this record. [Mandatory]
-  **type**:  The type of this record. In this case its `a`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]


#### AAAA Records

##### Example

```
name: www
records:
  - "fdd5:e282:43b8:5303:dead:beef:cafe:babe"
  - "fdd5:e282:43b8:5303:cafe:babe:dead:beef"
type: aaaa
ttl: 300
```

##### Options

-  **name**: The record name / domain. [Mandatory]
-  **records**: A list of entries to add for this record. [Mandatory]
-  **type**:  The type of this record. In this case its `aaaa`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]


#### CNAME Records

##### Example

```
name: cname
cname: example.org
type: cname
ttl: 300
```

##### Options

-  **name**: The record name / domain. [Mandatory]
-  **cname**: The FQDN to return as the CNAME. [Mandatory]
-  **type**:  The type of this record. In this case its `cname`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]

#### MX Records

##### Example
```
name: mx
  records:
    smptp1.example.org:
      preference: 20
    smptp2.example.org:
      preference: 10
  type: mx
  ttl: 300
```
##### Options

-  **name**: The record name / domain. [Mandatory]
-  **records**: A dictionary of dictionaries, specifying the `exchange` and `preference`.  [Mandatory]
-  **type**:  The type of this record. In this case its `mx`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]

#### NS Records

##### Example
```
name: ns
records:
  - ns1.example.org
  - ns2.example.org
type: ns
ttl: 300
```
##### Options

-  **name**: The record name / domain. [Mandatory]
-  **records**: A list of entries to add for this record. [Mandatory]
-  **type**:  The type of this record. In this case its `ns`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]

#### PTR Records

##### Example
```
name: ptr
  ptr: example.org
  type: ptr
```
##### Options

-  **name**: The record name / domain. [Mandatory]
-  **ptr**: The pointer for this record [Mandatory]
-  **type**:  The type of this record. In this case its `ptr`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]

#### SRV Records

##### Example
```
name: _sip._tcp
records: 
  sip1.example.org.: 
    port: 5060
    priority: 10
    weight: 60
  sip2.example.org.: 
    port: 5061
    priority: 10
    weight: 60
type: srv
ttl: 300
```
##### Options

-  **name**: The record name / domain. [Mandatory]
-  **records**: A dictionary of dictionaries, specifying the service and it's `port`, `priority` and `weight`. [Mandatory]
-  **type**:  The type of this record. In this case its `srv`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]

#### TXT Records

##### Example
```
name: txt
records: 
  - "txt record"
  - "other txt record"
type: txt
ttl: 300
```
##### Options

-  **name**: The record name / domain. [Mandatory]
-  **records**: A list of strings to include in the txt record. [Mandatory]
-  **type**:  The type of this record. In this case its `txt`. [Mandatory]
-  **ttl**: The TTL for this record. [Optional, see Module usage for defaults]

### Outputs

Outputs for *compiled* records are those that have been extracted from the YAML files. It doesn't guarantee they've been created. Useful for troubleshooting the YAML parsing.

-  **compiled_records**:  All the records extracted from the YAML files
-  **compiled_a_records**: The A records extracted from the YAML files
-  **compiled_aaaa_records**: The AAAA records extracted from the YAML files
-  **compiled_cname_records**: The CNAME records extracted from the YAML files
-  **compiled_mx_records**: The MX records extracted from the YAML files
-  **compiled_ns_records**: The NS records extracted from the YAML files
-  **compiled_ptr_records**: The PTR records extracted from the YAML files
-  **compiled_srv_records**: The SRV records extracted from the YAML files
-  **compiled_txt_records**: The TXT records extracted from the YAML files

Outputs for *created* records are those that have been crearted by the DNS Provider

-  **created_a_records**: The A records created by the DNS provider
-  **created_aaaa_records**: The AAAA records created by the DNS provider
-  **created_cname_records**: The CNAME records created by the DNS provider
-  **created_mx_records**: The MX records created by the DNS provider
-  **created_ns_records**: The NS records created by the DNS provider
-  **created_ptr_records**: The PTR records created by the DNS provider
-  **created_srv_records**: The SRV records created by the DNS provider
-  **created_txt_records**: The TXT records created by the DNS provider

## Example

An Example is included in the `examples` directory in this repository. It's assumed that you already have Terraform installed and configured.

### Configuration

- Copy `provider.tf_EXAMPLE` to `provider.tf`
- Edit the `server`, `key_name`, `key_algorithm` and `key_secret` to match your DNS server config.
- Edit the zone YAML files and include your own zones / records.
- Run `terraform init` 
- Run `terraform plan` or `terraform apply`

## License

This project is licensed is licensed under the terms of the _MIT license_. For other dependencies such as Terraform, please see their relevant licenses.
