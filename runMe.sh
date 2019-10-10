#!/bin/bash

#https://stackoverflow.com/questions/31328300/python-logging-module-logging-timestamp-to-include-microsecond/31335874

rm -vf logGenerator.log nBytes.txt fluent-bit_output.log foo.pdf nBytes_fb.txt fluent-bit_output.log

touch logGenerator.log
touch fluent-bit_output.log

python log_generator.py --logFile 'logGenerator.log' --iterations 10000000 & 
tail -f logGenerator.log | pv > /dev/null
# end=$((SECONDS+600))

# while [ $SECONDS -lt $end ]; do
#     # Do what you want.
#     # sleep 0.1

#     wc -l < logGenerator.log >> nBytes.txt
#     wc -l < fluent-bit_output.log >> nBytes_fb.txt
#     # echo HI
# done
# python plot_2.py
# evince foo.pdf
# # fg
