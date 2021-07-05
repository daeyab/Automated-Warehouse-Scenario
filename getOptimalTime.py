import os
import subprocess

time = 0
input_num = 0
 
while True:
	input_num = input("Enter test sample number (1~5) : ")
	if (input_num.isdigit()) and (int(input_num) in range(1,6)):
		break
	else:
		print("RETRY")

print("----------------RUNNING----------------")

while True:
	res = subprocess.Popen(['clingo', 'solution.lp', os.path.join('simpleInstances','inst'+str(input_num)+'.asp'), '-c', 't='+str(time)], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
	stdout,stderr = res.communicate()
	print('Testing for time %d' %time)
	if 'UNSATISFIABLE' in stdout.decode("utf-8").split():
		print('* Unsatisfiable at time %d' %time)
		time = time+1
	else:
		print(stdout.decode("utf-8"))
		print("*************************")
		print('MINIMUM TIME VALUE : %d ' %time)
		print("*************************")
		break