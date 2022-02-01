import os
import time

while True:
    process = os.popen('kubectl get agents -A | grep -v NAMESPACE')
    output = process.read()
    lines = output.count('\n')
    if lines == 3:
        print("3 agents now available")
        print(output.strip())
        break
    else:
        print ("Only " + str(lines) + " agents available, waiting for 3")
        time.sleep(5)

print("\nFix hostname and approval")

agents = output.split('\n')
# len(agents) - 1 to take care of the empty fourth line
i = 1
for agent in agents[0:len(agents) - 1]:
    agentID = agent.split()[1]
    command = 'kubectl patch agent -n cluster0 ' + agentID + ' --type=\'json\' --patch \'[{"op": "add", "path": "/spec/hostname", "value": "master-' + str(i) + '"}]\''
    print(command)
    p = os.popen(command)
    print(p.read())

    command = 'kubectl patch agent -n cluster0 ' + agentID + ' --type=\'json\' --patch \'[{"op": "add", "path": "/spec/approved", "value": true}]\''
    print(command)
    p = os.popen(command)
    print(p.read())
    i += 1

    