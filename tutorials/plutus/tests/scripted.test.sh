# ~\~ language=Shell filename=tutorials/plutus/tests/scripted.test.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/tests/scripted.test.sh>>[0]
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

# ~\~ begin <<docs/06-Plutus-transactions.md|install-nix>>[0]
# sh <(curl -L https://nixos.org/nix/install) --daemon
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|setup-binary-cache>>[0]
sudo mkdir -p /etc/nix
cat <<EOF | sudo tee /etc/nix/nix.conf
substituters = https://cache.nixos.org https://hydra.iohk.io
trusted-public-keys = iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo= hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
EOF
# ~\~ end



# ~\~ begin <<docs/06-Plutus-transactions.md|install-cardano-node>>[0]
git clone --depth 1 https://github.com/input-output-hk/cardano-node
cd cardano-node
git fetch --all --recurse-submodules --tags

#latesttag=$(git describe --tags)
#git checkout tags/$latesttag
git checkout tags/1.29.0
# ~\~ end

cp ../tutorials/plutus/plutus-tutorial.nix .


# ~\~ end
