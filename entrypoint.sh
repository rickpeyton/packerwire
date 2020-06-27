#!/bin/bash
bundle config set deployment 'true'
bundle install --jobs 8
zip -r packerwire.zip lambda_function.rb app vendor