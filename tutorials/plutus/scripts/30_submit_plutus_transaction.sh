# ~\~ language=Shell filename=tutorials/plutus/scripts/30_submit_plutus_transaction.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/scripts/30_submit_plutus_transaction.sh>>[0]

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

# ~\~ begin <<docs/06-Plutus-transactions.md|ensure-you-are-in-alonzo>>[0]

cardano-cli query tip ${NETWORK_ID}
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|calculate-script-address>>[0]
cardano-cli address build \
--payment-script-file ./temp/alwayssucceeds.plutus \
$NETWORK_ID \
--out-file ./temp/script.addr
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|calculate-script-address>>[1]
cat ./temp/script.addr
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|get-datum-hash>>[0]
export SCRIPTDATUMHASH=$(cardano-cli transaction hash-script-data --script-data-value 42)
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|get-protocol-parameters>>[0]
cardano-cli query protocol-parameters \
$NETWORK_ID \
--out-file ./temp/pparams.json
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

# ~\~ begin <<docs/06-Plutus-transactions.md|build-transaction-to-alwayssucceeds>>[0]
cardano-cli transaction build \
--alonzo-era \
$NETWORK_ID \
--change-address ${ALICE_ADDR} \
--tx-in "$UTXO_TXIX" \
--tx-out $(cat ./temp/script.addr)+1379280 \
--tx-out-datum-hash ${SCRIPTDATUMHASH} \
--protocol-params-file ./temp/pparams.json \
--out-file ./temp/tx-script.build
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|sign-transaction-to-alwayssucceeds>>[0]
cardano-cli transaction sign \
--tx-body-file ./temp/tx-script.build \
--signing-key-file ./temp/alice.skey \
$NETWORK_ID \
--out-file ./temp/tx-script.signed
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|submit-transaction-to-alwayssucceeds>>[0]
cardano-cli transaction submit $NETWORK_ID --tx-file ./temp/tx-script.signed
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|query-personal-and-script-addresses>>[0]
cardano-cli query utxo --address ${ALICE_ADDR} $NETWORK_ID
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|get-script-address-balance>>[0]
export SCRIPT_ADDR=$(cat ./temp/script.addr)
cardano-cli query utxo --address $SCRIPT_ADDR $NETWORK_ID
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|ensure-you-are-in-alonzo>>[0]

cardano-cli query tip ${NETWORK_ID}
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|get-script-address-balance>>[0]
export SCRIPT_ADDR=$(cat ./temp/script.addr)
cardano-cli query utxo --address $SCRIPT_ADDR $NETWORK_ID
# ~\~ end

#copying busybox from the test script directory to bin
cp ./busybox /bin/
ln -s -T /bin/busybox /bin/grep


# ~\~ begin <<docs/06-Plutus-transactions.md|plutusUtxoTxin>>[0]
# export PLUTUSUTXOTXIN=68a947f8ccb6845d3abf67376680509b476ea1cca187a486a93703bf59493f19#1
PLUTUSUTXOTXIN=$(cardano-cli query utxo --address $SCRIPT_ADDR $NETWORK_ID | grep "1379280"|tail -n1 | cut --delimiter=" " --output-delimiter="#" -f 1,6)
readonly PLUTUSUTXOTXIN
# ~\~ end


### 4. Submit transaction to execute Plutus script

# ~\~ begin <<docs/06-Plutus-transactions.md|get-balance-2nd-address>>[0]
export BOB_ADDR=$(cat ./temp/bob.addr)
cardano-cli query utxo --address $BOB_ADDR $NETWORK_ID
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|txCollateral>>[0]
export txCollateral=$(cardano-cli query utxo $NETWORK_ID --address $BOB_ADDR | select_utxo_with_most_value)
echo
echo "txCollateral: $txCollateral"
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|build-transaction-to-unlock-funds>>[0]
cardano-cli transaction build \
            --alonzo-era \
            $NETWORK_ID \
            --tx-in ${PLUTUSUTXOTXIN} \
            --tx-in-script-file ./temp/alwayssucceeds.plutus \
            --tx-in-datum-value 42 \
            --tx-in-redeemer-value 42 \
            --tx-in-collateral ${txCollateral} \
            --change-address ${ALICE_ADDR} \
            --protocol-params-file ./temp/pparams.json \
            --out-file ./temp/test-alonzo.tx
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|sign-transaction-to-unlock-funds>>[0]
cardano-cli transaction sign \
--tx-body-file ./temp/test-alonzo.tx \
--signing-key-file ./temp/bob.skey \
$NETWORK_ID \
--out-file ./temp/test-alonzo.signed
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|submit-transaction-to-unlock-funds>>[0]
cardano-cli transaction submit $NETWORK_ID --tx-file ./temp/test-alonzo.signed
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|query-both-addresses>>[0]
echo "Bob address has the funds liberated"
cardano-cli query utxo --address $(cat ./temp/bob.addr) $NETWORK_ID

echo "now the contract address has one uxto less"
cardano-cli query utxo --address $(cat ./temp/script.addr) $NETWORK_ID | grep "1379280"
# ~\~ end
# ~\~ end
