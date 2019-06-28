clbos='cleos -u http://127.0.0.1:2014'
cleos='cleos -u http://127.0.0.1:1014'

contracts_path='./ibc_contracts/'
# create two accounts named ibc2token555 and ibc2chain555 on both EOS and BOS
$clbos system newaccount --stake-net "10.0000 BOS" --stake-cpu "100.0000 BOS" --buy-ram "100.0000 BOS"   voter  ibc2token555 EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT
$clbos system newaccount --stake-net "10.0000 BOS" --stake-cpu "100.0000 BOS" --buy-ram "100.0000 BOS"   voter  ibc2chain555 EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT

$cleos system newaccount --stake-net "10.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS"   voter  ibc2token555 EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT
$cleos system newaccount --stake-net "10.0000 EOS" --stake-cpu "100.0000 EOS" --buy-ram "100.0000 EOS"   voter  ibc2chain555 EOS7rVBwUzNczTanG8t57apdbMVTbEHcbzTR6gbRpEKPL2Q9X8kWT


# set contracts to accounts
$clbos set contract ibc2token555 $contracts_path/ibc.token
$clbos set contract ibc2chain555 $contracts_path/ibc.chain

$cleos set contract ibc2token555 $contracts_path/ibc.token
$cleos set contract ibc2chain555 $contracts_path/ibc.chain






