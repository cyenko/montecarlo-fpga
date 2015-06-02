import sys
import math
from copy import deepcopy
import random
import matplotlib.pyplot as plt 
import csv

file = open('project_out.txt','r')
lines_array = []

for line in file:
	lines_array.append(line.strip())

#now convert to a histogram
number = []
for each in lines_array:
	integer_bin = each[:8]
	decimal_bin = each[8:]
	integer_decimal = int(integer_bin,2)
	decimal_decimal = 0.0
	i=1
	for bit in decimal_bin:
		decimal_decimal = decimal_decimal + float(int(bit)*2**(-1*i))
		i=i+1
	num = float(integer_decimal)+decimal_decimal
	number.append(num)

plt.hist(number,bins=30)
plt.show()

print "Average: ",sum(number)/len(number)