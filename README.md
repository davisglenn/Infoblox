# Infoblox DNS CNAME update
This Ansible code snippet is used to import CNAMEs into Infoblox DNS via a CSV file.  The CSV file should conform to Infoblox format:  See [CSV File Format](https://docs.infoblox.com/display/nios86/CSV+File+Format) for more information.

The following json code is used to define variables 
# Variables:
- **base_url:** use this URL to point to the corret API in environment
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
        "network": {
          "dns": {
            "base_url:" "https://<<hostname>>/wapi/v2.11",
            "username:" "admin",
            "password:" "infoblox",
            "csv_file:" "import.csv",
            "action:" "START",
            "on_error:" "CONTINUE",
            "operation:" "UPDATE",
            "update_method:" "OVERRIDE",
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

The below yaml is the module to import a CSV into Infoblox in order to update multiple CNAMEs as a batch process
```yaml
# curl -k -u admin:infoblox -H 'content-type:application/json' -X POST "https://gridmaster/wapi/v2.11/fileop?_function=uploadinit"
  - name: run uploadinit to retrieve token and URL
    uri:
      url: "{{ base_url }}/fileop?_function=uploadinit"
      user: "{{ username }}"
      password: "{{ password }}"
      method: POST
      headers:
        Content-Type: application/json
      body_format: json
      force_basic_auth: yes
      validate_certs: no
    register: init_response

  - name: set token and URL
    set_fact:
      token: "{{ init_response.json.token }}"
      csvURL: "{{ init_response.json.url }}"

  - name: print new CSV variables
    debug:
      msg: 
        - "token: {{ token }}"
        - "  url: {{ csvURL }}"

  # curl -k -u admin:infoblox -H 'content-type:multipart/form-data' \
  #       https://192.168.60.25/http_direct_file_io/req_id-UPLOAD-0514212257905636/import_file \
  #       -F file=@HostRecords.csv
  - name: Upload the contents of CSV file
    uri:
      url: "{{ csvURL }}"
      user: "{{ username }}"
      password: "{{ password }}"
      method: POST
      headers:
        Content-Type: multipart/form-data
      body_format: form-multipart
      body:
        file:
          filename: "{{ csv_file }}"
          mime_type: text/plain
      force_basic_auth: yes
      validate_certs: no
    register: upload_response

  - name: print upload
    debug:
      var: upload_response

  # curl -k -u admin:infoblox -H 'content-type:application/json' -X POST \
  #       "https://gridmaster/wapi/v2.11/fileop?_function=csv_import" \
  #      -d '{"action":"START","on_error":"CONTINUE","update_method":"MERGE", \
  #           "token":"eJydUE1PwzAMvfuPbJe1Tbe2G7ehMQkJDbTB2WqTdFhqk5CkaPv3OENw4cYhkeP34TxLad0VvT4D\nX9KaEP0ko/XgBMwlmd52g71k1uh04tXpALs2tnjUPbgSJGI30RDJIIIiGcEtYa7cCk4zfXHkrxhp\n1DNwFexFVVRNVddVk4l6tdyUGwin2eQHhmsWvMfowl2ei6bMyjoTWZmnFiriv0XsadBINvf6A0kt\n3l6enre7hSiKMqfRWf/NYK8m2ZLias2uf+kM3CYrDsK1KJiVB07dnnUeR/e/qUL8eKI20ioy59Qt\n2fz+8ZDK5S9htOomSWvabV+3eHzYp3cFIR6dqNMKRcNgT3pQAaNFaUfX+ptqDYcUsGsdknFTxE/t\nA1mTsA1jXfYFNGOU6g==\n"}'
  - name: import the CSV using the retrieved token
    uri:
      url: "{{ base_url }}/fileop?_function=csv_import"
      user: "{{ username }}"
      password: "{{ password }}"
      method: POST
      headers:
        Content-Type: application/json
      body_format: json
      body:
        action: "{{ action }}"
        on_error: "{{ on_error }}"
        operation: "{{ operation }}"
        update_method: "{{ update_method }}"
        token: "{{ token }}"
      force_basic_auth: yes
      validate_certs: no
    register: import_response

  - name: print import
    debug:
      var: import_response
```