# lsp - ls, with permission numbers

##### 2022-05-14 Greg Messer

This is a filter that simply adds the octal permissions to the beginning of each `ls` long-format directory entry.  

Included in this project are:

* `lsp.awk` - the filter code
* `lsp` - the shell script that runs `ls -l` and pipes the output to `lsp.awk`
* `findlsp` - a shell script experiment that approximates the output from `lsp`, using the `find` command
* `statlsp` - a shell script experiment that approximates the output from `lsp`, using the `stat` command

## Sample Output:

```
	[gmesser@gxps ~/Code/pgm-github/lsp]$ ls -l
	total 28
	-rwxr-xr-x 1 gmesser users  228 Sep 21  2015 findlsp
	-rw-r--r-- 1 gmesser users 1055 Sep 21  2015 license.txt
	-rwxr-xr-x 1 gmesser users  144 May 14 16:37 lsp
	-rwxr-xr-x 1 gmesser users 3475 May 14 15:43 lsp.awk
	-rw-r--r-- 1 gmesser users 4934 May 14 16:38 README.md
	-rwxr-xr-x 1 gmesser users  183 Sep 21  2015 statlsp
	
	[gmesser@gxps ~/Code/pgm-github/lsp]$ ls -l | awk -f lsp.awk
	total 28
	0755 -rwxr-xr-x 1 gmesser users  228 Sep 21  2015 findlsp
	0644 -rw-r--r-- 1 gmesser users 1055 Sep 21  2015 license.txt
	0755 -rwxr-xr-x 1 gmesser users  144 May 14 16:37 lsp
	0755 -rwxr-xr-x 1 gmesser users 3475 May 14 15:43 lsp.awk
	0644 -rw-r--r-- 1 gmesser users 4934 May 14 16:38 README.md
	0755 -rwxr-xr-x 1 gmesser users  183 Sep 21  2015 statlsp
	
	[gmesser@gxps ~/Code/pgm-github/lsp]$ findlsp
	755 drwxr-xr-x	gmesser	users	4096	09/21/2015 17:49 .git
	755 -rwxr-xr-x	gmesser	users	144	09/21/2015 17:49 lsp
	755 -rwxr-xr-x	gmesser	users	3475	09/21/2015 17:49 lsp.awk
	755 -rwxr-xr-x	gmesser	users	228	09/21/2015 17:49 findlsp
	644 -rw-r--r--	gmesser	users	1055	09/21/2015 17:49 license.txt
	755 -rwxr-xr-x	gmesser	users	183	09/21/2015 17:49 statlsp
	644 -rw-r--r--	gmesser	users	4934	09/21/2015 17:49 README.md
	
	[gmesser@gxps ~/Code/pgm-github/lsp]$ statlsp
	755 -rwxr-xr-x	gmesser	users	228	2015-09-21 17:49:52.332268427 -0500 ./findlsp
	644 -rw-r--r--	gmesser	users	1055	2015-09-21 17:49:52.332268427 -0500 ./license.txt
	755 -rwxr-xr-x	gmesser	users	144	2022-05-14 16:37:12.066819563 -0500 ./lsp
	755 -rwxr-xr-x	gmesser	users	3475	2022-05-14 15:43:40.303191878 -0500 ./lsp.awk
	644 -rw-r--r--	gmesser	users	4934	2022-05-14 16:38:10.888051881 -0500 ./README.md
	755 -rwxr-xr-x	gmesser	users	183	2015-09-21 17:49:52.332268427 -0500 ./statlsp
```

## -- The `lsp` shell script and the lsp.awk program --

You can put `lsp` and `lsp.awk` somewhere in your path, make them executable, and use them freely.  The `lsp` script assumes that `lsp.awk` is in your path.  If you'd rather not put `lsp.awk` in your path, you will need to edit the `lsp` script and specify the location of `lsp.awk`.

The `lsp` script lets you enter your own options for `ls`.  The `lsp.awk` program will take any `ls` output you want to pipe through it.

For each directory entry in the long `ls` output, the `lsp.awk` program prints the single digit for the **set user ID (setuid)** / **set group ID (setgid)** / **restricted deletion (sticky bit)** permission, then the three digits for the user, group and world permissions, then the rest of the original ls output.  The four-digit permission number is the same as the number you would specify to the `chmod` command.

## -- Fairly equivalent output from `find` and `stat` --

You can put `findlsp` and `statlsp` in your path if you want, but those scripts were only created to experiment with `find` and `stat`.  They do the job, though.

## -- Discussion --

It seems like printing the permission numbers should be an option in the `ls` command, but no.

My first thought was to add it myself, so I looked at the coreutils project on the gnu web site.  They have a page on their site where they list rejected enhancements, along with their reasons for rejecting them.  This enhancement was already rejected because `find` and `stat` could provide the octal permissions. The support from those two commands was "deemed sufficient".

I use `find` relatively often, and `stat` less so, but I did not know how to get the octal permission numbers from them.  I wrote the `findlsp` and `statlsp` scripts to learn how to get that information from `find` and `stat`.

The `ls` command is probably the most-used command, and it is the command that most people learn first.  Replicating the output from `ls` using `find` and/or `stat` takes a lot of effort to research.  The printf-like support provided by `find` and `stat` is nice, but the format characters are an odd mix of printf and strftime formatting.  

I honestly don't think `find` and `stat` provide a sufficient alternative to a simple option on the well-known `ls` command.  Considering the odd printf-like formatting required to get the octal permission numbers from those two commands, I cannot agree about the sufficiency of the support from `find` or `stat`.  It is awkward, at best.
