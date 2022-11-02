#!/usr/bin/python3
"""
    Contains a function that quries the Reddit API and prints
    the titles of the first 10 hot posts listed for a given
    subreddit.
"""


from requests import get


def top_ten(subreddit):
    """
    function that quries the Reddit API and prints
    the titles of the first 10 hot posts listed for a given
    subreddit.
    """
    header = {'User-Agent': 'my-app/0.0.1'}
    url = "https://www.reddit.com/r/{}/hot.json".format(subreddit)
    req = get(url, headers=header)

    if req.status_code == 200 and req.url == url:
        dic = req.json().get('data').get('children')[:10]
        for item in dic:
            print(item.get('data').get('title'))
    else:
        print(None)
