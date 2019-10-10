#!/bin/bash


messages_number="10 100 1000 10000 100000 1000000 10000000"
./fluent-bit -c conf_fluent-bit.conf &
    PID=$!
# 10000000
for number in `echo $messages_number`; do
	#statements
    
    # number=100000
    # echo $number

    rm -f log flog
    touch log flog 
    # sleep 10
    # python log_generator.py --logFile 'log' --iterations 1000 --minSleepMs .0000001 &
    cp logs/$number ./log
    # t=$[$(date +%s%N)/1000000]
    # echo $t

    end=$((SECONDS+1000))
    onceFlag=1
    while [ $SECONDS -lt $end ]; do
        # Do what you want.
        # sleep 0.01

        l=`wc -l < flog`
        t="$(date -u +%s.%N)"

        if [[ $l -gt 0 ]]; then
            #statements
            if [[ $onceFlag -eq 1 ]]; then
                #statements
                onceFlag=0
                start_time=$t
                # echo "starttime=$start_time"
            fi
            
            # t=$[$(date +%s%N)/1000000]
            # echo "$t  $l"
        fi
        if [[ $l -eq $number ]]; then
            #statements
            end_time=$t
            # echo "starttime=$end_time"
            elapsed="$(bc <<< "$end_time-$start_time")"
            # echo "elapsed time=$elapsed"
            # elapsed=`awk "BEGIN {print $end_time-$start_time}"`
            size=`awk "BEGIN {print ($l*111)/1000000}"`
            echo "$size $elapsed"
            break
        fi
        # echo HI
    done
    
done
kill -2 $PID

# start_time="$(date -u +%s.%N)"
# sleep .1
# end_time="$(date -u +%s.%N)"



# rm -vf logGenerator.log fluent-bit_output.log
# touch fluent-bit_output.log
# sleep 10s
# python log_generator.py --logFile 'logGenerator.log' --maxSleepMs 0.001 --iterations 10000 --minSleepMs 0.001 &
# wc -l < logGenerator.log
# sleep 100s
# wc -l < fluent-bit_output.log
# rm -vf logGenerator.log fluent-bit_output.log
# touch fluent-bit_output.log
# cp logs/logGenerator_1000.log ./logGenerator.log
# sleep 20s
# wc -l < fluent-bit_output.log
# rm -vf logGenerator.log fluent-bit_output.log

# for i in words; do
# 	#statements
# done
