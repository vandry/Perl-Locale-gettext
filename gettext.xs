#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <string.h>

static double
constant(name, arg)
char *name;
int arg;
{
    errno = 0;
    if (strEQ(name, "LC_CTYPE"))
	return LC_CTYPE;
    if (strEQ(name, "LC_NUMERIC"))
	return LC_NUMERIC;
    if (strEQ(name, "LC_COLLATE"))
	return LC_COLLATE;
    if (strEQ(name, "LC_MONETARY"))
	return LC_MONETARY;
    if (strEQ(name, "LC_MESSAGES"))
	return LC_MESSAGES;
    if (strEQ(name, "LC_ALL"))
	return LC_ALL;
    errno = EINVAL;
    return 0;
}

MODULE = Locale::gettext	PACKAGE = Locale::gettext

double
constant(name,arg)
	char *		name
	int		arg

char *
gettext(msgid)
	char *		msgid

char *
dcgettext(domainname, msgid, category)
	char *		domainname
	char *		msgid
	int		category

char *
dgettext(domainname, msgid)
	char *		domainname
	char *		msgid

char *
textdomain(domain)
	char *		domain

char *
bindtextdomain(domain, dirname)
	char *		domain
	char *		dirname
