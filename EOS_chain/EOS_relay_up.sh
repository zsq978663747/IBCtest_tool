PWD=`pwd`

docker run -d \
--ulimit core=-1 --security-opt seccomp=unconfined \
--name IBC_EOS_relay \
--network test-network \
-p 1016:8888 \
-p 1017:9876 \
-p 1018:6001 \
-v $PWD/eos_relay:/opt/eosio/bin/data-dir \
boscore/ibc_plugin_eos:ibc-v1.0.7   \
/opt/eosio/bin/nodeos --config-dir /opt/eosio/bin/data-dir/config --data-dir /opt/eosio/bin/data-dir/data --max-transaction-time=100000 --wasm-runtime wabt --genesis-json /opt/eosio/bin/data-dir/config/genesis.json
