#!/usr/bin/env python3

import requests
import json
import pickle
from collections import Counter


def get_contests():
    r = requests.get('https://codeforces.com/api/user.rating?handle=SuperJ6')
    json = r.json()

    contests = []

    for contest in json['result']:
        contests.append(contest['contestId'])

    return contests

def get_participants(contests):
    participants = []

    for contest in contests:
        print('Working on ' + str(contest))
        r = requests.get('https://codeforces.com/api/contest.ratingChanges?contestId=' + str(contest))
        json = r.json()

        for participant in json['result']:
            if participant['handle'] not in participants:
                participants.append(participant['handle'])

    return participants

def get_n_contests(contests):
    r = requests.get('https://codeforces.com/api/contest.list')
    json = r.json()

    min_contest = min(contests)
    n_contests = []

    for n_contest in json['result']:
        if (n_contest['id'] >= min_contest and n_contest['id'] not in contests):
            n_contests.append(n_contest['id'])

    return n_contests

def get_n_participants(participants, n_contests):
    n_participants = Counter()

    for n_contest in n_contests:
        print('Working on ' + str(n_contest))

        try:
            r = requests.get('https://codeforces.com/api/contest.ratingChanges?contestId=' + str(n_contest))
            json = r.json()
            
            for n_participant in json['result']:
                if (n_participant['handle'] not in participants):
                    n_participants[n_participant['handle']] += 1

        except:
            print('Skipping ' + str(n_contest))
            continue

    return n_participants

try:
    with open('contests', 'rb') as f:
        contests = pickle.load(f)
    print('Found contest file')
except:
    print('Did not find contest file. Creating one')
    contests = get_contests()
    with open('contests', 'wb') as f:
        pickle.dump(contests, f)

try:
    with open('participants', 'rb') as f:
        participants = pickle.load(f)
    print('Found participants file')
except:
    print('Did not find participants file. Creating one')
    participants = get_participants(contests)
    with open('participants', 'wb') as f:
        pickle.dump(participants, f)

try:
    with open('n_contests', 'rb') as f:
        n_contests = pickle.load(f)
    print('Found not contest file')
except:
    print('Did not find not contest file. Creating one')
    n_contests = get_n_contests(contests)
    with open('n_contests', 'wb') as f:
        pickle.dump(n_contests, f)

try:
    with open('n_participants', 'rb') as f:
        n_participants = pickle.load(f)
    print('Found non participants file')
except:
    print('Did not find non participants file. Creating one')
    n_participants = get_n_participants(participants, n_contests)
    with open('n_participants', 'wb') as f:
        pickle.dump(n_participants, f)

print(n_participants.most_common(10))
