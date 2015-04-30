
#LUT based on binary representation, with fixed-point representation
#Range of output 1 . 4 decimals
#Range of input is a decimal, could be negative
#For fixed point decimals, how does 2s complement work?

#FORMAT OF INPUT: 1 for the sign, 1 bit for the 1/0 integer part, 30 bits for the decimal

def exp_lut_binary(bitVector):
    #Do to_singed VHDL method here in place of the below call

    return -1
#LUT based on the math identity e^(a+b+c)=e^a *e^b * e^c
def exp_lut(inNum):
    #First we concatenate inNum to the length of our lookup table
    #I am expecting the input to be truncated by the time it is 
    #passed into this function
    inNum = round(inNum, 4)
    returnProduct = 1
    #Define the basic lookup table
    #Defined as e^1,e^.1,e^.01,e^.001
    expTable = [2.71828, 1.10517, 1.01005, 1.00100, 1.00010]
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
print exp_lut(2.123)  # Expected 8.356
print exp_lut(4.9971)  # Expected 147.983
