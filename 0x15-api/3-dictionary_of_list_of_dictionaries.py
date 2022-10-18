#!/usr/bin/python3
"""
Using https://jsonplaceholder.typicode.com
returns info about employee TODO progress
Implemented using recursion
"""
import json
import re
import requests
import sys


API = "https://jsonplaceholder.typicode.com"
"""REST API url"""


if __name__ == '__main__':
    users_res = requests.get('{}/users/'.format(API)).json()
    todos_res = requests.get('{}/todos'.format(API)).json()
    dic = {}

    for id in range(0, len(users_res)):
        todos = list(filter(lambda x: x.get('userId') == id+1, todos_res))
        user_name = users_res[id].get('username')

        for item in todos:
            item["task"] = item["title"]
            del item["title"]
            del item["userId"]
            del item["id"]
            item["username"] = user_name

        dic[id+1] = todos

    res_json = json.dumps(dic)

    with open("todo_all_employees.json", 'w', encoding='utf-8') as f:
        f.write(res_json)
