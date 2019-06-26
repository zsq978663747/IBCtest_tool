PWD=`pwd`

docker run -d \
--ulimit core=-1 --security-opt seccomp=unconfined \
--name IBC_EOS_bp1 \
--network test-network \
-p 1014:8888 \
-p 1015:9876 \
-v $PWD/eos_bp:/opt/eosio/bin/data-dir \
deadlock/eos-tps:eos-v1.6.6   \
/opt/eosio/bin/nodeos --config-dir /opt/eosio/bin/data-dir/config --data-dir /opt/eosio/bin/data-dir/data --max-transaction-time=100000 --wasm-runtime wabt --genesis-json /opt/eosio/bin/data-dir/config/genesis.json