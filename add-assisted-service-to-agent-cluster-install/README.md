### Boostrap assisted-service data transfer POC

From a git checkout of https://github.com/openshift/assisted-test-infra,

```shell
make create_full_environment
export PULL_SECRET_FILE=/home/rwsu/Downloads/pull-secret.txt
ENABLE_KUBE_API=true MINIKUBE_RAM_MB=4192 time make run
```
From this repository,

Apply the CRDs to install a compact cluster.

```shell
./apply-manifests.sh
```

Download the discovery ISO and boot the agents. The ISO's download URL can be found in:

```shell
kubectl get infraenv -A -o yaml
```

Example:
```shell
curl -o discovery.iso -k "http://10.9.95.158:6016/images/ff67a7ef-8949-4917-84e7-1bf46448baab?api_key=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJpbmZyYV9lbnZfaWQiOiJmZjY3YTdlZi04OTQ5LTQ5MTctODRlNy0xYmY0NjQ0OGJhYWIifQ.xmMxUYTmLuGhrX-GBw7P0sC94OpGTHme72G7_iveWnMo7DB-Qvw1Km2ynRFIyQS07m2tmj3JSvCLvVGdRA_Omg&arch=x86_64&type=full-iso&version=4.9"
```

Create 3 VMs for the compact cluster

```shell
virt-install --connect qemu:///system -n node1 -r 16000 --vcpus 6 --cdrom ./discovery.iso --disk pool=default,size=60 --boot hd,cdrom --os-variant=fedora-coreos-stable --wait=-1 &
virt-install --connect qemu:///system -n node2 -r 16000 --vcpus 6 --cdrom ./discovery.iso --disk pool=default,size=60 --boot hd,cdrom --os-variant=fedora-coreos-stable --wait=-1 &
virt-install --connect qemu:///system -n node3 -r 16000 --vcpus 6 --cdrom ./discovery.iso --disk pool=default,size=60 --boot hd,cdrom --os-variant=fedora-coreos-stable --wait=-1 &
```

Use this script to wait for agents to register with assisted-service and to approve them for install.

```shell
python3 update-agents.py
```

After a few minutes, the cluster install should start.

Monitor its progress:

```shell
watch kubectl get agents -A 
```

or

```shell
kubectl get agentclusterinstall -A -o yaml
```

The kubeconfig file for the cluster can be downloaded from the REST API:

Example:
```shell
curl "http://10.9.95.158:6000/api/assisted-install/v2/clusters/ea13fe7c-eeb8-479e-b9d8-f895685823b0/downloads/credentials?api_key=eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbHVzdGVyX2lkIjoiZWExM2ZlN2MtZWViOC00NzllLWI5ZDgtZjg5NTY4NTgyM2IwIn0.svtt92YRoMYtSMpEEbF818Ll14EglaJ5fBlrWXwMj0Vyii9gbVSSP7vi7bznWcK8_JUxDQdyp3mMcsWdFtZ7UA&file_name=kubeconfig" -o kubeconfig
export KUBECONFIG=./kubeconfig
```


