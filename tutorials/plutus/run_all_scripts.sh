#!/bin/bash

function retry() {
    command="$*"
    retval=1
    attempt=1
    until [[ $retval -eq 0 ]] || [[ $attempt -gt 30 ]]; do
        # Execute inside of a subshell in case parent
        # script is running with "set -e"
        (
            set +e
            $command
        )
        retval=$?
        attempt=$(( attempt + 1 ))
        if [[ $retval -ne 0 ]]; then
            # If there was an error wait 10 seconds
            sleep 600
        fi
    done
    if [[ $retval -ne 0 ]] && [[ $attempt -gt 30 ]]; then
        # Something is fubar, go ahead and exit
        exit $retval
    fi
}

    # until docker-compose run node cli query tip --testnet-magic 1097911063; do sleep 15; done && \
    #    retry docker-compose run node cli query tip --testnet-magic 1097911063 && \
    docker-compose run --entrypoint="/bin/bash" node -c pwd
    docker-compose run --entrypoint="/bin/bash" node /plutus/scripts/10_create_wallets.sh && \
        docker-compose run --entrypoint="/bin/bash" node /plutus/scripts/20_submit_simple_transaction.sh && \
        docker-compose run --entrypoint="/bin/bash" node /plutus/scripts/30_submit_plutus_transaction.sh
