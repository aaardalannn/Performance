#!/usr/bin/env python

#################################
# log-generator
#
# - small python script to generate random time series data into files
# - https://github.com/bitsofinfo/log-generator
# - uses GMT time
#
#################################

import logging
import getopt
import sys
import time
import random
import os
import matplotlib.pyplot as plt
import datetime
import numpy as np



def main(argv):
    usageInfo = '\nUSAGE:\n\nlogGenerator.py --logFile <targetFile>\n\t[--minSleepMs <int>] [--maxSleepMs <int>] \n\t[--sourceDataFile <fileWithTextData>] [--iterations <long>]\n\t[--minLines <int>] [--maxLines <int>] \n\t[--logPattern <pattern>] [--datePattern <pattern>]'

    iterations = -1 # infinate
    minSleep = 0.0001
    maxSleep = 0.0001
    minLines = 1
    maxLines = 1
    logFile = 'logGenerator.log'
    sourceDataFile = 'defaultDataFile.txt'
    sourceData = ''
    logPattern = '%(asctime)s,%(msecs)d %(process)d %(filename)s %(lineno)d %(name)s %(levelname)s %(message)s'
    datePattern = "%Y-%m-%d %H:%M:%S"

    if len(argv) == 0:
        print(usageInfo)
        sys.exit(2)

    try:
        opts, args = getopt.getopt(argv,"h",["help","logFile=","minSleepMs=","maxSleepMs=","iterations=","sourceDataFile=","minLines=","maxLines="])
    except:
        print(usageInfo)
        sys.exit(2)


    for opt, arg in opts:

        if opt in ('-h' , "--help"):
            print(usageInfo)
            sys.exit()

        elif opt in ("--logFile"):
            logFile = arg

        elif opt in ("--minSleepMs"):
            minSleep = (0.001 * float(arg))

        elif opt in ("--maxSleepMs"):
            maxSleep = (0.001 * float(arg))

        elif opt in ("--maxLines"):
            maxLines = int(arg)

        elif opt in ("--minLines"):
            minLines = int(arg)

        elif opt in ("--sourceDataFile"):
            sourceDataFile = arg

        elif opt in ("--iterations"):
            iterations = int(arg)

        elif opt in ("--logPattern"):
            logPattern = arg

        elif opt in ("--datePattern"):
            datePattern = arg

    #check if sourcefile exists
    if os.path.exists(sourceDataFile):
        pass
    else:
        print("Please check if file " + sourceDataFile + " exists")
        sys.exit()

    # bring in source data
    with open (sourceDataFile, "r") as fh:
        sourceData=fh.read()
    sourceData = sourceData.splitlines(True)
    totalLines = len(sourceData)-1

    if (maxLines > totalLines):
        maxLines = totalLines

    print("")
    print("########################################")
    print("### log-generator running variables: ###")
    print("########################################")
    print("# ")
    print("# sourceDataFile:   | " + sourceDataFile)
    print("# sourceData lines: | " + str(totalLines))
    print("# ")
    print("# minSleep:         | " + str(minSleep))
    print("# maxSleep:         | " + str(maxSleep))
    print("# minLines:         | " + str(minLines))
    print("# maxLines:         | " + str(maxLines))
    print("# ")
    print("# logFile:          | " + logFile)
    print("# logPattern:       | " + logPattern)
    print("# datePattern:      | " + datePattern)
    print("########################################")
    print("")

    # setup logging
    logging.Formatter.converter = time.localtime
    logger = logging.getLogger("log-generator")
    logger.setLevel(logging.DEBUG)
    fileHandler = logging.FileHandler(logFile)
    fileHandler.setLevel(logging.DEBUG)
    formatter = logging.Formatter(logPattern,datePattern)
    fileHandler.setFormatter(formatter)
    logger.addHandler(fileHandler)


    X = np.zeros(iterations)
    Y = np.zeros(iterations)
    Y2 = np.zeros(iterations)
    # print(X)

    # plt.show()

    mustIterate = True
    i=0
    while (mustIterate):

        # sleep
        # time.sleep(random.uniform(minSleep, maxSleep))

        # get random data
        lineToStart = random.randint(0,totalLines)
        linesToGet = random.randint(minLines, maxLines)

        lastLineToGet = (lineToStart + linesToGet)

        if (lastLineToGet > totalLines):
            lastLineToGet = totalLines

        toLog = ''.join(sourceData[lineToStart:lastLineToGet])

        if (toLog.startswith('\n')):
            toLog = toLog[1:]

        if (toLog == ''):
            continue
        logger.debug(toLog[:-1])
        #print(toLog[:-1])

        # currentDT = datetime.datetime.now()
        # print (str(currentDT))

        myCmd = 'wc -c < logGenerator.log'
        myCmd2 = 'wc -c < fluent-bit_output.log'
        
        # os.system(myCmd)


        out = os.popen(myCmd).read()
        out2 = os.popen(myCmd2).read()
        Y[i] = float(out)
        Y2[i] = float(out)
        X[i] = i+1
        i=i+1



        if (iterations > 0):
            iterations = iterations - 1
            if (iterations == 0):
                mustIterate = False

    plt.loglog(X,Y,'b-',X,Y2,'r--')
    plt.savefig('foo.pdf')
    sys.exit(0)

if __name__ == "__main__":
   main(sys.argv[1:])
