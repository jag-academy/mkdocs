# ~\~ language=Shell filename=tutorials/plutus/scripts/10_create_wallets.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/scripts/10_create_wallets.sh>>[0]
# ~\~ begin <<docs/06-Plutus-transactions.md|execute-in-bash-strict-mode>>[0]
#The shebang must be the first line of the file, but then it get's mixed with entangled comments
# this script must be executed with `bash $name_of_script`
#!/bin/bash
set -xeEuo pipefail
#IFS=$'\n\t'

function select_utxo_with_most_value()
{
    cut --delimiter=' ' --fields=14,1,6 --only-delimited < /dev/stdin | \
        sort --human-numeric-sort --key=3|
        cut --delimiter=' ' --fields=1,2 --output-delimiter="#" |\
            tail --lines=1 > /dev/stdout
}

assert_not_empty(){
    [ "$var" ] || { echo "Parameter 1 is empty" ; exit 1; }
}

assert_there_is_txhash(){
    local var="$1"
    [ ${#var} == 66 ] || { echo "TxHash can't be empty" ; exit 1; }
}

readonly CARDANO_NODE_SOCKET_PATH=/ipc/node.socket
readonly NETWORK_ID="--testnet-magic 1097911063" # or "--mainnet"
# ~\~ end

#### Build and submit a simple (non-Plutus) transaction
### Ensure that you have the latest tagged version era.

# ~\~ begin <<docs/06-Plutus-transactions.md|ensure-you-are-in-alonzo>>[0]

cardano-cli query tip ${NETWORK_ID}
# ~\~ end


function create_wallets(){
    local OWNER=$1


# ~\~ begin <<docs/06-Plutus-transactions.md|generate-wallets>>[0]
cardano-cli address key-gen \
--verification-key-file ./temp/$OWNER.vkey \
--signing-key-file ./temp/$OWNER.skey

cardano-cli stake-address key-gen \
--verification-key-file ./temp/$OWNER.stake.vkey \
--signing-key-file ./temp/$OWNER.stake.skey

cardano-cli address build \
--payment-verification-key-file ./temp/$OWNER.vkey \
--stake-verification-key-file ./temp/$OWNER.stake.vkey \
--out-file ./temp/$OWNER.addr \
$NETWORK_ID
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|generate-wallets>>[1]

# ~\~ end

}

create_wallets 'alice'

# echo "Calling the faucet API to get some funds for our new wallets"
# readonly APIKEY=$(cat ./secrets/api.key)
# curl --insecure -v -XPOST "https://faucet.cardano-testnet.iohkdev.io/send-money/${ALICE_ADDR}?apiKey=${APIKEY}"


### create a 2nd address

create_wallets 'bob'
echo "Wallets generated"

### Once we have proven that the instructions to generate an address still work.
#   We will copy the known good adressess

cp ./secrets/alice* ./temp/
cp ./secrets/bob* ./temp/


# ~\~ begin <<docs/06-Plutus-transactions.md|read-payment-address-to-variable>>[0]
readonly ALICE_ADDR=$(cat ./temp/alice.addr)
echo
echo "Payment address is: $ALICE_ADDR"

# ~\~ end


# ~\~ begin <<docs/06-Plutus-transactions.md|verify-payment-address-has-funds>>[0]
cardano-cli query utxo --address ${ALICE_ADDR} $NETWORK_ID
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|read-utxo-to-variable>>[0]
readonly UTXO_TXIX=$(cardano-cli query utxo $NETWORK_ID --address $ALICE_ADDR | select_utxo_with_most_value)
echo
echo "UTxO:$UTXO_TXIX"
# ~\~ end

assert_there_is_txhash $UTXO_TXIX

# Now that we know that the instructions to create wallets work.
# let's substitute the files, with the ones we know have funds,
# so that the following tests also work.


# ~\~ end
