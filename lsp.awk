#!/bin/awk -f
# Prepend the octal permissions to the long output from the 'ls' command.

# With the #! line above specifying the awk executable, you can put lsp.awk in
# your path, make it executable, and pipe ls output directly to lsp.awk like this:
#
#     ls -l | lsp.awk

# USAGE NOTES:
#
# You can control whether the type and the access character surround the permission
# numbers by setting show_type_and_access=1 in the awk parameters like this:
#
#     ls -l | lsp.awk -v show_type_and_access=1

# Sample input lines:
# drwxrwxrwt 18 root    root     460 May 14 14:00 /tmp
# -rwsr-xr-x  1 root    root   43328 Apr 25 07:53 /usr/bin/crontab
# ----=----1-
#
# Sample output line without showing the type and access characters:
# 1777 drwxrwxrwt 18 root    root     460 May 14 14:00 /tmp
# 4755 -rwsr-xr-x  1 root    root   43328 Apr 25 07:53 /usr/bin/crontab
# ----=----1----=
#
# Sample output line when showing the type and access characters:
# d1777  drwxrwxrwt 18 root    root     460 May 14 14:00 /tmp
# -4755  -rwsr-xr-x  1 root    root   43328 Apr 25 07:53 /usr/bin/crontab
# ----=----1----=--

# The gnu ls command only prints the access control character when any of the entries has one.
# The BSD-based ls command in Mac OS X always prints an access control character. 
# This filter always extracts the 11th ls output character.
# When the access control character is missing, a space prints there in the ls output.  
# If there is an access control character, it will be in the 11th ls output column 
# and this code will properly extract it.

BEGIN {
	# Set this to 1 to print the type and access characters.
	# The default (0) prints just the permission numbers.

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

	# Get the special permission number (setuid/setgid/sticky bit).
	sppermno = getsppermno(operms, gperms, wperms);

	# Get the permission number for each permission string.
	opermno = getpermno(operms);
	gpermno = getpermno(gperms);
	wpermno = getpermno(wperms);

	# Print the output in the desired format.
	if(show_type_and_access == 0) {
		printf("%d%d%d%d %s\n", sppermno, opermno, gpermno, wpermno, $0);
	}
	else {
		type = substr($0, 1, 1);
		access = substr($0, 11, 1);
		printf("%s%d%d%d%d%s %s\n", type, sppermno, opermno, gpermno, wpermno, access, $0);
	}
}

# Get the special permission number for this directory entry.
function getsppermno(operms, gperms, wperms) {
	p = 0;

	if(match(operms, /[Ss]/))       # if the setuid permission is on
		p = 4;
	else if(match(gperms, /[Ss]/))  # if the setgid permission is on
		p = 2;
	else if(match(wperms, /[t]/))   # if the sticky bit is on
		p = 1;

	return p;
}

# Get the prmission number for the owner, or group, or world permissions for this directory entry.
function getpermno(permstr) {
	permc[0] = substr(permstr, 1, 1);
	permc[1] = substr(permstr, 2, 1);
	permc[2] = substr(permstr, 3, 1);
	p = 0;

	if(permc[0] == "r") 
		p += 4;
	if(permc[1] == "w") 
		p += 2;
	if(match(permc[2], /[sStx]/))
		p += 1;

	return p;
}

# end of lsp.awk
