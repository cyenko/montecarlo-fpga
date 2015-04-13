# montecarlo-fpga
Black-Scholes style options pricing using Monte Carlo methods. Written in VHDL for the Cyclone IV FPGA board.

## Implementation

### bs-montecarlo-european.py

- Calculates the call option payoff using the equation 
### TODO

- Implement BS Monte Carlo for European Options in Python

## FAQ

### Why Monte Carlo and not standard Black-Scholes?

The standard Black-Scholes Partial Differential Equation would provide a closed form solution for the pricing of a 'plain vanilla' European style option; however, BS tends to perform poorly when valuing options with multiple and/or variable parameters (stochastic/varying interest rates, FX rates, etc.).

Options pricing via simulation would allow the creation of a multi-factor, rather than single-factor, model of the more exotic options available on the market today. We use the Monte Carlo method, which essentially takes the mean of a large number of repeated samples, as a proof-of-concept simulation method.

Traditionally, Monte-Carlo has been used as the benchmark valuation technique of European style exotic options given its general reliability as the number of random paths taken converges to infinity (https://people.maths.ox.ac.uk/richardsonm/OptionPricing.pdf). This reliability and benchmark status comes at a large computational and time cost, which leads us to...

### Why FPGA?

The nature of Monte Carlo sampling is such that a large number of simulations are run in order to obtain an accurate result. The more samples collected, the higher the accuracy of the end result. 

Given that each Black-Scholes random trial is independent of one another, we can implement the Monte Carlo method on FPGA boards to take advantage of the FPGA's superior parallel processing power to accomplish these simulations at a faster rate.