#cleos wallet import --private-key <private-key>

# step 4: set contract eosio.bios
URL='-u http://127.0.0.1:2014'
CONTRACTS_FOLDER='./bos.contract-prebuild' 
cleos $URL set contract eosio ${CONTRACTS_FOLDER}/eosio.bios -p eosio

# step 5: create system accounts

for account in eosio.bpay eosio.msig eosio.names eosio.ram eosio.ramfee eosio.saving eosio.stake eosio.token eosio.vpay eosio.wrap bos.dev bos.gov redpacket bos.btc bos.eth bos.eos
do 
    echo -e "\n creating $account \n"; 
    cleos  $URL create account eosio ${account} EOS7hHHDtnPRbhMmfHJHUEKQyiutKrt9wZPdy1JbaATVLyxpCkrop; 
    sleep 1; 
done

cleos $URL create account eosio bos EOS7hHHDtnPRbhMmfHJHUEKQyiutKrt9wZPdy1JbaATVLyxpCkrop

for account in uid bos.stake1 bos.stake2  bos.stake3
do 
    echo -e "\n creating $account \n"; 
    cleos $URL create account eosio ${account} EOS7hHHDtnPRbhMmfHJHUEKQyiutKrt9wZPdy1JbaATVLyxpCkrop; 
    sleep 1; 
done

for account in bos.dapp bos.boost bos.airdrop
do 
    echo -e "\n creating $account \n"; 
    cleos $URL create account eosio ${account} EOS7hHHDtnPRbhMmfHJHUEKQyiutKrt9wZPdy1JbaATVLyxpCkrop; 
    sleep 1; 
done

# set an abp 
cleos  $URL create account eosio bos.abp EOS7hHHDtnPRbhMmfHJHUEKQyiutKrt9wZPdy1JbaATVLyxpCkrop
cleos $URL push action eosio setprods '{"schedule":[{"producer_name":"boscoretokyo","block_signing_key":"EOS7hHHDtnPRbhMmfHJHUEKQyiutKrt9wZPdy1JbaATVLyxpCkrop"}]}' -p eosio

# step 6: set token and msig contract
cleos $URL set contract eosio.token ${CONTRACTS_FOLDER}/eosio.token -p eosio.token 
cleos $URL set contract eosio.msig ${CONTRACTS_FOLDER}/eosio.msig -p eosio.msig

# step 7: create and issue token

cleos $URL push action eosio.token create '["eosio", "10000000000.0000 BOS"]' -p eosio.token 
cleos $URL push action eosio.token issue '["eosio", "1013000000.0000 BOS", "BOSCore"]' -p eosio


# setp 8: setting privileged account for eosio.msig

cleos $URL push action eosio setpriv '{"account": "eosio.msig", "is_priv": 1}' -p eosio

# step 9: set contract eosio.system

cleos $URL set contract eosio ${CONTRACTS_FOLDER}/eosio.system -x 1000 -p eosio

cleos $URL push action eosio init '{"version": 0, "core": "4,BOS"}' -p eosio

# step 10: set contract eosio.wrap

cleos $URL set contract eosio.wrap ${CONTRACTS_FOLDER}/eosio.wrap -x 1000 -p eosio.wrap

# step 11: transfer some token 

cleos $URL transfer eosio bos        "100000000 BOS"
cleos $URL transfer eosio bos.stake1 "300000000 BOS"
cleos $URL transfer eosio bos.stake2 "300000000 BOS"
cleos $URL transfer eosio bos.stake3 "200000000 BOS"

cleos $URL transfer eosio bos.dapp    "70000000 BOS"
cleos $URL transfer eosio bos.boost   "20000000 BOS"
cleos $URL transfer eosio bos.airdrop "10000000 BOS"

# step last: resign all system account
#for account in eosio.bpay eosio.msig eosio.names eosio.ram eosio.ramfee eosio.saving eosio.stake eosio.token eosio.vpay
#do
# cleos push action eosio updateauth '{"account": "'$account'", "permission": "active", "parent": "owner", "auth":{"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": active}}]}}' -p ${account}@active
#  cleos push action eosio updateauth '{"account": "'$account'", "permission": "owner", "parent": "",       "auth":{"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio", "permission": active}}]}}' -p ${account}@owner
# sleep 1;
#done

