import create_exp_lut
from math import exp
from decimal import Decimal
print "1. Decimal to bit vector"
print " - Put this output into the bitVector_tb"
print "2. Bit vector to fixed"
print " - Check to see if tis output matches what comes out of the tb"
print "0. Exit"

userInput = -1
granularity = create_exp_lut.getGranularity(7)
while(userInput !=0):
    userInput = input("\nChoice: ")
    if userInput == 1:
        input_fixed = input('Input decimal: ')
        expVal = exp(float(input_fixed))
        print "TRUE VAL: " + str(expVal)
        subtractVal = float(Decimal(expVal) % Decimal(granularity))
        expVal = expVal - subtractVal
        print "PUT INTO TB: " + create_exp_lut.fixedPointToBitVector(float(input_fixed),7)
        print "EXPECTED OUTPUT OF TB: " + str(expVal)
        print "EXPECTED BITVECTOR OUTPUT: " + create_exp_lut.fixedPointToBitVector(expVal,7)
    elif userInput == 2:
        input_bitVector = raw_input('Input bitVector: ')
        print create_exp_lut.bitVectorToFixedPoint(input_bitVector,7)
