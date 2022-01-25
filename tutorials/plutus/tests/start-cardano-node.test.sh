# ~\~ language=Shell filename=tutorials/plutus/tests/start-cardano-node.test.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/tests/start-cardano-node.test.sh>>[0]
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


# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|verify-ghc-version>>[0]
ghc --version

cabal --version
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|start-passive-cardano-node>>[0]
cardano-node-mainnet
# ~\~ end

cd cardano-node

# ~\~ end
