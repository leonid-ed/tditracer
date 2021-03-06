#!/bin/sh

kill -9 $(pidof simserver)
kill -9 $(pidof sleeper)

loops=100

proc()
{

LD_PRELOAD=libtdim.so TRACEBUFFERSIZE=1 REMOVE=0 SELFINFO=5 ./simserver$1 /tmp/s$1 &
sleep 1

local fcounter=1
while [ $fcounter -le `expr $4` ]
do

echo "mmap $2"                              | ./simclient /tmp/s$1
echo "code rev/libcode$1.so f$fcounter $loops $3"  | ./simclient /tmp/s$1

fcounter=`expr $fcounter + 1`
done
}

code()
{
echo "code rev/libcode$1.so f$2 $3 $4"  | ./simclient /tmp/s$1
}

memset()
{
echo "memset $2" | ./simclient /tmp/s$1
}

mark()
{
echo "mark" | ./simclient /tmp/s1
}


###############################################################################

LD_PRELOAD=libtdim.so DISKS=sdc2,sdc1 NETS=enp0s3 TRACEBUFFERSIZE=1 SYSINFO=5 ./sleeper & 
sleep 1

proc 1 8M 1024 4
proc 2 8M 1024 4
proc 3 8M 1024 4

mark

counter=1
while [ $counter -le `expr 10` ]
do

code 1 1 $loops 1024
code 1 2 $loops 1024
code 1 3 $loops 1024
code 1 4 $loops 1024

code 2 1 $loops 1024
code 2 2 $loops 1024
code 2 3 $loops 1024
code 2 4 $loops 1024

code 3 1 $loops 1024
code 3 2 $loops 1024
code 3 3 $loops 1024
code 3 4 $loops 1024

mark

counter=`expr $counter + 1`
done

mark

proc 4 24M 2048 4

mark

counter=1
while [ $counter -le `expr 10` ]
do

code 1 1 $loops 1024
code 1 2 $loops 1024
code 1 3 $loops 1024
code 1 4 $loops 1024

code 2 1 $loops 1024
code 2 2 $loops 1024
code 2 3 $loops 1024
code 2 4 $loops 1024

code 3 1 $loops 1024
code 3 2 $loops 1024
code 3 3 $loops 1024
code 3 4 $loops 1024

code 4 1 $loops 1024
code 4 2 $loops 1024
code 4 3 $loops 1024
code 4 4 $loops 1024

mark

counter=`expr $counter + 1`
done

mark

sleep 2

memset 1 0
memset 1 1
memset 1 2
memset 1 3

memset 2 0
memset 2 1
memset 2 2
memset 2 3

memset 3 0
memset 3 1
memset 3 2
memset 3 3

memset 4 0
memset 4 1
memset 4 2
memset 4 3

sleep 2

mark

counter=1
while [ $counter -le `expr 10` ]
do

code 1 1 $loops 1024
code 1 2 $loops 1024
code 1 3 $loops 1024
code 1 4 $loops 1024

code 2 1 $loops 1024
code 2 2 $loops 1024
code 2 3 $loops 1024
code 2 4 $loops 1024

code 3 1 $loops 1024
code 3 2 $loops 1024
code 3 3 $loops 1024
code 3 4 $loops 1024

code 4 1 $loops 1024
code 4 2 $loops 1024
code 4 3 $loops 1024
code 4 4 $loops 1024

mark

counter=`expr $counter + 1`
done

mark

sleep 3

tdim -d > /nfs/1.tdi
