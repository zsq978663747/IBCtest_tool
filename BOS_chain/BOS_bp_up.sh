PWD=`pwd`

docker run -d \
--ulimit core=-1 --security-opt seccomp=unconfined \
--name IBC_BOS_bp1 \
--network test-network \
-p 2014:8888 \
-p 2015:9876 \
-v $PWD/bos_bp:/opt/eosio/bin/data-dir \
boscore/bos:v2.0.3   \
/opt/eosio/bin/nodeos --config-dir /opt/eosio/bin/data-dir/config --data-dir /opt/eosio/bin/data-dir/data --max-transaction-time=100000 --wasm-runtime wabt --genesis-json /opt/eosio/bin/data-dir/config/genesis.json