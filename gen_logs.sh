#!/bin/bash

messages_number="10 100 1000 10000 100000 1000000 10000000"
for i in `echo $messages_number`; do
	name=`echo logs/log_`echo $i``
	python log_generator.py --logFile '$name' --iterations $i
	echo "$i done"
	#statements
done