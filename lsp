#!/bin/sh

# lsp - Prepend the octal permissions of each directory entry in the long listing from the 'ls' command.

ls --color=always -l $@ | lsp.awk

exit 0
