from brownie import accounts, network, config, MockV3Aggregator

LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local", "hardhat", "anvil"]
DECIMALS = 8
STARTING_PRICE = 2000 * 10**DECIMALS  # fake $2000/ETH for local testing

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return accounts[0]
    # Load from .env via brownie-config.yaml
    return accounts.add(config["wallets"]["from_key"])

def deploy_mocks():
    if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        return
    if len(MockV3Aggregator) == 0:
        MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": get_account()})

def get_price_feed_address():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
        deploy_mocks()
        return MockV3Aggregator[-1].address
    # Real Chainlink feed from config on Sepolia/Mainnet
    return config["networks"][network.show_active()]["eth_usd_price_feed"]
