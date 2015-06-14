#!/bin/sh

# lsp - Prepend the octal permissions of each file in the long listing from the 'ls' command.

ls -l $@ | lsp.awk

exit 0
