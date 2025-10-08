# 💰 Fund Me + Simple Storage Smart Contract

A Solidity smart contract project that combines **crowdfunding** and **data storage** on the Ethereum blockchain.  
Built using **Brownie** and deployed on the **Sepolia Testnet**.

---

## 🚀 Features

### 🪙 Fund Me
- Users can **send ETH** to the contract.
- Only the **owner** can withdraw funds.
- Keeps track of how much each address has funded.
- Uses **price feeds (Chainlink)** for ETH/USD conversions.

### 🧠 Simple Storage
- Users can **store and retrieve** a single unsigned integer.
- Demonstrates **state variables**, **transactions**, and **view functions**.

---

## 🧰 Tech Stack

- **Language:** Solidity `^0.8.x`
- **Framework:** Brownie (Python)
- **Network:** Sepolia Testnet
- **Tools:** MetaMask, Infura, Chainlink
- **IDE:** Remix / VS Code

---

## ⚙️ Setup & Deployment

### 1️⃣ Clone the repository
```bash
git clone https://github.com/nwafor1chisom/fund_me_simple_storage.git
cd fund_me_simple_storage
