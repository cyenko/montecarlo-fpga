import binascii

def byte_to_binary(n):
    return ''.join(str((n & (1 << i)) and 1) for i in reversed(range(8)))

def hex_to_binary(h):
    return ''.join(byte_to_binary(ord(b)) for b in binascii.unhexlify(h))


number = raw_input('give me the number in hex (4 digits)!')

print hex_to_binary(number)
binary = hex_to_binary(number)


power = 7
result = float(0.0)
for b in binary:
	n  = int(b)
	result = result + float(n*float((2**power)))
	power = power - 1

#print number
#print binary
print result