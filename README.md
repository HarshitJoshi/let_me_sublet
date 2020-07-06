## Issue

Subleasing can be hard, especially when you're working with limited information about the other person's finances. A sublease is a good way to keep track of your finances and save money when you're not living temporarily in your apartment for some unforseen reasons such as long business trips, vacation, an internship in another state/country, medical issues, etc. Subletting your apartment allows you to avoid incurring the absurd lease break fee if you intend to return after a period of time. As stated [here](https://www.forrent.com/blog/apartment-hunting/subleasing-guide/) it does come with certain implications:

*The most important thing you need to know about subleasing is that if you’re subletting to someone, you’re ultimately responsible for paying the rent. If you’re subtenant can’t or won’t pay, you’ll be required to pay the rent in full since your name is on the lease and theirs (typically) won’t be. Make sure you screen your subtenants carefully.*

## Approach 

This smart contract approaches to solve the above-described issue by utilizing the [chainlink network protocol](https://link.smartcontract.com/whitepaper) and existing Ethereum smart contract environment. This project is currently a work in progress.

Some of the highlights of the project include:

- A mechanism for fair sublet details such as sublease length, payment due date, fixed deposit scheme, etc.
- Penalty to ensure timely payments towards the sublease 
- Safety of the fixed deposit funds including other payments towards sublease through time-locking and strict checks 
- Withdraw mechanism for the owner to liquidate funds towards lease payments, chainlink will provide accurate data related to the medium of exchange chosen to overcome the issue of volatility with crypto
- Safe disbursement of fixed deposit after the lease term is over to the sublessee
- (Maybe?) ERC721 token to provide some sort of additional ownership rights other than agreement

I will add more features and details as I go down implementing the list

## Motivation

The goal of this project is to learn more about smart contracts, ethereum ecosystem, and chainlink while tackling with a real-world issue that I myself have encountered in the past. I plan to use a combination of Solidity, Node.js, Web3, Go, Vue, etc. for the project.
