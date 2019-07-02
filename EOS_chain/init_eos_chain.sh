#cleos wallet import --private-key <private-key>

# step 4: set contract eosio.bios
URL='-u http://127.0.0.1:1014'
CONTRACTS_FOLDER='./eosio.contracts' 
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
cleos  $URL create account eosio eos.abp EOS6iZv7nA8zgBtKaxnXLZ3ME7EvpiGSjg4iBZmR1eNhjqNirBrhC
cleos $URL push action eosio setprods '{"schedule":[{"producer_name":"boscoretokyo","block_signing_key":"EOS6iZv7nA8zgBtKaxnXLZ3ME7EvpiGSjg4iBZmR1eNhjqNirBrhC"}]}' -p eosio

# step 6: set token and msig contract
cleos $URL set contract eosio.token ${CONTRACTS_FOLDER}/eosio.token -p eosio.token 
cleos $URL set contract eosio.msig ${CONTRACTS_FOLDER}/eosio.msig -p eosio.msig

# step 7: create and issue token

cleos $URL push action eosio.token create '["eosio", "10000000000.0000 EOS"]' -p eosio.token 
cleos $URL push action eosio.token issue '["eosio", "1013000000.0000 EOS", "EOS"]' -p eosio


# setp 8: setting privileged account for eosio.msig

cleos $URL push action eosio setpriv '{"account": "eosio.msig", "is_priv": 1}' -p eosio

# step 9: set contract eosio.system

cleos $URL set contract eosio ${CONTRACTS_FOLDER}/eosio.system -x 1000 -p eosio

cleos $URL push action eosio init '{"version": 0, "core": "4,EOS"}' -p eosio

# step 10: set contract eosio.wrap

cleos $URL set contract eosio.wrap ${CONTRACTS_FOLDER}/eosio.wrap -x 1000 -p eosio.wrap

# step 11: transfer some token 

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
cleos $URL  system newaccount --stake-net "10.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "10.0000 EOS"  eosio voter  EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT
cleos $URL transfer eosio voter "300000000.0000 EOS"
cleos $URL system delegatebw voter voter "100000000.0000 EOS" "100000000.0000 EOS"


for account in eoscoretesta eoscoretestb eoscoretestc eoscoretestd eoscoreteste eoscoretestf eoscoretestg eoscoretesth eoscoretesti eoscoretestj eoscoretestk eoscoretestl eoscoretestm eoscoretestn eoscoretesto eoscoretestp eoscoretestq eoscoretestr eoscoretests eoscoretestt eoscoretestu eoscoretestv eoscoretestw eoscoretestx eoscoretesty eoscoretestz
do
    cleos $URL  system newaccount --stake-net "10.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "10.0000 EOS"  eosio $account   EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT;
    cleos $URL transfer eosio $account  "1000.0000 EOS";
    sleep 1;

done


#step 13 register bp
cleos $URL system regproducer eoscoretesta EOS6wz6yXv7Ft3ySkhD2RJwEupijTQTW22QRfm8rY74cBGLM2rYg2 http://boscore.io 9
cleos $URL system regproducer eoscoretestb EOS6wj6wgCXusy1JzYHFQxTktbvGbx622NbRVLZtHuW2YDozzAtnz http://boscore.io 9
cleos $URL system regproducer eoscoretestc EOS6WWL3H3j3xQfivaD9uRhCJjZSBgEp59yZeH4XV8dCv8DvykDyt http://boscore.io 9
cleos $URL system regproducer eoscoretestd EOS6FmvragMCP4D1f42gKoMoZMPpoX9HRaPDUzFXSSdonT62LFavK http://boscore.io 9
cleos $URL system regproducer eoscoreteste EOS7ryjbQ4w8GGbxAwQXPoApbAD6VJJrAANygJCmRD76hEqcdG9mY http://boscore.io 9

