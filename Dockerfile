FROM lambci/lambda:build-ruby2.7
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
