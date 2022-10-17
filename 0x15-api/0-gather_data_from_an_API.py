#!/usr/bin/python3
''' A Python script that, using the JSONPlaceholder  REST API,
for a given employee ID, returns information about his/her
TODO list progress. '''
import requests
import sys


API_URL = "https://jsonplaceholder.typicode.com"
"""REST API url"""


if __name__ == "__main__":

    user_endpoint = f"{API_URL}/users/{sys.argv[1]}/"
    todo_endpoint = user_endpoint + "todos"

    req_user = requests.get(user_endpoint).json()  # dict
    req_todos = requests.get(todo_endpoint).json()  # list

    done = [todo for todo in req_todos if todo.get("completed")]

    print("Employee {} is done with tasks({}/{})".format(
        req_user.get('name'), len(done), len(req_todos)))

    [print(f"\t{todo.get('title')}") for todo in done]
