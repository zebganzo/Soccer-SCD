#!/bin/sh

echo "Starting core.."
./obj/soccer-main

echo "Starting field client.."
java -jar ../GUISoccerField/
