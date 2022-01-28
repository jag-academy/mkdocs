docker-compose run --entrypoint="/bin/bash" node /plutus/scripts/10_create_wallets.sh && \
    docker-compose run --entrypoint="/bin/bash" node /plutus/scripts/20_submit_simple_transaction.sh && \
    docker-compose run --entrypoint="/bin/bash" node /plutus/scripts/30_submit_plutus_transaction.sh
