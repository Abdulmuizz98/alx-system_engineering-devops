#!/usr/bin/python3
"""
    Contains a function recurse
"""


from requests import get


def recurse(subreddit, hot_list=[], after=None):
    """
    function that quries the Reddit API and returns all
    the titles of hot articles listed for a given
    subreddit.
    """
    header = {'User-Agent': 'my-app/0.0.1'}
    url = "https://www.reddit.com/r/{}/hot.json".format(subreddit)
    if after:
        url += "?after={}".format(after)

    req = get(url, headers=header)

    if req.status_code != 200 or req.url != url:
        return None

    hot_list += req.json().get('data').get('children')
    after = req.json().get('data').get('after')

    if after:
        return recurse(subreddit, hot_list, after)
    else:
        return hot_list
