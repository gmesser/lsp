# lsp - ls, with permission numbers

This is a filter that simply adds the octal permissions to the beginning of each `ls` long-format
directory entry.

Included in this project are:

* `lsp.awk` - the filter code
* `lsp` - the shell script that runs `ls` and pipes the output to `lsp.awk`
* `findlsp` - a shell script experiment that approximates the output from `lsp`, using the `find` command
* `statlsp` - a shell script experiment that approximates the output from `lsp`, using the `stat` command

Here is some sample output:

	[gmesser@vpcf1m ~/Code/pgm-github/lsp]$ ls -l
	total 28
	-rwxr-xr-x 1 gmesser users  228 Jun 14 12:06 findlsp
	-rw-r--r-- 1 gmesser users 1055 Jun 13 12:26 license.txt
	-rwxr-xr-x 1 gmesser users  133 Jun 14 12:06 lsp
	-rwxr-xr-x 1 gmesser users 3067 Jun 14 12:27 lsp.awk
	-rw-r--r-- 1 gmesser users 4880 Jun 14 12:27 README.md
	-rwxr-xr-x 1 gmesser users  183 Jun 14 12:06 statlsp
	[gmesser@vpcf1m ~/Code/pgm-github/lsp]$ lsp
	total 28
	755 -rwxr-xr-x 1 gmesser users  228 Jun 14 12:06 findlsp
	644 -rw-r--r-- 1 gmesser users 1055 Jun 13 12:26 license.txt
	755 -rwxr-xr-x 1 gmesser users  133 Jun 14 12:06 lsp
	755 -rwxr-xr-x 1 gmesser users 3067 Jun 14 12:27 lsp.awk
	644 -rw-r--r-- 1 gmesser users 4880 Jun 14 12:27 README.md
	755 -rwxr-xr-x 1 gmesser users  183 Jun 14 12:06 statlsp
	[gmesser@vpcf1m ~/Code/pgm-github/lsp]$ ls -l | lsp.awk
	total 28
	755 -rwxr-xr-x 1 gmesser users  228 Jun 14 12:06 findlsp
	644 -rw-r--r-- 1 gmesser users 1055 Jun 13 12:26 license.txt
	755 -rwxr-xr-x 1 gmesser users  133 Jun 14 12:06 lsp
	755 -rwxr-xr-x 1 gmesser users 3067 Jun 14 12:27 lsp.awk
	644 -rw-r--r-- 1 gmesser users 4880 Jun 14 12:27 README.md
	755 -rwxr-xr-x 1 gmesser users  183 Jun 14 12:06 statlsp
	[gmesser@vpcf1m ~/Code/pgm-github/lsp]$ findlsp
	755 -rwxr-xr-x	gmesser	users	133	06/14/2015 12:06 lsp
	755 -rwxr-xr-x	gmesser	users	183	06/14/2015 12:06 statlsp
	644 -rw-r--r--	gmesser	users	4880	06/14/2015 12:27 README.md
	644 -rw-r--r--	gmesser	users	1055	06/13/2015 12:26 license.txt
	755 -rwxr-xr-x	gmesser	users	228	06/14/2015 12:06 findlsp
	755 -rwxr-xr-x	gmesser	users	3067	06/14/2015 12:27 lsp.awk
	[gmesser@vpcf1m ~/Code/pgm-github/lsp]$ statlsp
	755 -rwxr-xr-x	gmesser	users	228	2015-06-14 12:06:22.342356245 -0500 ./findlsp
	644 -rw-r--r--	gmesser	users	1055	2015-06-13 12:26:55.393167728 -0500 ./license.txt
	755 -rwxr-xr-x	gmesser	users	133	2015-06-14 12:06:22.362356607 -0500 ./lsp
	755 -rwxr-xr-x	gmesser	users	3067	2015-06-14 12:27:01.426844412 -0500 ./lsp.awk
	644 -rw-r--r--	gmesser	users	4880	2015-06-14 12:27:07.730165646 -0500 ./README.md
	755 -rwxr-xr-x	gmesser	users	183	2015-06-14 12:06:22.465689600 -0500 ./statlsp

You can put `lsp` and `lsp.awk` somewhere in your path, make sure they're executable, and use them freely.
The `lsp` script assumes that `lsp.awk` is in your path.  If you'd rather not put `lsp.awk` in your path,
you will need to edit the `lsp` script and specify the location of `lsp.awk`.

You can put `findlsp` and `statlsp` in your path if you want, but those scripts were only created to
experiment with `find` and `stat`.  They do the job, though.

The `lsp` script lets you enter your own options for `ls`.  The `lsp.awk` program will take any `ls` output
you want to pipe through it.

It seems like this should be an option in the `ls` command, but it is not.

My first thought was to add it myself, so I looked at the coreutils project on the gnu web site.
They have a page on their site where they list rejected enhancements, along with their reasons for rejecting
them.  This enhancement was already rejected because `find` and `stat` could provide the octal permissions.
The support from those two commands was "deemed sufficient".

I use `find` relatively often, and `stat` less so, but I did not know how to get the octal permission
numbers from them.  I wrote the `findlsp` and `statlsp` scripts to learn how to get that information from
`find` and `stat`.

The `ls` command is probably the most-used command.  It is the command that most new users learn first.
Replicating the output from `ls` using `find` and/or `stat` takes a lot of effort to research.  The printf-like
support provided by `find` and `stat` is nice, but the format characters are an odd mix of printf and
strftime formatting.  It is simpler to just print the permissions and not try to replicate the entire `ls`
output, but even printing just the octal permissions for one file requires using the weird printf and strftime
formatting.

I honestly don't think `find` and `stat` provide a "sufficient" alternative to a simple option on the
well-known `ls` command.  Without scripting it, and without using `find` and `stat` nearly as frequently as
`ls`, and considering the non-standard printf-like formatting required to get the octal permission numbers from
those two commands, I cannot agree about the sufficiency of the support from `find` or `stat`.  It is
awkward, at best.
