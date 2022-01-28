# ~\~ language=Shell filename=tutorials/plutus/scripts/20_submit_simple_transaction.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/scripts/20_submit_simple_transaction.sh>>[0]

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

readonly CARDANO_NODES_OCKET_PATH=/ipc/node.socket
readonly NETWORK_ID="--testnet-magic 1097911063" # or "--mainnet"
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|read-payment-address-to-variable>>[0]
readonly ALICE_ADDR=$(cat ./temp/alice.addr)
echo
echo "Payment address is: $ALICE_ADDR"

# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|read-utxo-to-variable>>[0]
readonly UTXO_TXIX=$(cardano-cli query utxo $NETWORK_ID --address $ALICE_ADDR | select_utxo_with_most_value)
echo
echo "UTxO:$UTXO_TXIX"
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|build-transaction>>[0]
cardano-cli transaction build \
--alonzo-era \
$NETWORK_ID \
--change-address ${ALICE_ADDR} \
--tx-in ${UTXO_TXIX} \
--tx-out $(cat ./temp/bob.addr)+5000000 \
--out-file ./temp/tx.build
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|sign-simple-transaction>>[0]
cardano-cli transaction sign \
--tx-body-file ./temp/tx.build \
$NETWORK_ID \
--signing-key-file ./temp/alice.skey \
--out-file ./temp/tx.signed

# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|submit-simple-transaction>>[0]
cardano-cli transaction submit --tx-file ./temp/tx.signed $NETWORK_ID
# ~\~ end

echo "Awaiting Transaction to be committed..."
sleep 60

echo "and the 2nd payment adress has 50,000,000 *more* lovelaces"
# ~\~ begin <<docs/06-Plutus-transactions.md|query-2nd-address>>[0]
cardano-cli query utxo --address $(cat ./temp/bob.addr) $NETWORK_ID
# ~\~ end

echo "and the 1st payment adress has 50,000,000 *less* lovelaces"
# ~\~ begin <<docs/06-Plutus-transactions.md|query-1st-address>>[0]
cardano-cli query utxo --address ${ALICE_ADDR} $NETWORK_ID
# ~\~ end

echo "End: We were able to submit a simple transaction"

# ~\~ end
