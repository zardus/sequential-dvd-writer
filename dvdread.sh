#!/bin/bash

D=$(dirname "$0")
cd $D/src
./dvdread $1
