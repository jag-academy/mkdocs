# ~\~ language=Shell filename=tutorials/plutus/tests/scripted.test.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/tests/scripted.test.sh>>[0]
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'


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

# ~\~ begin <<docs/06-Plutus-transactions.md|start-nix-shell>>[0]
nix-shell ./plutus-tutorial.nix
# ~\~ end

# ~\~ end
