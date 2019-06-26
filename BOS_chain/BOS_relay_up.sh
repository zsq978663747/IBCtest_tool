PWD=`pwd`

docker run -d \
--ulimit core=-1 --security-opt seccomp=unconfined \
--name IBC_BOS_relay \
--network test-network \
-p 2016:8888 \
-p 2017:9876 \
-v $PWD/bos_relay:/opt/eosio/bin/data-dir \
boscore/ibc_plugin_bos:ibc-v1.0.7   \
/opt/eosio/bin/nodeos --config-dir /opt/eosio/bin/data-dir/config --data-dir /opt/eosio/bin/data-dir/data --max-transaction-time=100000 --wasm-runtime wabt --genesis-json /opt/eosio/bin/data-dir/config/genesis.json