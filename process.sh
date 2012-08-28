#!/bin/bash
 for filename in *.mov ; do 
	fname=${filename// /_} #replace space with underline
	fname="${filename%%.*}" #remove filename extension
	ffmpeg -i ${filename} -s 640x480 -b 128k -r 30 -qmax 5 out/${fname}.mp4 
	ffmpeg -i ${filename} -r 1 -vframes 1 -s 136x102 out/${fname}-%d.jpg
done
