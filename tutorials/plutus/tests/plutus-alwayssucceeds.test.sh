# ~\~ language=Shell filename=tutorials/plutus/tests/plutus-alwayssucceeds.test.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/tests/plutus-alwayssucceeds.test.sh>>[0]
# ~\~ begin <<docs/06-Plutus-transactions.md|execute-in-bash-strict-mode>>[0]
#The shebang must be the first line of the file, but then it get's mixed with entangled comments
# this script must be executed with `bash $name_of_script`
#!/bin/bash
set -xeuo pipefail
IFS=$'\n\t'
# ~\~ end

cd cardano-node

# ~\~ begin <<docs/06-Plutus-transactions.md|start-nix-shell>>[0]
nix-shell ./plutus-tutorial.nix
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|clone-plutus-alwayssucceeds>>[0]
git clone https://github.com/input-output-hk/Alonzo-testnet.git
cd Alonzo-testnet/resources/plutus-sources/plutus-alwayssucceeds
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|serialize-on-chain-code>>[0]
cabal update
cabal build
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|execute-alwayssucceeds>>[0]
cabal run plutus-alwayssucceeds -- 42 alwayssucceeds.plutus
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|print-serialized-alwayssucceeds>>[0]
cat alwayssucceeds.plutus
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|ensure-you-are-in-alonzo>>[0]
cardano-cli query tip --mainnet
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|generate-wallets>>[0]
cardano-cli address key-gen \
--verification-key-file payment.vkey \
--signing-key-file payment.skey

cardano-cli stake-address key-gen \
--verification-key-file stake.vkey \
--signing-key-file stake.skey

cardano-cli address build \
--payment-verification-key-file payment.vkey \
--stake-verification-key-file stake.vkey \
--out-file payment.addr \
--mainnet
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|generate-wallets>>[1]
cat payment.addr
# ~\~ end

#### Build and submit a simple (non-Plutus) transaction

# ~\~ begin <<docs/06-Plutus-transactions.md|submit-non-plutus-transaction>>[0]
cardano-cli query utxo --address $(cat payment.addr) --mainnet
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|build-transaction>>[0]
cardano-cli transaction build \
--alonzo-era \
--mainnet \
--change-address $(cat payment.addr) \
--tx-in 8c6f74370d823130847efe3d2e2e128f0e79c8e907fda692353d841dd0d6cb38#0 \
--tx-out $(cat payment2.addr)+500000000 \
--out-file tx.build
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|sign-transaction>>[0]
cardano-cli transaction sign \
--tx-body-file tx.build \
--mainnet \
--signing-key-file payment.skey \
--out-file tx.signed

cardano-cli transaction submit --tx-file tx.signed --mainnet
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|query-2nd-address>>[0]
cardano-cli query utxo --address $(cat payment2.addr) --mainnet
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|query-1st-address>>[0]
cardano-cli query utxo --address $(cat payment.addr) --mainnet
# ~\~ end

#### Transaction to lock funds

# ~\~ begin <<docs/06-Plutus-transactions.md|calculate-script-address>>[0]
cardano-cli address build \
--payment-script-file alwayssucceeds.plutus \
--mainnet \
--out-file script.addr
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|calculate-script-address>>[1]
cat script.addr
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|get-datum-hash>>[0]
cardano-cli transaction hash-script-data --script-data-value 42
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|get-protocol-parameters>>[0]
cardano-cli query protocol-parameters \
--mainnet \
--out-file pparams.json
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|build-transaction-to-alwayssucceeds>>[0]
cardano-cli transaction build \
--alonzo-era \
--mainnet \
--change-address $(cat payment.addr) \
--tx-in d7d207438c90fe611c1a14be29974b1662f8563331bf6fba4b6569e089ffa561#0 \
--tx-out $(cat script.addr)+1379280 \
--tx-out-datum-hash ${scriptdatumhash} \
--protocol-params-file pparams.json \
--out-file tx-script.build
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|sign-transaction-to-alwayssucceeds>>[0]
cardano-cli transaction sign \
--tx-body-file tx-script.build \
--signing-key-file payment.skey \
--mainnet \
--out-file tx-script.signed
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|submit-transaction-to-alwayssucceeds>>[0]
cardano-cli transaction submit --mainnet --tx-file tx-script.signed
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|query-personal-and-script-addresses>>[0]
cardano-cli query utxo --address $(cat payment.addr) --mainnet
# ~\~ end
# ~\~ begin <<docs/06-Plutus-transactions.md|query-personal-and-script-addresses>>[1]
cardano-cli query utxo --address $(cat script.addr) --mainnet
# ~\~ end

### 4. Submit transaction to execute Plutus script

# ~\~ begin <<docs/06-Plutus-transactions.md|get-balance>>[0]
cardano-cli query utxo --address $(cat payment2.addr) --mainnet
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|build-transaction-to-unlock-funds>>[0]
cardano-cli transaction build \
--alonzo-era \
--mainnet \
--tx-in ${plutusutxotxin} \
--tx-in-script-file alwayssucceeds.plutus \
--tx-in-datum-value 42 \
--tx-in-redeemer-value 42 \
--tx-in-collateral ${txCollateral} \
--change-address $(cat payment.addr) \
--protocol-params-file pparams.json \
--out-file test-alonzo.tx
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|sign-transaction-to-unlock-funds>>[0]
cardano-cli transaction sign \
--tx-body-file test-alonzo.tx \
--signing-key-file payment.skey \
--mainnet \
--out-file test-alonzo.signed
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|submit-transaction-to-unlock-funds>>[0]
cardano-cli transaction submit --mainnet --tx-file test-alonzo.signed
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|query-both-addresses>>[0]
cardano-cli query utxo --address $(cat payment2.addr) --mainnet


cardano-cli query utxo --address $(cat script.addr) --mainnet
# ~\~ end
# ~\~ end
