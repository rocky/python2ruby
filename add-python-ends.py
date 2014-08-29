#!/usr/bin/python
import re, sys

def continued_line(line):
    return len(line) > 0 and '\\' == line[-1]


LEADING_INDENT = r'(^[ \t]*)'
global debug
debug=False

IGNORE = r'^[ \t]*}$|((else|elif.*|except.*):)'
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
    prev_line = ''
    last_was_continue = False
    for line in f.readlines():
        if debug: print [len(i) for i in indents]
        line = line.rstrip("\n")
        if line == '':
            empty_lines.append(line)
            prev_line = line
            last_was_continue = False
            continue
        m = re.search(LEADING_INDENT, line)
        if last_was_continue:
            prev_line = line
            last_was_continue = continued_line(line)
            print "last_was_continue: %s", repr(last_was_continue)
            for s in empty_lines: print ''
            empty_lines = []
            print(line)
            continue
        if m:
            if continued_line(prev_line):
                # Don't care what the indentation is on this line
                # Also, there are no ends inserted
                last_was_continue = continued_line(line)
                prev_line = line
                for s in empty_lines: print ''
                empty_lines = []
                print(line)
                continue
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
                    if len(indents) > 0 and \
                      not re.search(IGNORE, line):
                        if debug: print "333"
                        print("%send" % indents[-1])
                if len(indents) == 0 or indents[-1] != indent_str:
                    indents.append(indent_str)
                last_indent_str = indent_str
        for s in empty_lines: print ''
        empty_lines = []
        print(line)
        prev_line = line
    while len(indents) > 0:
        if indents[-1] != indent_str:
            if debug: print("555" % indents[-1])
            print("%send" % indents[-1])
        indents = indents[0:-1]
