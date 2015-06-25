#!/bin/bash

COUNTER=0
while [  $COUNTER -lt 100 ]; do
	echo $COUNTER
	let COUNTER=COUNTER+1 
done