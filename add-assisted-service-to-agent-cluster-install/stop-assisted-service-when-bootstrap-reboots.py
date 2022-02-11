import os
import time

agent = ""
print("Waiting for bootstrap node to reach waiting for control plane")
while True:
    process = os.popen('kubectl get agents -n cluster0 | grep -v NAMESPACE | grep "Waiting for bootkube"')
    output = process.read()
    lines = output.count('\n')
    if lines == 1:
        agent = output.split()[0]
        print("bootstrap node is agent " + agent)
        break
    else:
        time.sleep(5)

print("Downloading kubeconfig")
process = os.popen('kubectl get agentclusterinstall -A -o yaml | grep logsURL')
logsURL = process.read()
logsURL = logsURL.split()[1]
kubeconfigURL = logsURL.replace("logs", "downloads/credentials")
kubeconfigURL = kubeconfigURL + "&file_name=kubeconfig"
print(logsURL)
process = os.popen('curl "' + kubeconfigURL + '&file_name=kubeconfig" -o kubeconfig')
print(process.read())

print("Waiting for bootstrap to reboot")
while True:
    process = os.popen('kubectl get agents -n cluster0 ' + agent + ' | grep -v NAMESPACE | grep "Rebooting"')
    output = process.read()
    lines = output.count('\n')
    if lines == 1:
        print("Stopping minikube")
        process = os.popen('minikube stop')
        output = process.read()
        print(output)
        break
    else:
        time.sleep(1)
