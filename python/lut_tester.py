import create_exp_lut
from math import exp
print "1. Decimal to bit vector"
print " - Put this output into the bitVector_tb"
print "2. Bit vector to fixed"
print " - Check to see if tis output matches what comes out of the tb"
print "0. Exit"

userInput = -1
while(userInput !=0):
	userInput = input("\nChoice: ")
	if userInput == 1:
		input_fixed = input('Input decimal: ')
		correct_output = round(exp(float(input_fixed)),3)
		print "PUT INTO TB: " + create_exp_lut.fixedPointToBitVector(float(input_fixed),4)
		print "EXPECTED OUTPUT OF TB: " + str(correct_output)
		print "EXPECTED BITVECTOR OUTPUT: " + create_exp_lut.fixedPointToBitVector(correct_output,4)
	elif userInput == 2:
		input_bitVector = raw_input('Input bitVector: ')
		print create_exp_lut.bitVectorToFixedPoint(input_bitVector,4)