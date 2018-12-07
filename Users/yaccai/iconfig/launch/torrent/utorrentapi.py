#!/usr/local/bin/python3
# -*- coding:utf-8 -*- 

import requests
import base64
import json
from lxml import html

# import utorrentapi
# app = utorrentapi.UTorrentAPI('http://127.0.0.1:61130/gui', 'admin', 'admin')
# torrents = app.get_list_my().decode('utf-8')
# torrents = json.loads(torrents).get('torrents')


class UTorrentAPI(object):

    def __init__(self, base_url, username, password):
        self.base_url = base_url
        self.username = username
        self.password = password
        self.auth     = requests.auth.HTTPBasicAuth(self.username, self.password)
        self.token, self.cookies  = self._get_token()

    def _get_token(self):
        url = self.base_url + '/token.html'

        token    = -1
        cookies  = -1

        try:
            response = requests.get(url, auth=self.auth)

            token = -1

            if response.status_code == 200:
                xtree = html.fromstring(response.content.decode('utf-8'))
                token = xtree.xpath('//*[@id="token"]/text()')[0]
                guid  = response.cookies['GUID']
            else:
                token = -1

            cookies = dict(GUID = guid)

        except requests.ConnectionError as error:
            token = 0
            cookies = 0
            print(error)
        except:
            print('error')

        return token, cookies

    def is_online(self):
        if self.token != -1 and self.token != 0:
            return True
        else:
            return False

# public sectin -->
    def get_list(self):
        torrents = []
        try:
            status, response = self._action('list=1')
            if status == 200:
                # print(response.content)
                torrents = response.json()
            else:
                print(response.status_code)

        except requests.ConnectionError as error:
            print(error)
        except:
            print('error')

        return torrents

    def get_list_my(self):
        torrents = []
        try:
            status, response = self._action('list=1')
            if status == 200:
                # print(response.content)
                torrents = response.content
            else:
                print(response.status_code)

        except requests.ConnectionError as error:
            print(error)
        except:
            print('error')

        return torrents


    def get_files(self, torrentHash):
        path = 'action=getfiles&hash=%s' % (torrentHash)
        status, response = self._action(path)

        files = []

        if status == 200:
            files = response.json()
        else:
            print(response.status_code)

        return files

    def start(self, torrentHash):
        return self._torrentaction('start', torrentHash)

    def stop(self, torrentHash):
        return self._torrentaction('stop', torrentHash)

    def pause(self, torrentHash):
        return self._torrentaction('pause', torrentHash)

    def forcestart(self, torrentHash):
        return self._torrentaction('forcestart', torrentHash)

    def unpause(self, torrentHash):
        return self._torrentaction('unpause', torrentHash)

    def recheck(self, torrentHash):
        return self._torrentaction('recheck', torrentHash)

    def remove(self, torrentHash):
        return self._torrentaction('remove', torrentHash)

    def removedata(self, torrentHash):
        return self._torrentaction('removedata', torrentHash)

    def recheck(self, torrentHash):
        return self._torrentaction('recheck', torrentHash)

    def set_priority(self, torrentHash, fileindex, priority):
        # 0 = Don't Download
        # 1 = Low Priority
        # 2 = Normal Priority
        # 3 = High Priority
        path = 'action=%s&hash=%s&p=%s&f=%s' % ('setprio', torrentHash, priority, fileindex)
        status, response = self._action(path)

        files = []

        if status == 200:
            files = response.json()
        else:
            print(response.status_code)

        return files

    def add_file(self, file_path):

        file = []

        url = '%s/?%s&token=%s' % (self.base_url, 'action=add-file', self.token)
        headers = {
        'Content-Type': "multipart/form-data"
        }

        files = {'torrent_file': open(file_path, 'rb')}

        try:
            if files:
                response = requests.post(url, files=files, auth=self.auth, cookies=self.cookies)
                if response.status_code == 200:
                    file = response.json()
                    print('file added')
                else:
                    print(response.status_code)
            else:
                print('file not found')

            pass
        except requests.ConnectionError as error:
            print(error)
        except Exception as e:
            print(e)

        return file

    def add_url(self, fiel_path):
        path = 'action=add-url&s=%s' % (fiel_path)
        status, response = self._action(path)

        files = []

        try:
            if status == 200:
                files = response.json()
            else:
                print(response.status_code)

            pass
        except requests.ConnectionError as error:
            print(error)
        except Exception as e:
            print(e)

        print(files)

        return files


# private section -->
    def _torrentaction(self, action, torrentHash):
        path = 'action=%s&hash=%s' % (action, torrentHash)

        files = []

        try:
            status, response = self._action(path)

            if status == 200:
                files = response.json()
            else:
                print(response.status_code)

        except requests.ConnectionError as error:
            print(error)
        except:
            print('error')

        return files

    def _action(self, path):
        url = '%s/?%s&token=%s' % (self.base_url, path, self.token)
        headers = {
        'Content-Type': "application/json"
        }
        try:
            response = requests.get(url, auth=self.auth, cookies=self.cookies, headers=headers)
        except requests.ConnectionError as error:
            print(error)
        except:
            pass
        return response.status_code, response
