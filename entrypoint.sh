#!/bin/bash
bundle config deployment true
bundle config without development
bundle install --jobs 8
zip -r packerwire.zip lambda_function.rb app vendor