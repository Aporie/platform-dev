#!/bin/bash

usage="Installation of multisite instance\n
Syntax : $(basename $0) [ARGS] INSTANCE\n
\t-?,-h, --help\t\tPrint this message\n\n
\t-v, --verbose\t\tSet the script in verbose mode
Connection information\n
\t-u, --db-user\t\tSet the database user\n
\t-p, --db-pass\t\tSet the database password\n
\t-H, --db-host\t\tSet the database host\n\n
\t-P, --db-port\t\tSet the database port\n\n
Configuration of the site\n
\t-a, --account\t\tDefine the account name for the administrator\n
\t-e, --account-email\tDefine the email address for the administrator\n
\t-n, --site-name\t\tDefine the site name\n
\t-m, --site-email\t\tDefine the site email\n
\t-b, --base-url\t\tDefine the base URL of the site\n"

#Default values
webroot='/var/www'
db_user='root'
db_pass=''
db_host='localhost'
db_port=3306
account_name='admin'
account_pass='pass'
account_mail='EMAIL@ADDRESS.COM'
site_name='SITE NAME'
site_mail='EMAIL@ADDRESS.COM'
baseurl='www.site.com'
verbose=false

while getopts "u:p:H:P:a:e:n:b:vh?-:" option; do
	#Management of the --options
	if [ "$option" = "-" ]; then
		case $OPTARG in
			help) option=h ;;
			verbose) option=v ;;
			dbuser) option=u ;;
			dbpass) option=p ;;
			dbhost) option=H ;;
			dbport) option=P ;;
			account) option=a ;;
			account-email) option=e ;;
			site-name) option=n ;;
			site-email) option=m ;;
			base-url) option=b ;;
			*) 
				echo "[ERROR] Unknown option --$OPTARG"
				exit 1
				;;
		esac
	fi
	case $option in
		u) db_user=$OPTARG ;;
		p) db_pass=$OPTARG ;;
		H) db_host=$OPTARG ;;
		P) db_port=$OPTARG ;;
		a) account=$OPTARG ;;
		e) account_mail=$OPTARG ;;
		n) site_name=$OPTARG ;;
		m) site_mail=$OPTARG ;;
		b) baseurl=$OPTARG ;;
		v) verbose=true ;;
		\?|h)
			echo -e $usage
			exit 0
			;;
		:)
			echo "[ERROR] Missing arguments for -$OPTARG"
			exit 1
			;;
		?)
			echo "[ERROR] Unknown option -$option"
			exit 1
			;;
	esac
done