## check system accounts
#for account in eosio.bpay eosio.msig eosio.names eosio.ram eosio.ramfee eosio.saving eosio.stake eosio.token eosio.vpay
#do
 # echo --- ${account} --- && cleos get account ${account} && sleep 1;
#done

#cleos push action eosio updateauth '{"account": "eosio", "permission": "active", "parent": "owner", "auth":{"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio.prods", "permission": active}}]}}' -p eosio@active
#cleos push action eosio updateauth '{"account": "eosio", "permission": "owner", "parent": "",       "auth":{"threshold": 1, "keys": [], "waits": [], "accounts": [{"weight": 1, "permission": {"actor": "eosio.prods", "permission": active}}]}}' -p eosio@owner

# step 12 create voter and bp account
cleos $URL  system newaccount --stake-net "10.0000 BOS" --stake-cpu "100.0000 BOS" --buy-ram "10.0000 BOS"  eosio voter  EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT
cleos $URL transfer eosio voter "10000000.0000 BOS"
cleos $URL system delegatebw voter voter "5000000.0000 BOS" "5000000.0000 BOS"

cleos $URL system newaccount --stake-net "2.0000 BOS" --stake-cpu "800.0000 BOS" --buy-ram "1.0000 BOS" eosio bosiotpsbest EOS8NhELUmBV4YLUgNwDKo5karTVCRNyo5AhUZNhbwTa1mZFh9kuw EOS68EdHU7dH8E1Zj2aovS19SVGYgjA6aPwmXTM9Phb1qatB2i3Yh 

cleos $URL  system newaccount --stake-net "1000000.0000 BOS" --stake-cpu "1000000.0000 BOS" --buy-ram "300.0000 BOS"  eosio bostesttps11  EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT


for account in boscorebos11 boscorebos12 boscorebos13 boscorebos14 boscorebos15 boscoretokyo boscorebos21 boscorebos22 boscorebos23 boscorebos24 boscorebos25 boscorebos31 boscorebos32 boscorebos33 boscorebos34 boscorebos35 boscorebos41 boscorebos42 boscorebos43 boscorebos44 boscorebos45 boscorebos51 boscorebos52 boscorebos53 boscorebos54 boscorebos55
do
    cleos $URL  system newaccount --stake-net "10.0000 BOS" --stake-cpu "100.0000 BOS" --buy-ram "10.0000 BOS"  eosio $account   EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT;
    cleos $URL transfer eosio $account  "1000.0000 BOS";
    sleep 1;

done

#step 13 register bp
cleos $URL system regproducer boscorebos11 EOS6CnMhuP3SnLWmGNZyoJqKtzmNJcVG1whmFqjivt4GRT1pfgTwA http://boscore.io 9
cleos $URL system regproducer boscorebos12 EOS66jdoCC9oKy2N79bQPF4pH4XmeZLBEfxTP5gk7s1ykmSES4P3z http://boscore.io 9
cleos $URL system regproducer boscorebos13 EOS8kMTX3wZkDc8RZa7yPpR6xekJ6zbddXonCXwKHSyUXx8R2sgyW http://boscore.io 9
cleos $URL system regproducer boscorebos14 EOS8iyg3HRBjKgycfj6qhBM3b5amvFgTyeVJ2J466mhEvW2xVZ1G4 http://boscore.io 9
cleos $URL system regproducer boscorebos15 EOS7USzp2EEYkzHjKY6aSGT8DjmyHn4HH8EFHV83VCm19UifYtkEo http://boscore.io 9
cleos $URL system regproducer boscoretokyo EOS7B2h89KDYXzVNj6G8MLkFgQExfns1ssTH19MkDTPcFBTfssJb4 http://boscore.io 9

