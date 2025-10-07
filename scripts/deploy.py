from brownie import FundMe, network, config
from scripts.helpful_scripts import get_account, get_price_feed_address

def deploy_fund_me():
    account = get_account()
    price_feed = get_price_feed_address()

    # Only try to verify on non-local networks and when a token is present
    verify_flag = bool(config["networks"].get(network.show_active(), {}).get("verify", False))
    if network.show_active() in ["development", "ganache-local", "hardhat", "anvil"]:
        verify_flag = False

    fund_me = FundMe.deploy(
        price_feed,
        {"from": account},
        publish_source=verify_flag
    )
    print(f"✅ FundMe deployed at: {fund_me.address}")
    return fund_me

def main():
    deploy_fund_me()
