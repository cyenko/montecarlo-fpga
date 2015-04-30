from math import exp, sqrt
from random import gauss
optionType = 0  # 0 for put, 1 for call
S = 55  # Various Current stock prices
Strike = 50
u = .05  # Expected return, usually taken as the risk free interest rate
#This can also be approximated by the 10 year treasury bond
vol = .25  # Volatility
t = 3  # Number of time periods until expiry
n = 1000000  # Number of trials
output = []

for i in range(0, n):
    print (u-0.5*vol*vol)*t+(vol*sqrt(t)*gauss(0, 1))
    evolution = S*exp((u-0.5*vol*vol)*t+(vol*sqrt(t)*gauss(0, 1)))
    #print evolution
    # Calculate payoffs
    payoff = 0
    if optionType == 0:
        payoff = max(Strike-evolution, 0)
    else:
        payoff = max(evolution-Strike, 0)
    # Discount factor
    #-u*t is realistically between 0 and -1
    #output of exp(-u*t) is between 0 and 1 given above constraint
    payoff = exp(-u*t)*payoff
    # Append to trial result
    output.append(payoff)

output_price = sum(output)/len(output)
print "PRICE: " + str(output_price)
