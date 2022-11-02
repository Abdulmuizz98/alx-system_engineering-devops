#!/usr/bin/python3
"""
    Scipt that requests the reddit api that finds the number
    of subs of a subreddit
"""


from requests import get


def number_of_subscribers(subreddit):
    """request the reddit api that finds the number
        of subs of a subreddit.
    """
    header = {'User-Agent': 'my-app/0.0.1'}
    req = get("https://www.reddit.com/r/{}/about.json".format(subreddit),
              headers=header)

    if req.json().get('kind') == 'Listing' or req.status_code != 200:
        return (0)
    else:
        return (req.json().get('data').get('subscribers'))
