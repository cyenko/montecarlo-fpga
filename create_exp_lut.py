#n - 16, length of input bitVector
#lengthOfInteger - How many bits to reserve for the integer part
#Length of decimal part is n - lengthOfInteger - 1
#Sign bit is the very first bit

#FORMAT
#0=>"0000000000000000", the first # is the conversion of the input bit vector
# to an unsigned integer
#The second number is the e^ result of converting that index into a bit vector,
# determining its fixed point 'true' value, and finally taking e^that

def createExpLUT(lengthOfInteger,n):