#!/bin/sh
/bin/rm -rf ebs-backup-lambda.zip
sleep 2s
/usr/bin/zip ebs-backup-lambda.zip *.py
