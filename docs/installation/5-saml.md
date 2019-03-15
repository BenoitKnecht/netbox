This guide explains how to implement SAML authentication using an external SAML2 SSO provider. Local user authentication is still available.

# Requirements

## Install xmlsec1

On Ubuntu:

```no-highlight
sudo apt-get install -y xmlsec1
```

On CentOS:

```no-highlight
sudo yum install -y xmlsec1
```

## Install django-saml2-auth

```no-highlight
pip3 install django-saml2-auth
```

# Configuration

Create a file in the same directory as `configuration.py` (typically `netbox/netbox/`) named `saml_config.py`. Define all of the parameters required below in `saml_config.py`. Complete documentation of all `django-saml2-auth` configuration options is included in the project's [official documentation](https://github.com/fangli/django-saml2-auth).

## General Server Configuration

```python

SAML2_AUTH = {
    # Metadata is required. Specify either a remote url or local file path
    'METADATA_AUTO_CONF_URL': '[The auto(dynamic) metadata configuration URL of SAML2]',
    'METADATA_LOCAL_FILE_PATH': '[The metadata configuration local file path]',

    # Optional settings below
    'CREATE_USER': 'TRUE', # Create a new Django/NetBox user when a new user logs in. Defaults to True.
    'NEW_USER_PROFILE': {
        'USER_GROUPS': [],  # The default group name when a new user logs in
        'ACTIVE_STATUS': True,  # The default active status for new users
        'STAFF_STATUS': True,  # The staff status for new users
        'SUPERUSER_STATUS': False,  # The superuser status for new users
    },
    'ATTRIBUTES_MAP': {  # Change Email/UserName/FirstName/LastName to corresponding SAML2 userprofile attributes.
        'email': 'Email',
        'username': 'UserName',
        'first_name': 'FirstName',
        'last_name': 'LastName',
    },
    'ENTITY_ID': 'https://mysite.com/saml2_auth/acs/', # Populates the Issuer element in authn request
}
```

# Troubleshooting SAML

`supervisorctl restart netbox` restarts the Netbox service, and initiates any changes made to `saml_config.py`. If there are syntax errors present, the NetBox process will not spawn an instance, and errors should be logged to `/var/log/supervisor/`.
