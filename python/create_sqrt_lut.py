from math import exp
import os
from decimal import Decimal
#n is length of integer part
#1.5, 0 000 0001 1000 0000 , 0000000110000000
#1.75, , 0 000 0001 1100 0000, 0000000111000000
#2.78125, 0 000 0010 1100 1000, 0000001011001000
#0 000 0001 1100 1000
def bitVectorToFixedPoint(bitVector, n):
    if len(bitVector) != 16:
        return "ERROR: LENGTH OF " + bitVector + " IS " + str(len(bitVector))
    sign = bitVector[0]  # 1 for negative, 0 for positive
    integer_part = bitVector[1:n+1]
    decimal_part_binary = bitVector[n+1:len(bitVector)]
    integer_conv = int(integer_part, 2)
    #Calculate the decimal part of the number
    decimal_part = 0.0
    exponent = -1
    for digit in decimal_part_binary:
        if digit == '1':
            #print "exponent" + str(exponent)
            decimal_part = decimal_part + (2**exponent)
        exponent = exponent - 1
    #print "Decimal part is " + str(decimal_part)
    total_conv = float(integer_conv)+decimal_part
    if float(sign) == 1:
        total_conv = total_conv * -1
    return total_conv

#n is the length of the integer part
#print fixedPointToBitVector(1.5,7)
#print fixedPointToBitVector(1.75,7)
#print fixedPointToBitVector(2.78125,7)
def fixedPointToBitVector(fixedPoint, n):
    sign = str(0)
    #conversion of the sign
    if fixedPoint < 0:
        sign = str(1)
        fixedPoint = fixedPoint * -1
    integer_part = str(fixedPoint).split('.')[0]
    decimal_part = str(fixedPoint).split('.')[1]
    #Convert back to float
    decimal_part = float("." + str(decimal_part))
    integer_binary = ("{0:0"+str(n)+"b}").format(int(integer_part))
    #Conversion of the decimal part
    decimal_binary = ""
    while decimal_part != 0.0:
        temp = decimal_part * 2
        #print temp
        if temp >= 1:
            decimal_binary = decimal_binary + "1"
        else:
            decimal_binary = decimal_binary + "0"
        #print decimal_binary
        #Disregard the integer part, and go again
        decimal_part = float("." + str(temp).split('.')[1])
    #Pad the decimal part if necessary
    amtZeros = 16-len(integer_binary)-len(decimal_binary)-1
    if amtZeros < 0:
        raise ValueError("Cannot represent that number," + str(fixedPoint) + " in our notation")
    return sign+integer_binary+decimal_binary+"".join(str(x) for x in [0]*amtZeros)

def formatLine(firstVal, secondVal):
    hasComma = ","
    if firstVal == 65535:
        hasComma = ""
    return str(firstVal) + " => \"" + str(secondVal) + "\"" + hasComma

#Given the length of the integer part, what is the smallest number we can represent?
#Return the number of decimal points we shoudl round to in order to make sure
#We do not overflow the final return bitVector
def getGranularity(n):
    #For now, we are satisfied with a granularity of 5 decimal points
    return 2**(-1*(16-n-1))

#n - 16, length of input bitVector
#lengthOfInteger - How many bits to reserve for the integer part
#Length of decimal part is n - lengthOfInteger - 1
#Sign bit is the very first bit

#FORMAT
#0=>"0000000000000000", the first # is the conversion of the input bit vector
# to an unsigned integer
#The second number is the e^ result of converting that index into a bit vector,
# determining its fixed point 'true' value, and finally taking e^that


def createSqrtLUT(lengthOfInteger, n, outputFileName=None):
    writer = None
    numberNotWritten = 0
    if outputFileName is None:
        print "WARNING: No file name specified, not writing to file"
    else:
        if os.path.exists(outputFileName):
            os.remove(outputFileName)
        print "Writing to file " + outputFileName
        writer = open(outputFileName, 'w')
        writer.write('constant sqrt_lut : rom := (')
    #Determine granularity
    granularity = getGranularity(7)
    for i in range(0, 2**7):
        #print "ON INT " +str(i)
        binaryString = "{0:016b}".format(i)

        sqrtValue = i**.5
        print str(i) + ":" + str(sqrtValue)
        #Round expValue to the nearest granularity point
        subtractVal = float(Decimal(sqrtValue) % Decimal(granularity))
        sqrtValue = sqrtValue - subtractVal
        return_bitvector = fixedPointToBitVector(sqrtValue, lengthOfInteger)
        print return_bitvector


        if writer is not None:
            #Check to see if return bit vector is proper size
            if len(return_bitvector) == 16:
                writer.write(formatLine(i, return_bitvector))
                if i % 3 == 0:  #even
                    writer.write("\n")
            else:
                print "ERROR: "
                print i
                print binaryString
                print fixedPoint
                print expValue
                raise ValueError("Bit vector corrupted, " + return_bitvector)

    print "Number of lines not written : " + str(numberNotWritten)
    if writer is not None:
        writer.write(');')
        writer.close()
        print "Done writing file"

if __name__ == "__main__":
    print "CREATING TABLE"
    createSqrtLUT(7, 16, "sqrt_lut_table")
    print "DONE"
    #1 00000010 0000001
    #Integer of 33025, fixed point value of -2.1