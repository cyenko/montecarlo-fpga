
#LUT based on binary representation, with fixed-point representation
#Range of output 1 . 4 decimals
#Range of input is a decimal, could be negative
#For fixed point decimals, how does 2s complement work?

#bitVector(32 bits) - 1 for the sign, n bits for the integer part, 32-n-1 bits for the decimal

def exp_lut_binary(bitVector, n):
    sign = bitVector[0] #1 for negative, 0 for positive
    integer_part = bitVector[1:len(bitVector)-(n-1)]
    decimal_part = bitVector[len(bitVector)-(n-1):len(bitVector)]

    # DEBUG PARSING OF BIT VECTOR
    print "INITIAL NUMBER " + bitVector
    print "SIGN " + sign
    print "INTEGER(" + str(len(integer_part)) + ") " + integer_part
    print "DECIMAL(" + str(len(decimal_part)) + ") " + decimal_part
    total_part = sign+integer_part+decimal_part
    print total_part
    print "VALID" + bitVector == total_part
    

    #Define the positive lookup table
    #Defined as e^1,e^.1,e^.01,e^.001,e^.0001
    posExpTable = [2.718281828, 1.10517092, 1.0100502, 1.0010005, 1.000100005]

    #Define the negative lookup table
    #Defined as e^-1,e^-.1,e^-.01,e^-.001,e^-.0001
    negExpTable = [0.367879, 0.9048374, 0.99005, 0.99900, 0.99990]
    expTable = None

    #Check which table to use
    if(int(sign) == 0):
        expTable = posExpTable
    else:
        expTable = negExpTable

    #We call the to_signed method on each individual part
    #Use the python version of this, which is 'int'

    integer_conv = str(int(integer_part, 2))
    print integer_conv
    decimal_conv = str(int(decimal_part, 2))
    return -1
#LUT based on the math identity e^(a+b+c)=e^a *e^b * e^c
def exp_lut(inNum):
    #First we concatenate inNum to the length of our lookup table
    #I am expecting the input to be truncated by the time it is 
    #passed into this function
    inNum = round(inNum, 4)
    returnProduct = 1
    #Define the positive lookup table
    #Defined as e^1,e^.1,e^.01,e^.001,e^.0001
    posExpTable = [2.718281828, 1.10517092, 1.0100502, 1.0010005, 1.000100005]

    #Define the negative lookup table
    #Defined as e^-1,e^-.1,e^-.01,e^-.001,e^-.0001
    negExpTable = [0.367879, 0.9048374, 0.99005, 0.99900, 0.99990]

    #Use a MUX to determine the correct lookup table to use
    if inNum < 0:
        expTable = negExpTable
        inNum = inNum * -1
    else:
        expTable = posExpTable

    input_str = str(inNum)
    splitStr = input_str.split('.')
    #Parse and calculate the integer part
    returnProduct = returnProduct * expTable[0] ** int(splitStr[0])

    #Parse and calculate the decimal part
    pos = 1
    #expTable[1:len(expTable)]:
    for char in splitStr[1]:
        amt = (expTable[pos] ** int(char))
        returnProduct = returnProduct * amt
        pos = pos + 1
    return returnProduct

#Test cases
def assertEqual(x, y):
    if round(x, 3) == round(y, 3):
        return "TRUE"
    else:
        return str(round(x, 4)) + " != " + str(round(y, 4))

print assertEqual(exp_lut(2.123), 8.356)  # Expected 8.356
print assertEqual(exp_lut(4.9971), 147.983)  # Expected 147.983
print assertEqual(exp_lut(-2.123), 0.119672)  # Expected 0.119672
print assertEqual(exp_lut(-4.9971), .006758)  # Expected .006758
print exp_lut_binary("11110000111100001111000011110000", 16)
