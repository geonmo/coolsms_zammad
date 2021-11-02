#!/bin/bash

a='{
  "name": "coolsms",
  "version": "1.0.0",
  "vendor": "coolsms",
  "license": "MIT",
  "url": "https://coolsms.co.kr/",
  "buildhost": "localhost",
  "builddate": "2020-18-03 00:00:00 UTC",
  "change_log": [
    {
      "version": "1.0.0",
      "date": "2020-18-03 00:00:00 UTC",
      "log": "init"
    }
  ],
  "description": [
    {
      "language": "en",
      "text": "Add coolsms SMS Gateway"
    }
  ],
  "files": [
    {
      "location": "app/models/channel/driver/sms/coolsms.rb",
      "permission": 644,
      "encode": "base64",
      "content": "CHANGEIT"
    },
  ]
}
'

echo "$a" > coolsms.szpm

content=$(cat coolsms.rb | base64)
sed -i "s/CHANGEIT/${content}/g" coolsms.szpm
