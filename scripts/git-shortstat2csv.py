#!/usr/bin/env python
"""
Script to take the git shortstat line on the standard input and convert it to
CSV: files changed,insertions,deletions
"""
import re
import sys

try:
    line = raw_input()
except EOFError:
    sys.exit(0)

parts = line.split(",")


assert "file"   in parts[0]
assert "change" in parts[0]

files_changed = int(re.sub(r'[^\d]+', '', parts[0]))

if "ins" in parts[1]:
    lines_inserted = int(re.sub(r'[^\d]+', '', parts[1]))
    
    if len(parts) == 3:
        assert "del" in parts[2]
        lines_deleted = int(re.sub(r'[^\d]+', '', parts[2]))
    else:
        lines_deleted = 0
else:
    lines_inserted = 0
    assert "del" in parts[1]
    lines_deleted = int(re.sub(r'[^\d]+', '', parts[1]))

print "%d,%d,%d" % (files_changed, lines_inserted, lines_deleted)
