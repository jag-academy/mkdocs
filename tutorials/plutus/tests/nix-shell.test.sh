# ~\~ language=Shell filename=tutorials/plutus/tests/nix-shell.test.sh
# ~\~ begin <<docs/06-Plutus-transactions.md|tutorials/plutus/tests/nix-shell.test.sh>>[0]
#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# ~\~ begin <<docs/06-Plutus-transactions.md|start-nix-shell>>[0]
nix-shell plutus-tutorial.nix
# ~\~ end

# ~\~ begin <<docs/06-Plutus-transactions.md|verify-ghc-version>>[0]
[nix-shell:~]$ ghc --version
The Glorious Glasgow Haskell Compilation System, version 8.10.4

[nix-shell:~]$ cabal --version
cabal-install version 3.4.0.0
compiled using version 3.4.0.0 of the Cabal library
# ~\~ end
# ~\~ end
