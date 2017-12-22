# library-DApp-tutorial
This is TK's first step for DApp. Please refer to Truffle's pet-shop-tutorial.

  * http://truffleframework.com/tutorials/pet-shop

## project structure

### directories
  * /contracts: This is directory for our Solidity contracts
  * /migrations: This is directory for deploying our contracts
  * /test: Truffle framework provides test for our contracts. This is for that.
  * /src: For our web interface

### architecture
  * Network
    * Test blockchain network(Ganache): http://localhost:7545
    * Lite-server web host: http://localhost:3000
  * Smart Contract
    * Core: Library.sol
    * Compiler: Truffle develop(using compile command)
  * Web interface
    * Laguges: HTML, JavaSript, CSS
    * Libraries: Web3.js, Truffle-contract.js