cleos $URL system regproducer boscorebos21 EOS85uiugd4Lm3kqLSqPkn9SDkS5TnoVQ52GoYNjynMe3mPfP1W13 http://boscore.io 9
cleos $URL system regproducer boscorebos22 EOS7auSc86orFFXy6cwoid2rUMKxz4A93vdq98kgTsjURv7zZYTHy http://boscore.io 9
cleos $URL system regproducer boscorebos23 EOS59kLykfQypkpsN6rBDyTw1Qk3eKFEmoQVz9gpWXPHigJpTVcZf http://boscore.io 9
cleos $URL system regproducer boscorebos24 EOS8HJaxMtuXYsakVRqZmA44Q4MhKsPnA36WrhGjZ5USK6MpdPnNu http://boscore.io 9
cleos $URL system regproducer boscorebos25 EOS8PPv8uMb8pmDKem6evTxPLQzcEwb9cCEgc2RniifVYqMdGob1i http://boscore.io 9

cleos $URL system regproducer boscorebos31 EOS8PPv8uMb8pmDKem6evTxPLQzcEwb9cCEgc2RniifVYqMdGob1i http://boscore.io 9
cleos $URL system regproducer boscorebos32 EOS5sXeVnbsGzxsEHZ78AsZ7qVRFCtvEACwyK9Hxkyp1sAGELJuu3 http://boscore.io 9
cleos $URL system regproducer boscorebos33 EOS6YyogWLx1p9mtx6eRDKNYfuohTsFxFvLF9s3xb9Pi45ixGjne6 http://boscore.io 9
cleos $URL system regproducer boscorebos34 EOS64Kkp4WgZWvZQe5XYFRr9jmN5ouSY3pb7QNECRBcUR5jf4qNeB http://boscore.io 9
cleos $URL system regproducer boscorebos35 EOS5yNiWcYqDE3hQx6Yq4yrqGkFYhjUww4eghzPtoWGzT4bzWS7kE http://boscore.io 9

cleos $URL system regproducer boscorebos41 EOS7JRvjPa4YVkmp2xd5fpteYxwiNUayiXHLcN5TCgrLx9h26UUwM http://boscore.io 9
cleos $URL system regproducer boscorebos42 EOS8mrjGWzVYxGhbsidWBk13mM645YQTgDzSVyrtcWcFsTzKamUvj http://boscore.io 9
cleos $URL system regproducer boscorebos43 EOS73RWuU7EdzQgzRQMLGnJNj61AesZcjvQvXG2WyFLDdxwb6Q34k http://boscore.io 9
cleos $URL system regproducer boscorebos44 EOS6umKh9gqoB2WE9D7tFQEj7AocjE4P6tCnLKUpKV9ZAAjTXesWT http://boscore.io 9
cleos $URL system regproducer boscorebos45 EOS6eXXu2zKBUGK25SBtvpeYQzjpZSj3akJaVcAhQLt5LYZxUqEdq http://boscore.io 9

cleos $URL system regproducer boscorebos51 EOS7Ts78DJ6DFLjfxkfqL1rERXSwyvae2UxtoLq3KUYqetbDFeEtn http://boscore.io 9
cleos $URL system regproducer boscorebos52 EOS8Jvr5d9zqRnu5GANUg59QhboHye7gCAfoxZmgNJ5Vm5J3vaBPo http://boscore.io 9
cleos $URL system regproducer boscorebos53 EOS6nhJLePKmLjjVaWMR42ukUb2kmZZHSsGx5E5itaS4T9pRyiNbX http://boscore#.io 9
cleos $URL system regproducer boscorebos54 EOS5m232ywxgDytiobedyLVw7EZ3tcTppVTyMZJqcu1mC52GpeDj4 http://boscore.io 9
cleos $URL system regproducer boscorebos55 EOS5AJf8RyAob36EYhTRmh9bSNCMSTQH8X9dHncEpCvGvEB6YYrkN http://boscore.io 9

#step 13 vote bp
cleos $URL system voteproducer prods voter boscorebos11 boscorebos12 boscorebos13 boscorebos14 boscoretokyo boscorebos15 boscorebos21 boscorebos22 boscorebos23 boscorebos24 boscorebos25 boscorebos31 boscorebos32 boscorebos33 boscorebos34 boscorebos35 boscorebos41 boscorebos42 boscorebos43 boscorebos44 boscorebos45 boscorebos51 boscorebos52 boscorebos53 boscorebos54 boscorebos55