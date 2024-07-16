from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import subprocess
from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

display = Display()

class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        display.debug("GCP Secret lookup plugin called")
        if len(terms) != 2:
            raise AnsibleError("gcp_secret lookup expects 2 arguments: [project_id, secret_name]")

        project_id, secret_name = terms
        display.debug(f"Looking up secret {secret_name} in project {project_id}")

        try:
            cmd = [
                "gcloud", "secrets", "versions", "access", "latest",
                f"--secret={secret_name}",
                f"--project={project_id}",
                "--quiet"
            ]
            result = subprocess.run(cmd, capture_output=True, text=True, check=True)
            display.debug("Secret accessed successfully using gcloud")
        except subprocess.CalledProcessError as e:
            display.error(f"Error accessing secret: {e}")
            raise AnsibleError(f"Error accessing secret: {e.stderr}")

        secret_value = result.stdout.strip()
        display.v(f"Retrieved secret '{secret_name}' from project '{project_id}'")
        return [secret_value]
