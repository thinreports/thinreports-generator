# coding: utf-8

require 'rake/clean'

CLEAN.include(['doc/yardoc', '.yardoc'])
CLOBBER.include([ 'pkg' ])
