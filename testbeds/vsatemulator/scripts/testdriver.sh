#!/bin/sh

testprefix=test-$1

testtool=./cli
#assets="blob10k blob15k blob30k blob1m"
assets="blob1m"

serverhost=localhost
serverport=4433

serverhost=137.50.17.168
serverport=4433

if [ ! -r server.crt ] || [ ! -r server.key ]; then
	openssl req \
		-x509 \
		-sha256 \
		-nodes \
		-days 365 \
		-newkey rsa:2048 \
		-keyout server.key \
		-out server.crt \
		-subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=www.example.com"
fi

$testtool -c server.crt -k server.key 0.0.0.0 4433 & 
serverpid=$!
echo server pid $serverpid

set $assets
for asset do # looping over the  elements of the $@ array ($1, $2...)
	$testtool -v \
		-p "/$asset.txt" \
		-e $testprefix-$asset-`date +%Y%m%d%H%M`.json \
		$serverhost $serverport
	echo test $asset finished, returned $?
done

echo stopping server, pid $serverpid

kill $serverpid

running=`ps aux | grep "/cli " | wc -l`
if [ 1 != $running ]; then
	echo server might still be running
fi
