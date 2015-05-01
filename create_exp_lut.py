from math import exp

#n is length of integer part
def bitVectorToFixedPoint(bitVector, n):
    sign = bitVector[0]  # 1 for negative, 0 for positive
    integer_part = bitVector[1:n+1]
    decimal_part = bitVector[n+1:len(bitVector)]
    integer_conv = str(int(integer_part, 2))
    decimal_conv = str(int(decimal_part, 2))
    total_conv = float(integer_conv + "." + decimal_conv)
    if float(sign) == 1:
    	total_conv = total_conv * -1
    return total_conv

#n is the length of the integer part
def fixedPointToBitVector(fixedPoint,n):
	sign = str(0)
	if fixedPoint < 0:
		sign = str(1)
		fixedPoint = fixedPoint * -1

	integer_part = str(fixedPoint).split('.')[0]
	decimal_part = str(fixedPoint).split('.')[1]
	integer_binary = ("{0:0"+str(n)+"b}").format(int(integer_part))
	decimal_binary = ("{0:0"+str(16-1-n)+"b}").format(int(decimal_part))
	print decimal_binary
	return sign+integer_binary+decimal_binary

def formatLine(firstVal,secondVal):
	return str(firstVal) + " => \"" + str(secondVal) + "\","

#n - 16, length of input bitVector
#lengthOfInteger - How many bits to reserve for the integer part
#Length of decimal part is n - lengthOfInteger - 1
#Sign bit is the very first bit

#FORMAT
#0=>"0000000000000000", the first # is the conversion of the input bit vector
# to an unsigned integer
#The second number is the e^ result of converting that index into a bit vector,
# determining its fixed point 'true' value, and finally taking e^that


def createExpLUT(lengthOfInteger, n):
	print "FUNC CALLED"
	for i in range(0,(2**n)):
		binaryString = "{0:016b}".format(i)
		fixedPoint = bitVectorToFixedPoint(binaryString, lengthOfInteger)
		expValue = round(exp(fixedPoint),3)

		if i==4:
			print "BINARY STRING : " + binaryString
			print "DECIMAL REPRESENTATION: " + str(fixedPoint)
			print "EXP VALUE: " + str(expValue)
			return_bitvector = fixedPointToBitVector(expValue,lengthOfInteger)

			print "FIXED POINT REPRESENTATION: " + return_bitvector


createExpLUT(5,16)
#1 00000010 0000001
print bitVectorToFixedPoint("1000000100000001",8)