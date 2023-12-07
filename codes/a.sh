#!/bin/bash
#-----------------------------------------
# process A: lock the file and subtract 20 
# from the current balance
#-----------------------------------------
flock --verbose balance.dat ./update_balance.sh '-20'
