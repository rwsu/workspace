source env_vars.sh

set -eux 

govc datastore.upload -ds $GOVC_DATASTORE ./agent.x86_64.iso iso/rwsu-isos/agent.x86_64.iso
