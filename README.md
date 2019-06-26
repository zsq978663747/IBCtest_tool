# IBCtest_tool

# step 1 create a common network 
```
docker network create test-network
```
#step 2 start up a EOS chain 
```
cd EOS_chain && ./EOS_bp_up.sh
./init_eos_chain.sh
```
#step 3 start up a EOS-relay
```
./EOS_relay_up.sh
```

#step 4 start up a BOS chain
```
cd ../BOS_chain && ./BOS_bp_up.sh
./init_bos_chain.sh
```

#step 5 start up a EOS-relay
```
./BOS_relay_up.sh
```

#step 