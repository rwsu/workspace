source env_vars.sh

set -eux

govc vm.destroy rwsu-vm1 | true
govc vm.destroy rwsu-vm2 | true
govc vm.destroy rwsu-vm3 | true
govc vm.destroy rwsu-vm4 | true
govc vm.destroy rwsu-vm5 | true
