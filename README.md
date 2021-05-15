# Infoblox DNS CNAME update
This Ansible code snippet is used to import CNAMEs into Infoblox DNS via a CSV file.  The CSV file should conform to Infoblox format:  See [CSV File Format](https://docs.infoblox.com/display/nios86/CSV+File+Format) for more information.

The following json code is used to define variables 
# Variables:
- **base_url:** use this URL to point to the corret API in environment
- **maint_action:** use either "createMaintenanceWindow" or "deleteMaintenanceWindow"
- **filter:** Filter (SQL format) that determines what objects are put in Maintenance
- **username:** Username for Moogsoft API authentication. This can be encrypted on ansible and parametrized
- **password:** Password for Moogsoft API authentication. This can be encrypted on ansible and parametrized
- **csv_file:** Name of the CSV File containing CNAME Mapping (must follow Infoblox CSV Format)
- **action:** Use one of START or TEST
- **operation:** The operation to execute. INSERT, UPDATE, REPLACE, DELETE, CUSTOM
- **update_method:** Use one of  OVERRIDE, MERGE 
- **on_error:** Use one of CONTINUE or STOP
- **separator** Use one of COMMA, SEMICOLON, SPACE, TAB (default is COMMA)
- **tla:** TLA should be put here

```json
{
  {
    "nt_dr": {
      "foundational_area": {
        "operations": {
          "moogsoft": {
            "base_url": "https://xxx/" [xxx],
            "deleteID": "",
            "duration": "600",
            "filter": "source = \"server1\" and external_id in (\"value1\", \"value2\", \"value3\")",
            "forward": "false",
            "maint_action": "deleteMaintenanceWindow",
            "maint_descr": "Dell DR Test Maintenance Window",
            "maint_name": "dell_dr_maint",
            "password": "",
            "start_time": "1620936600",
            "username": ""
          }
        }
      },
      "progress": {
        "description": "something meaningful",
        "max": 5,
        "step": 0,
        "tla": [
          "DUMMY_TLA"
        ]
      }
    }
  }
}

```

The below yaml is the module to create/delete a Maintenance policy on Moogsoft
```yaml


NTAC:3NS-20
