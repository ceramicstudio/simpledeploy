from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import requests
from ansible.errors import AnsibleError
from ansible.plugins.lookup import LookupBase
from ansible.utils.display import Display

display = Display()


class LookupModule(LookupBase):

    def run(self, terms, variables=None, **kwargs):
        display.debug("GitHub Latest Release lookup plugin called")
        if len(terms) != 1:
            raise AnsibleError("github_latest_release lookup expects 1 argument: [repo_name]")

        repo_name = terms[0]
        display.debug(f"Looking up latest release for repository {repo_name}")

        try:
            url = f"https://api.github.com/repos/{repo_name}/releases/latest"
            response = requests.get(url)
            response.raise_for_status()
            data = response.json()
            latest_version = data['tag_name']
            display.debug(f"Latest release version retrieved: {latest_version}")
        except requests.RequestException as e:
            display.error(f"Error accessing GitHub API: {e}")
            raise AnsibleError(f"Error accessing GitHub API: {str(e)}")

        display.v(f"Retrieved latest release version '{latest_version}' for repository '{repo_name}'")
        return [latest_version]
