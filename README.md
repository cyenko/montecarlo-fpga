# montecarlo-fpga
Black-Scholes style options pricing using Monte Carlo methods. Written in VHDL for the Cyclone IV FPGA board.

## Overview

The goal of this project is to deliver a working prototype of a simulation-based European-style options pricer. We will be using the Monte-Carlo random trials method to approximate the price of an option, in conjunction with the stock evolution method found in a 1973 paper published by Fischer Black and Myron Scholes. This method takes the standard Partial Differential Equation form of stock price, discretizes via forward Euler discretization, and expresses the final stochastic PDE result as a payoff of a random drawing from a risk neutral distribution of stock prices.

By summing up these payoffs and dividing by the number of trials, we obtain a simulated approximation of the option price that (for large n) very closely resembles the price found via the famous Black Scholes closed-form solution.

## Implementation

### bs-montecarlo-european.py

Quick python prototype of the MC-BS implementation we will be building in VHDL for the FPGA board. Calculates the call option payoff using the Monte-Carlo simulation method and a Euler discretized form of Black-Scholes.

Tested to be in compliance with the BS closed form solution with n=100000.

### bs-closedform-european.py

Quick python prototype of the closed form BS implementation, in order to compare price accuracy with our MC-BS Python implementation and ultimately our MC-BS FPGA implementation.

## FAQ

### Why Monte Carlo and not standard Black-Scholes?

The standard Black-Scholes Partial Differential Equation would provide a closed form solution for the pricing of a 'plain vanilla' European style option; however, BS tends to perform poorly when valuing options with multiple and/or variable parameters (stochastic/varying interest rates, FX rates, etc.).

Options pricing via simulation would allow the creation of a multi-factor, rather than single-factor, model of the more exotic options available on the market today. We use the Monte Carlo method, which essentially takes the mean of a large number of repeated samples, as a proof-of-concept simulation method.

Traditionally, Monte-Carlo has been used as the benchmark valuation technique of European style exotic options given its general reliability as the number of random paths taken converges to infinity (https://people.maths.ox.ac.uk/richardsonm/OptionPricing.pdf). This reliability and benchmark status comes at a large computational and time cost, which leads us to...

### Why FPGA?

The nature of Monte Carlo sampling is such that a large number of simulations are run in order to obtain an accurate result. The more samples collected, the higher the accuracy of the end result. 

Given that each Black-Scholes random trial is independent of one another, we can implement the Monte Carlo method on FPGA boards to take advantage of the FPGA's superior parallel processing power to accomplish these simulations at a faster rate.

## TODO

- Implement BS Monte Carlo for European Options in Python