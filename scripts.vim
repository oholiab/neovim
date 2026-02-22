" Detect Babashka scripts and set filetype to clojure
if did_filetype()
  finish
endif

if getline(1) =~ '^#!/usr/bin/env bb'
  setfiletype clojure
endif
