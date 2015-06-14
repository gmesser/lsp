#!/bin/awk -f

# With the above #! line specifying the awk executable, you can put lsp.awk in
# your path, make it executable, and pipe your own ls output directly to lsp.awk
# like this:
#
#	ls -l | lsp.awk

# ##############################################################################
# Filter the long output from the 'ls' command, prepend the octal permissions.
#
# Sample input line:
# drwxr-xr-x 3 gmesser users  4096 Sep 20  2013 src
# ----=----1-
#
# Sample output line without showing the type and access characters:
# 755 drwxr-xr-x 3 gmesser users  4096 Sep 20  2013 src
# ----=----1-
#
# Sample output line when showing the type and access characters:
# d755  drwxr-xr-x 3 gmesser users  4096 Sep 20  2013 src
# ----=----1-
#
# The gnu ls command only leaves space for the access control character when any of
# the listed files has one.
# The BSD-based ls command in Mac OS X always prints the access control character. 
# This filter does not bother tracking that, it always extracts the 11th ls output
# character and calls it the access control character.
# When missing, the missing access control character is still a space in the ls
# output.  This is what would be there if ls showed the missing access control
# character, so in that case there is no harm done.  If there is an access control
# character, it will be in the 11th ls output column and this code will properly
# extract it.
# ##############################################################################

BEGIN {
	# Initialize this to 1 to print the type and access character.
	# Default to printing just the permission numbers.
	#
	# You can control whether the type of the output listing entry and the access
	# character surround the permission numbers by specifying show_type_and_access
	# on the command line like this:
	#
	# ls -l | lsp.awk -v show_type_and_access=1  # Print this in the output.

	if(show_type_and_access == "1") {
		show_type_and_access = 1;
	} else {
		show_type_and_access = 0;
	}
}

$0 !~ /^[bcCdDlMnpPs\?\-][r\-][w\-][sStTx\-][r\-][w\-][sStTx\-][r\-][w\-][sStTx\-]/ {
	# Not an ls long listing file line, just print it.
	printf("%s\n", $0);
}

/^[bcCdDlMnpPs\?\-][r\-][w\-][sStTx\-][r\-][w\-][sStTx\-][r\-][w\-][sStTx\-]/ {
	# Extract the three three-letter permission strings.
	operms = substr($0, 2, 3);
	gperms = substr($0, 5, 3);
	wperms = substr($0, 8, 3);

	# Get the permission number for each permission string.
	opermno = getpermno(operms);
	gpermno = getpermno(gperms);
	wpermno = getpermno(wperms);

	# Print the output in the desired format.
	if(!show_type_and_access) {
		printf("%d%d%d %s\n", opermno, gpermno, wpermno, $0);
	}
	else {
		type = substr($0, 1, 1);
		access = substr($0, 11, 1);
		printf("%s%d%d%d%s %s\n", type, opermno, gpermno, wpermno, access, $0);
	}
}

function getpermno(permstr) {
	permc[0] = substr(permstr, 1, 1);
	permc[1] = substr(permstr, 2, 1);
	permc[2] = substr(permstr, 3, 1);
	p = 0;

	if(permc[0] == "r") 
		p += 4;
	if(permc[1] == "w") 
		p += 2;
	if(match(permc[2], /[stx]/))
		p += 1;

	return p;
}

