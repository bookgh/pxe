#!/bin/bash

docker build -t pxe:1.0 .

docker-compose up -d