cleos $URL system regproducer eoscoretestf EOS79kNsGB1zoYx4qPL4aYSZHNj4RL33owDjfdPfWJCXs9jnMNAT3 http://boscore.io 9
cleos $URL system regproducer eoscoretestg EOS6u2pDGYRxvFrdr8dqNbkt7kgLYrxePgYteCLEwjyLDsHLD4Wr3 http://boscore.io 9
cleos $URL system regproducer eoscoretesth EOS7gUn4Ex8WuD3wqTLya3fV2rVYgd1Qhxf6Hq57GJ6W5FM15QeJ8 http://boscore.io 9
cleos $URL system regproducer eoscoretesti EOS6CpYfBquMxfnABDSFYE3UwBxMkb26g97c2A6jtuWN2YDVdJpuS http://boscore.io 9
cleos $URL system regproducer eoscoretestj EOS8ZLxwLwJGbFXdNhG22Bze85EpoC5KiuUs9MvrCdppJ9VwqAagx http://boscore.io 9

cleos $URL system regproducer eoscoretestk EOS643g6cMbE42jQd4FMdGdDAnrBiSaqCB27a5xx35Af3HT8EQpyq http://boscore.io 9
cleos $URL system regproducer eoscoretestl EOS5pow56WvxvAxM7gRftTWotkRkL3PxesBC1656uBsFPMfASwM6r http://boscore.io 9
cleos $URL system regproducer eoscoretestm EOS6Z3cydNXp76PSgGYhFaDYa6yWwcQgZUhXRgZQonZRrbQ7tBWy9 http://boscore.io 9
cleos $URL system regproducer eoscoretestn EOS5SYbQbUFWL4i7w4PsvxuobfREea4Pz7uUf7F3KhBmT2sFAURyS http://boscore.io 9
cleos $URL system regproducer eoscoretesto EOS54pnZAmjvBBQVtC8bLhK1idFbvtQUrtkkbGVT8jKo8yG8yJSKP http://boscore.io 9

cleos $URL system regproducer eoscoretestp EOS8acudXJNB3ntruHUyzJcHsty9u7U3NdMXv3U8ncTirsPUo1Yxt http://boscore.io 9
cleos $URL system regproducer eoscoretestq EOS73RWuU7EdzQgzRQMLGnJNj61AesZcjvQvXG2WyFLDdxwb6Q34k http://boscore.io 9
cleos $URL system regproducer eoscoretestr EOS4xNZftGgAYetLGWjrJ5XgcRziC9DbXufXhKzauXm5TZLj83jDb http://boscore.io 9
cleos $URL system regproducer eoscoretests EOS7TYQGBoisnBPXMhs3hsv2ZQkaBgQhEGKJoxfrBTBsoGeYhNJUa http://boscore.io 9
cleos $URL system regproducer eoscoretestt EOS7VDWUSu523GEsn8GXGCHY2H1uUyBY6GovCdDMpWBGg4Ea1cQSx http://boscore.io 9

cleos $URL system regproducer eoscoretestu EOS6djwRdWXUgdh4W4KKyzdBJpYwKVqLuH8jDjfzwHy2x9i9cjVC3 http://boscore.io 9
cleos $URL system regproducer eoscoretestv EOS8fcwivZYLmTAx7agmML8KrBraQ9hB5D2GbdF9SjuD5Zq1q2d4y http://boscore.io 9
cleos $URL system regproducer eoscoretestw EOS7XAXY1Wkc7iXDvzhSw8y4zMNeFn6M7ZudeveVD1foSqWwnujPY http://boscore#.io 9
#cleos $URL system regproducer eoscoreeos54 EOS5m232ywxgDytiobedyLVw7EZ3tcTppVTyMZJqcu1mC52GpeDj4 http://boscore.io 9
#cleos $URL system regproducer eoscoreeos55 EOS5AJf8RyAob36EYhTRmh9bSNCMSTQH8X9dHncEpCvGvEB6YYrkN http://boscore.io 9

#step 13 vote bp
cleos $URL system voteproducer prods voter eoscoretesta eoscoretestb eoscoretestc eoscoretestd eoscoreteste eoscoretestf eoscoretestg eoscoretesth eoscoretesti eoscoretestj eoscoretestk eoscoretestl eoscoretestm eoscoretestn eoscoretesto eoscoretestp eoscoretestq eoscoretestr eoscoretests eoscoretestt eoscoretestu eoscoretestv eoscoretestw