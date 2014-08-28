#!/usr/bin/python
import re, sys

global LEADING_INDENT
LEADING_INDENT = r'(^[ \t]*)'
global debug
debug=False

ELSE = r'^[ \t]*(else|elif.*|except.*):'
indent = 0
try:
    fname = sys.argv[1]
except IndexError:
    #fname = '/tmp/test.py'
    fname = 'add-python-ends.py'

indents = ['']
empty_lines = []

with open(fname) as f:
    last_indent_str = ''
    indent_str = ''
    for line in f.readlines():
        line = line.rstrip("\n")
        if line == '':
            empty_lines.append(line)
            continue
        m = re.search(LEADING_INDENT, line)
        if m:
            indent_str = m.group(0)
            if indent_str != last_indent_str:
                if indent_str == last_indent_str: continue
                if len(indent_str) < len(last_indent_str):
                    if debug: print [(len(s)) for s in indents]
                    indents = indents[0:-1]
                    while len(indents) > 0 and indents[-1] != indent_str:
                        if len(indents[-1]) != indent_str:
                            if debug: print("222")
                            print("%send" % indents[-1])
                        indents = indents[0:-1]
                    if len(indents) > 0 and not re.search(ELSE, line):
                        if debug: print "333"
                        print("%send" % indents[-1])
                if len(indents) == 0 or indents[-1] != indent_str:
                    indents.append(indent_str)
                last_indent_str = indent_str
        for s in empty_lines: print ''
        empty_lines = []
        print(line)
    while len(indents) > 0:
        if indents[-1] != indent_str:
            if debug: print("555" % indents[-1])
            print("%send" % indents[-1])
        indents = indents[0:-1]
