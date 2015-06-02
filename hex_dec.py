import binascii
import matplotlib.pyplot as plt

def byte_to_binary(n):
    return ''.join(str((n & (1 << i)) and 1) for i in reversed(range(8)))

def hex_to_binary(h):
    return ''.join(byte_to_binary(ord(b)) for b in binascii.unhexlify(h))

def getNumber(number):
	#print number
	#print hex_to_binary(number)
	binary = hex_to_binary(number)

	num_10 = int(binary,2)
	#print num_10
	if num_10>(2**15):
		num_10 = -1*num_10

	#print num_10

	binary = bin(num_10)[2:]
	#print binary
	#print '-------------------------'
	length_missing = 16-len(binary)
	for i in range(length_missing):
		binary = '0'+binary
	#print binary


	power = 7
	result = float(0.0)
	for b in binary:
		n  = int(b)
		result = result + float(n*float((2**power)))
		power = power - 1

	#print number
	#print binary
	#print result
	return result


dictionary = {}
L = open('results_gauss.txt','r').read().splitlines()
results = []
for line in L:
	results.append(getNumber(line))

print sum(results)/len(results)
plt.hist(results,bins=20)
plt.show()
