#!/bin/sh
# tcpcoord.sh

scenarios="ref small medium"
sizes="100K 2M 10M 100M"
testruns=20

server=10.0.1.2
router="137.50.19.33"

rm *.time
rm *.rtt

set -e

echo "doing $testruns runs of $sizes to $scenarios" 
sleep 5

experiment=tcp
timecmd='/usr/bin/time -f "real %%e user %%U sys %%S"'

prefix=$experiment-`uname`-`hostname`
#echo $timecmd -a -o test.time sleep 1
#$timecmd -a -o test.time sleep 1
#exit


configbottleneck ()
{
        ssh $router sudo sh /root//configbottleneck.sh $1
}

for scenario in $scenarios
do
        configbottleneck $scenario

        for size in $sizes
        do
                testname=$prefix-$scenario-$size
                testfile=$testname.time

                cmd="iperf3 -c 10.0.1.2 -n ${size}  -w 1.77M --cport 30000"

                echo $testname  $testfile
                echo $testname > $testfile
                for x in `jot $testruns`
                do
			ping $server > $testname-$x.rtt &
			pingpid=$!
			
                        echo /usr/bin/time -a -o $testfile $cmd
                        #$timecmd -a -o $testfile $cmd
			/usr/bin/time -f "%e real %U user %S sys" -a -o $testfile $cmd
			/bin/kill -SIGINT $pingpid
                done
        done
done

