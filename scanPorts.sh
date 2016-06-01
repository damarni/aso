#!/bin/bash

echo `nmap $1 -p $2 --open | awk '/is up/ {print up}; {gsub (/\(|\)/,""); up = $NF}'`;
