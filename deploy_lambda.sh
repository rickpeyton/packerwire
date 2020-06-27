#!/bin/bash

zip -r packerwire.zip ./
aws s3 cp packerwire.zip s3://lambda-zips.peyton.dev/packerwire.zip
aws lambda update-function-code \
  --function-name packerwire \
  --s3-bucket lambda-zips.peyton.dev \
  --s3-key packerwire.zip \
  --region us-east-1 \
  --publish