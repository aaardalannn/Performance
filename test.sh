#!/bin/bash
# start_time="$(date -u +%s.%N)"
# sleep .1
# end_time="$(date -u +%s.%N)"

# elapsed="$(bc <<< "$end_time-$start_time")"
# echo "Total of $elapsed seconds elapsed for process"

# l=1000
# b=`echo "$l*2" | bc`
# echo $b

# l=10
# a=`awk "BEGIN {print ($l*111)/1000000}"`
# echo $a

messages_number="10 1 0.1 0.01 0.001 0.0001 0.00001 0.000001 0.0000001 0.00000001 0.000000001"
for number in $(echo $messages_number); do
    for (( i = 0; i < 10; i++ )); do
    #statements

    # number=10
    rm -f log flog
    touch log flog
    sleep 1
    python log_generator.py --logFile 'log' --minSleepMs $number &
    ./fluent-bit -c conf_fluent-bit.conf &

    while true; do
        #statements
        # echo "hi"
        l=$(wc -l <flog)

        if [ $l -gt 1 ]; then
            # echo $l
            break
        fi
    done

    sleep 5
    l1=$(wc -l <flog)
    l11=$(wc -l <log)
    end=$((SECONDS + 1))
    sleep 10
    l2=$(wc -l <flog)
    l21=$(wc -l <log)
    # echo "$l1,$l2"
    MBpS=$(awk "BEGIN {print (($l2-$l1)*111/10)}")
    # echo $MBpS
    rate=$(awk "BEGIN {print (($l21-$l11)/10)}")
    echo "$rate $MBpS"
    killall -s 2 fluent-bit
    killall -s 15 fluent-bit
    killall -s 15 python
    killall -s 2 python
    done
done
