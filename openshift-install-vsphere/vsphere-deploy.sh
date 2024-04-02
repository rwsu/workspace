source env_vars.sh

set -eux

govc vm.create -c=8 -m=32000 -disk=100GB -g=rhel8_64Guest -iso=$ISO -net=$NET -on=false -net.address=00:50:56:bd:53:01 rwsu-vm1
govc vm.create -c=8 -m=32000 -disk=100GB -g=rhel8_64Guest -iso=$ISO -net=$NET -on=false -net.address=00:50:56:bd:53:02 rwsu-vm2
govc vm.create -c=8 -m=32000 -disk=100GB -g=rhel8_64Guest -iso=$ISO -net=$NET -on=false -net.address=00:50:56:bd:53:03 rwsu-vm3
govc vm.create -c=8 -m=32000 -disk=100GB -g=rhel8_64Guest -iso=$ISO -net=$NET -on=false -net.address=00:50:56:bd:53:04 rwsu-vm4
govc vm.create -c=8 -m=32000 -disk=100GB -g=rhel8_64Guest -iso=$ISO -net=$NET -on=false -net.address=00:50:56:bd:53:05 rwsu-vm5

govc vm.change -vm rwsu-vm1 -e disk.EnableUUID=TRUE
govc vm.change -vm rwsu-vm2 -e disk.EnableUUID=TRUE
govc vm.change -vm rwsu-vm3 -e disk.EnableUUID=TRUE
govc vm.change -vm rwsu-vm4 -e disk.EnableUUID=TRUE
govc vm.change -vm rwsu-vm5 -e disk.EnableUUID=TRUE

govc folder.create $FOLDER | true

govc vm.power -on rwsu-vm1
govc vm.power -on rwsu-vm2
govc vm.power -on rwsu-vm3
govc vm.power -on rwsu-vm4
govc vm.power -on rwsu-vm5