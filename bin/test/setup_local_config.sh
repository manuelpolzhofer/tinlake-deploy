#! /usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
BIN_DIR=${BIN_DIR:-$(cd "${0%/*}"&&pwd)}
cd $BIN_DIR
export DAPP_JSON=$BIN_DIR/../../lib/tinlake/out/dapp.sol.json
source $BIN_DIR/../util/util.sh

# set SETH enviroment variable
source $BIN_DIR/local_env.sh

# Defaults
test -z "$CURRENCY_SYMBOL" && CURRENCY_SYMBOL="DAI"
test -z "$CURRENCY_NAME" && CURRENCY_NAME="DAI Stablecoin"
test -z "$CURRENCY_VERSION" && CURRENCY_VERSION="a"
test -z "$CURRENCY_CHAINID" && CURRENCY_CHAINID=1

# Deploy Default Currency
message create ERC20 Tinlake currency
TINLAKE_CURRENCY=$(DAPP_ROOT=$BIN_DIR/../../lib/tinlake dapp create 'src/test/simple/token.sol:SimpleToken' '"$CURRENCY_SYMBOL"' '"$CURRENCY_NAME"')

message create Main Deployer
MAIN_DEPLOYER=$(DAPP_ROOT=$BIN_DIR/../../ DAPP_JSON=$BIN_DIR/../../out/dapp.sol.json dapp create src/deployer.sol:MainDeployer)

CONFIG_FILE=$1
[ -z "$1" ] && CONFIG_FILE="$BIN_DIR/../config_$(seth chain).json"

touch $CONFIG_FILE

addValuesToFile $CONFIG_FILE <<EOF
{
    "ETH_RPC_URL" :"$ETH_RPC_URL",
    "ETH_FROM" :"$ETH_FROM",
    "ETH_GAS_PRICE" :"$ETH_GAS_PRICE",
    "ETH_GAS": "$ETH_GAS",
    "ETH_KEYSTORE" :"$ETH_KEYSTORE",
    "ETH_PASSWORD" :"$ETH_PASSWORD",
    "TINLAKE_CURRENCY": "$TINLAKE_CURRENCY",
    "MAIN_DEPLOYER": "$MAIN_DEPLOYER",
    "SENIOR_INTEREST_RATE": "1000000003593629043335673583",
    "MAX_RESERVE": "100000000000000000000",
    "MAX_SENIOR_RATIO": "850000000000000000000000000",
    "MIN_SENIOR_RATIO": "750000000000000000000000000",
    "CHALLENGE_TIME": "3600",
    "DISCOUNT_RATE": "1000000001585489599188229325"
}
EOF
message config file created
cat $CONFIG_FILE
message Path: $(realpath $CONFIG_FILE)
