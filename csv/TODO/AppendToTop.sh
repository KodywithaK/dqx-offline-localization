#!/bin/bash

DIR=`dirname ${BASH_SOURCE[0]}`
for f in $DIR/*.txt $DIR/**/*.txt $DIR/**/**/*.txt $DIR/**/**/**/*.txt $DIR/**/**/**/**/*.txt; do
	echo -e "Processing $f...\n";
	echo -e "Key, SourceString\n$(cat $f)" > $f;
done