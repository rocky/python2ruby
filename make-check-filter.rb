#!/usr/bin/env ruby
# Use this to cut out the crud from make check.
# Use like this:
#   make check 2>&1  | ruby ../make-check-filter.rb
# See Makefile.am
pats = ["^(?:Loading",
        '(re)?make\[',
        "Mark set",
        "Replaced 0 occurrences",
        "Replaced 1 occurrence",
        "Making check in",
        '\(cd \.\.',
        "make -C",
        "Test-Unit",
        "Fontifying",
        "`flet'",
        '\s*$',
        '##[<>]+$'
       ].join('|') + ')'
# puts pats
skip_re = /#{pats}/

while gets()
  next if $_.encode!('UTF-8', 'binary',
                     invalid: :replace, undef: :replace, replace: '') =~ skip_re
  puts $_
end
