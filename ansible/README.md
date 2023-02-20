# Ansbile ceramic

The basic `ceramic` role deploys the Ceramic versioned daemon and node with as a`systemd` unit.
The node uses bundled IPFS and the provided indexing database.

Provide an [admin did](https://composedb.js.org/docs/0.3.x/configuration#admin-dids), an indexing database string, and a list of models to index to get started.

## Setup

Update the [inventory.yaml](inventory.yaml) file with the follwoing:
- `all.hosts` - the list of hosts to deploy to
- `all.vars.admin_dids` - the list of admin dids to use for the nodes
- `all.vars.ceramic_indexing_db` - the database string to use for the indexing database
- `all.vars.models_to_index` - the list of models to index

## Run

Setup a python environment and install the requirements:

```
python3 -m venv ./venv
source ./venv/bin/activate
python -m pip install -r ./pip.requirements.txt
```

Run the playbook:

```
ansible-playbook -i inventory.yaml playbook.yaml
```

