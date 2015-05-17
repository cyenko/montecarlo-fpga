import matplotlib.pyplot as plt

#converts integer string into 12-bit bit-string
tobin = lambda x, count=8: "".join(map(lambda y:str((x>>y)&1), range(count-1, -1, -1)))

myFile = open('gaussian.txt')

arr = []

for line in myFile:
	# arr.append(int(line)) #decimals
	arr.append(tobin(int(line),12)) #12 bit bit vector that was generated

#table for values
table = [2, 1, 0.5,0.25,0.125,0.0625,0.03125,0.015625,0.0078125,0.00390625,0.001953125,0.0009765625,0.00048828125,0.000244140625]


decimals = []

for item in arr:
	val = 0
	if item[0] == '0': #toggle the reverse of the first bit
		val += table[0]
	for i in range(1, len(item)):
		if item[i] == '1':
			val += table[i]
	decimals.append(val-2) #convert range from (0,4) to (-2,2)

plt.hist(decimals, bins=500)
plt.show()


#f = open('decimalsv2.txt','w')
#for item in decimals:
#	f.write('%f\n'%item)

#f.close()
myFile.close()
# print arr
