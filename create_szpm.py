#!/usr/bin/env python3

import json,base64
import datetime

info = {"name":"coolsmsnoti",
        "version":"1.0.0",
        "vendor":"GSDC",
        "license": "MIT",
        "url":"https://coolsms.co.kr",
        "buildhost":"localhost",
        "builddate":"2021-03-11 00:00:00 UTC",
        "change_log":[],
        "description":{ "language":"en","text":"Add coolsms SMS gateway to zammad"},
        "files":[
            {
                "location": "app/models/channel/driver/sms/coolsmsnoti.rb",
                "permission": 644,
                "encode":"base64",
                "content":None
            }]
}

info["builddate"]= datetime.datetime.now().isoformat()

with open('coolsmsnoti.rb','rb') as f:
    data = f.read()
    base64en = base64.b64encode(data)
    base64_message = base64en.decode('utf-8')
    info["files"][0]["content"] = base64_message



with open('coolsmsnoti.szpm','w') as fp:
  json.dump(info,fp,indent=4)





