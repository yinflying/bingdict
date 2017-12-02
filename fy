#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# bingdict 翻译

import urllib,sys
import urllib.parse
import urllib.request
import re
from bs4 import BeautifulSoup
from playsound import playsound

url = 'https://cn.bing.com/dict/search?q=';
keywords = ''
if(sys.argv[1][0:1] == '-'):
    try:
        num_word = int(sys.argv[1][1:]);
    except:
        num_word = 200;
else:
    num_word = 200;

for i in range(1,len(sys.argv)):
    if(sys.argv[1][0:1] == '-' and i == 1):
        continue;
    if(keywords==''):
        keywords = sys.argv[i]
    else:
        keywords = keywords +'+'+sys.argv[i]

url = url + keywords
url = urllib.parse.quote(url, safe='+/:?=')
#print(url)
html_src = urllib.request.urlopen(url).read()
sp = BeautifulSoup(html_src,'lxml')
allmsg = sp.find('div',class_='qdef')
if(allmsg == None):
    allmsg = sp.find('div',class_='lf_area')
    try:
        thismsg1 = allmsg.find('div',class_="web_div")
        thismsg2 = allmsg.find('div',class_="web_div1")
        thismsg = allmsg.find('div',class_="smt_hw")
    except:
        print("没有找到相关的结果")
        exit()
    if(thismsg != None):
        text = allmsg.find('div',class_="p1-11")
        print(text.get_text())
    if(thismsg1 != None):
        print("音近词:")
        all_pos = thismsg1.find_all('div',class_="df_wb_c")
        for i in all_pos:
            print('[',i.find('a',class_=True).get_text(),'] ',\
                    i.find('div',class_="df_wb_text").get_text())
    if(thismsg2 != None):
        print("形近词:")
        all_pos = thismsg2.find_all('div',class_="df_wb_c")
        for i in all_pos:
            print('[',i.find('a',class_=True).get_text(),'] ',\
                    i.find('div',class_="df_wb_text").get_text())
    exit()
head_msg = allmsg.find('div',class_='hd_area')
f_word = head_msg.find('div',attrs={"class": "hd_div","id": "headword"}).get_text();
print(f_word)

# get sound
try:
    w_ps_us = head_msg.find('div',class_="hd_prUS").get_text();
    w_ps_us_speak = head_msg.find('',class_="bigaud");
    pattern = re.compile(r'https://.*?\.mp3')
    w_ps_us_speak = pattern.findall(str(w_ps_us_speak))
    w_ps_uk = head_msg.find('div',class_="hd_pr").get_text();
    print(w_ps_uk,w_ps_us)
except:
    pass

try:
    w_mean = allmsg.find('ul')
    w_attr = w_mean.find_all('span',class_='pos')
    w_def = w_mean.find_all('span',class_='def')
    for i in range(0,len(w_attr)):
        print('[',w_attr[i].get_text(),'] ',w_def[i].get_text())
except:
    print("没有找到合适解释，更多例句请参考:")
    print(url)
    exit()

#playsound
if('w_ps_us_speak' in dir()):
    playsound(str(w_ps_us_speak[0]))
