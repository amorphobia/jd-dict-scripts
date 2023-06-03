# python process_data.py char_uniq.txt | sort -k2 -s > cizu_new.txt

import csv
import sys
file = str(sys.argv[1])

with open(file) as f:
    reader = csv.reader(f, delimiter="\t")
    data = list(reader)

curr_phone_3ch = ""
homophones_3ch = []
curr_phone_och = ""
homophones_och = []

class Node:
    def __init__(self, prefix, level):
        self.prefix = prefix
        self.level = level
        self.data = []
        self.children = {}
    def available(self):
        return len(self.data) == 0 or (self.level > 0 and self.prefix == "")

def insert_tree(tree, data, level):
    key = data[2][level-1:level]
    if key in tree.keys():
        if tree[key].available():
            tree[key].data.append(data)
        else:
            insert_tree(tree[key].children, data, level+1)
    else:
        tree[key] = Node(key, level)
        tree[key].data.append(data)

def print_tree(tree, prefix):
    for key, val in tree.items():
        for item in val.data:
            print(item[0] + '\t' + item[1] + prefix + val.prefix)
        print_tree(val.children, prefix + val.prefix)

def dump_tree(tree, prefix):
    result = []
    for key, val in tree.items():
        for item in val.data:
            result.append([item[0], item[1] + prefix + val.prefix, item[3]])
        sub_result = dump_tree(val.children, prefix + val.prefix)
        result += sub_result
    result.sort(key=lambda x:(x[1], -int(x[2])))
    return result

def do_process(homophones):
    homophones.sort(key=lambda x:(x[1], -int(x[3]), x[2], x[0]))
    tree = {}
    for item in homophones:
        insert_tree(tree, item, 0)
    result = dump_tree(tree, '')
    for item in result:
        print(item[0] + '\t' + item[1])

for item in data:
    if int(item[3]) == 0:
        continue
    if len(item[1]) == 3:
        if item[1] != curr_phone_3ch:
            do_process(homophones_3ch)
            homophones_3ch = []
        curr_phone_3ch = item[1]
        homophones_3ch.append(item)
    else:
        if item[1] != curr_phone_och:
            do_process(homophones_och)
            homophones_och = []
        curr_phone_och = item[1]
        homophones_och.append(item)

do_process(homophones_3ch)
do_process(homophones_och)
