#!/bin/bash

#############################################################
################### OCSAF FreePwnedCheck ####################
#############################################################

##################################################################################################
#  FROM THE FREECYBERSECURITY.ORG TESTING-PROJECT (GNU-GPLv3) - https://freecybersecurity.org    #
#  With this script you can quickly check mail addresses against the database via the ingenious  #
#  API of https://haveibeenpwned.com/API/v2.                                                     #
#                                                                                                #
#  Use only with legal authorization and at your own risk! ANY LIABILITY WILL BE REJECTED!       #
#                                                                                                #
#  Thanks to Navan Chauhan for the code inspiration. - https://github.com/navanchauhan/Pwned     #
#  Script programming by Mathias Gut, Netchange Informatik GmbH under GNU-GPLv3                  #
#  Special thanks to the community and also for your personal project support.                   #
##################################################################################################


#######################
### Preparing tasks ###
#######################

#Check if JQ is installed.
program=(jq)
for i in "${program[@]}"; do
	if [ -z $(command -v ${i}) ]; then
		echo "${i} is not installed."
		exit
	fi
done


#######################
### TOOL USAGE TEXT ###
#######################

usage() {
	echo "From the Free OCSAF project - free for ever!"
	echo "OCSAF FreePwnedCheck Version 0.2 - GPLv3 (https://freecybersecurity.org)"
	echo "Use only with legal authorization and at your own risk!"
       	echo "ANY LIABILITY WILL BE REJECTED!"
       	echo ""	
	echo "USAGE:" 
	echo "  ./freepwnedcheck.sh -m <email address>"
       	echo "  ./freepwnedcheck.sh -l </path/list.txt>"	
       	echo ""	
	echo "EXAMPLE:"
       	echo "  ./freepwnedcheck.sh -m info@freecybersecurity.org"
       	echo ""	
	echo "OPTIONS:"
	echo "  -h, help - this beautiful text"
	echo "  -m <email address>"
	echo "  -l </path/list> - input list with email addresses - line by line"
	echo "  -c, no color scheme set"
       	echo ""
	echo "NOTES:"
	echo "#For more information go to - https://freecybersecurity.org"
}


###############################
### GETOPTS - TOOL OPTIONS  ###
###############################

while getopts "m:l:hc" opt; do
	case ${opt} in
		h) usage; exit 1;;
		m) mail="$OPTARG"; opt_arg1=1;;
		l) list="$OPTARG"; opt_arg2=1;;
		c) colors=1;;
		\?) echo "**Unknown option**" >&2; echo ""; usage; exit 1;;
        	:) echo "**Missing option argument**" >&2; echo ""; usage; exit 1;;
		*) usage; exit 1;;
  	esac
  	done
	shift $(( OPTIND - 1 ))

#Check if opt_arg1 or opt_arg2 is set
if [ "$opt_arg1" == "" ] && [ "$opt_arg2" == "" ]; then
	echo "**No argument set**"
	echo ""
	usage
	exit 1
fi


###############
### COLORS  ###
###############

if [[ $colors -eq 1 ]]; then
	cOFF=''
	gON=''
	rON=''
else
	cOFF='\e[39m'
	gON='\e[92m'
	rON='\e[91m'
fi


###############################
### FREEPWNEDCHECK FUNCTION ###
###############################

funcPwnedCheck() {
	
	local mail=$1
	local pwned
	local pasted
	local pastedid

	
	echo "Check $mail:"
	pwned=$(wget -q -O- https://haveibeenpwned.com/api/v2/breachedaccount/$mail | jq '.[]' | jq '.Title')
	pasted=$(wget -q -O- https://haveibeenpwned.com/api/v2/pasteaccount/$mail | jq '.[]' | jq '.Source')
	pastedid=$(wget -q -O- https://haveibeenpwned.com/api/v2/pasteaccount/$mail | jq '.[]' | jq '.Id')
	
	if [ "${pwned}" != "" ]; then	
		echo -e "${rON}PWNED!:${cOFF} "${pwned}
	fi
		
	if [ "${pasted}" != "" ]; then
		echo ""	
		echo -e "${rON}PASTED!:${cOFF} "${pasted}
		echo "PasteID: "${pastedid}
	fi

	if [ "${pwned}" == "" ] && [ "${pasted}" == "" ]; then	
		echo -e "${gON}OK${cOFF} - Not listed"
	fi

	echo "--------------------------------------------"
	echo ""
}


############
### MAIN ###
############

echo ""
echo "#########################################"
echo "####  OCSAF FreePwnedCheck GPLv3     ####"
echo "####  https://freecybersecurity.org  ####"
echo "#########################################"
echo ""

if [ "$opt_arg1" == "1" ]; then      #Query single mail address
	funcPwnedCheck $mail 
	unset mail
	echo ""
elif [ "$opt_arg2" == "1" ]; then    #Query mails from list
	while read line
	do
		funcPwnedCheck $line
		unset line
		sleep 1.5
	done <$list
	echo ""
fi

################### END ###################