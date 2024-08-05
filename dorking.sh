#!/bin/bash

############################################################################
# The OSINT project, the main idea of which is to collect all the possible #
# Google dorks search combinations and to find the information about the   #
# specific web-site: common admin panels, the widespread file types and    #
# path traversal. The 100% automated.					   #
############################################################################
# Author:   Salivan Veerasekaran                                           #
# Contact:  saliveer@1098outlook.com                                       #
# Twitter:  https://twitter.com/glinkinivan                                #
# LinkedIn: https://www.linkedin.com/in/ivanglinkin/                       #
############################################################################

# Variables
## General
version="3.171"			## Version Year.Day
updatedate="October 21, 2023"	## The date of the last update
releasedate="May 3, 2020"	## The date of release
example_domain="megacorp.one" 	## Example domain
domain=$1 			## Get the domain
proxyurl=$2			## Proxy URL
proxyport=$3			## Proxy Port
gsite="site:$domain" 		## Google Site
folder="outputs"		## Output folder name

## Request the repository
onlinevar=`curl -s https://raw.githubusercontent.com/IvanGlinkin/Fast-Google-Dorks-Scan/master/settings.conf`
onlineversion=`echo $onlinevar | awk -F\" '{print $2}'`		# Latest version
onlineupdatedate=`echo $onlinevar | awk -F\" '{print $4}'`	# The date of release
sponsorstartdate=`echo $onlinevar | awk -F\" '{print $6}'`	# Sponsor start date 
sponsorenddate=`echo $onlinevar | awk -F\" '{print $8}'`	# Sponsor end date
sponsordata=`echo $onlinevar | awk -F\" '{print $10}'`		# Sponsor data to be presented

## Colors
RED=`echo -n '\e[00;31m'`;
RED_BOLD=`echo -n '\e[01;31m'`;
GREEN=`echo -n '\e[00;32m'`;
GREEN_BOLD=`echo -n '\e[01;32m'`;
ORANGE=`echo -n '\e[00;33m'`;
BLUE=`echo -n '\e[01;36m'`;
WHITE=`echo -n '\e[00;37m'`;
CLEAR_FONT=`echo -n '\e[00m'`;

## Login pages
lpadmin="inurl:admin"
lplogin="inurl:login"
lpadminlogin="inurl:adminlogin"
lpcplogin="inurl:cplogin"
lpweblogin="inurl:weblogin"
lpquicklogin="inurl:quicklogin"
lpwp1="inurl:wp-admin"
lpwp2="inurl:wp-login"
lpportal="inurl:portal"
lpuserportal="inurl:userportal"
lploginpanel="inurl:loginpanel"
lpmemberlogin="inurl:memberlogin"
lpremote="inurl:remote"
lpdashboard="inurl:dashboard"
lpauth="inurl:auth"
lpexc="inurl:exchange"
lpfp="inurl:ForgotPassword"
lptest="inurl:test"
lpgit="inurl:.git"
lpbkp="inurl:backup"
loginpagearray=($lpadmin $lplogin $lpadminlogin $lpcplogin $lpweblogin $lpquicklogin $lpwp1 $lpwp2 $lpportal $lpuserportal $lploginpanel $memberlogin $lpremote $lpdashboard $lpauth $lpexc $lpfp $lptest $lgit $lpgit $lpbkp)

## Filetypes
ftdoc="filetype:doc"						## Filetype DOC (MsWord 97-2003)
ftdot="filetype:dot"						## Filetype DOT (MsWord Template 97-2003)
ftdocm="filetype:docm"						## Filetype DOCM (MsWord Template 97-2003)
ftdocx="filetype:docx"						## Filetype DOCX (MsWord 2007+)
ftdotx="filetype:dotx"						## Filetype DOTX (MsWord Template 2007+)
ftxls="filetype:xls"						## Filetype XLS (MsExcel 97-2003)
ftxlsm="filetype:xlsm"						## Filetype XLSM (MsExcel Template 97-2003)
ftxlsx="filetype:xlsx"						## Filetype XLSX (MsExcel 2007+)
ftppt="filetype:ppt"						## Filetype PPT (MsPowerPoint 97-2003)
ftpptx="filetype:pptx"						## Filetype PPTX (MsPowerPoint 2007+)
ftmdb="filetype:mdb"						## Filetype MDB (Ms Access)
ftpdf="filetype:pdf"						## Filetype PDF
ftsql="filetype:sql"						## Filetype SQL
fttxt="filetype:txt"						## Filetype TXT
ftrtf="filetype:rtf"						## Filetype RTF
ftcsv="filetype:csv"						## Filetype CSV
ftxml="filetype:xml"						## Filetype XML
ftconf="filetype:conf"						## Filetype CONF
ftdat="filetype:dat"						## Filetype DAT
ftini="filetype:ini"						## Filetype INI
ftlog="filetype:log"						## Filetype LOG
ftidrsa="index%20of:id_rsa%20id_rsa.pub"			## File ID_RSA
ftpy="filetype:py"						## Filetype Python
ftphtml="filetype:html"						## Filetype HTML
ftpsh="filetype:sh"						## Filetype Bash 
ftpodt="filetype:odt"						## Filetype ODT
ftpkey="filetype:key"						## Filetype KEY
ftpsgn="filetype:sign"						## Filetype SIGN
ftpmd="filetype:md"						## Filetype MD 
ftpold="filetype:old"						## Filetype OLD 
ftpbin="filetype:bin"						## Filetype BIN 
ftcer="filetype:cer"						## Filetype Certificate 
ftcrt="filetype:crt"						## Filetype Certificate 
ftpfx="filetype:pfx"						## Filetype Certificate 
ftcrl="filetype:crl"						## Filetype Certificate 
ftcrs="filetype:crs"						## Filetype Certificate 
ftder="filetype:der"						## Filetype Certificate 
ftappages="filetype:pages"					## Apple Pages (Word Processor)
ftappresent="filetype:keynote"					## Apple Keynote (Presentation)
ftappnumbers="filetype:numbers"					## Apple Numbers (Spreadsheet)
ftodt="filetype:odt"						## Open Office Text
ftods="filetype:ods"						## Open Office Spreadsheet
ftodp="filetype:odp"						## Open Office Presentation
ftodg="filetype:odg"						## Open Office Graphics
filetypesarray=($ftdoc $ftdot $ftdocm $ftdocx $ftdotx $ftxls $ftxlsm $ftxlsx $ftppt $ftpptx $ftmdb $ftpdf $ftsql $fttxt $ftrtf $ftcsv $ftxml $ftconf $ftdat $ftini $ftlog $ftidrsa $ftpy $ftphtml $ftpsh $ftpodt $ftpkey $ftpsgn $ftpmd $ftpold $ftpbin $ftcer $ftcrt $ftpfx $ftcrl $ftcrs $ftder $ftappages $ftappresent $ftappnumbers $ftodt $ftods $ftodp $ftodg)

## Directory traversal
dtparent='intitle:%22index%20of%22%20%22parent%20directory%22' 	## Common traversal
dtdcim='intitle:%22index%20of%22%20%22DCIM%22' 			## Photo
dtftp='intitle:%22index%20of%22%20%22ftp%22' 			## FTP
dtbackup='intitle:%22index%20of%22%20%22backup%22'		## BackUp
dtmail='intitle:%22index%20of%22%20%22mail%22'			## Mail
dtpassword='intitle:%22index%20of%22%20%22password%22'		## Password
dtpub='intitle:%22index%20of%22%20%22pub%22'			## Pub
dtgit='intitle:%22index%20of%22%20%22.git%22'			## Pub
dtlog='intitle:%22index%20of%22%20%22log%22'			## Log - Log files
dtconf='intitle:%22index%20of%22%20%22src%22'			## Src - Sourcecodes
dtenv='intitle:%22index%20of%22%20%22env%22'			## Env - Environment settings
dtdenv='intitle:%22index%20of%22%20%22.env%22'			## .Env - Environment settings
dtdsql='intitle:%22index%20of%22%20%22.sql%22'			## .Sql - Sql settings or dbs
dtapi='intitle:%22index%20of%22%20%22api%22'			## Api - Sensitive info about an API
dtvenv='intitle:%22index%20of%22%20%22venv%22'			## Virtual Environment Python
dtadmin='intitle:%22index%20of%22%20%admin%22'			## Admin
dirtravarray=($dtparent $dtdcim $dtftp $dtbackup $dtmail $dtpassword $dtpub $dtgit $dtlog $dtconf $dtenv $dtdenv $dtdsql $dtapi $dtvenv $dtadmin)

## User-agents
useragentsarray=(
'Mozilla/1.22 (compatible; MSIE 10.0; Windows 3.1)'
'Mozilla/4.0 (compatible; MSIE 10.0; Windows NT 6.1; Trident/5.0)'

'Opera/9.80 (X11; U; Linux i686; en-US; rv:1.9.2.3) Presto/2.2.15 Version/10.10'
);
useragentlength=${#useragentsarray[@]};

# Header
echo -e "";
echo -e "$ORANGE╔═══════════════════════════════════════════════════════════════════════════╗$CLEAR_FONT";
echo -e "$ORANGE║\t\t\t\t\t\t\t\t\t    ║$CLEAR_FONT";
echo -e "$ORANGE║$CLEAR_FONT$GREEN_BOLD\t\t\t    Fast Google Dorks Scan \t\t\t    $CLEAR_FONT$ORANGE║$CLEAR_FONT";
echo -e "$ORANGE║\t\t\t\t\t\t\t\t\t    ║\e[00m";
echo -e "$ORANGE╚═══════════════════════════════════════════════════════════════════════════╝$CLEAR_FONT";
echo -e "";
echo -e "$ORANGE[ ! ] https://www.linkedin.com/in/IvanGlinkin/ | https://x.com/glinkinivan$CLEAR_FONT";

# Check the version
checktheversion=$(echo "$version < $onlineversion" | bc -l)
if [ "$checktheversion" -eq 1 ]; then
    echo -e "$RED_BOLD[ ! ] You current FGDS version ($version) is outdated!\n[ ! ] The latest version is$CLEAR_FONT $GREEN_BOLD$onlineversion $CLEAR_FONT\n$RED_BOLD[ ! ] You can download the latest version by executing the next command:\n[ ! ]$CLEAR_FONT$GREEN_BOLD git clone https://github.com/IvanGlinkin/Fast-Google-Dorks-Scan.git $CLEAR_FONT";
else
    echo -e "$ORANGE[ ! ] Version: $version (latest)$CLEAR_FONT";
fi
echo -e "";

# Sponsor data
current_timestamp=$(date +%s)
start_timestamp=$(date -d "$sponsorstartdate" +%s)
end_timestamp=$(date -d "$sponsorenddate" +%s)

if [ "$current_timestamp" -ge "$start_timestamp" ] && [ "$current_timestamp" -le "$end_timestamp" ]; then
	echo -e "$BLUE[ ! ] Sponsor: $sponsordata $CLEAR_FONT";
	echo -e "";
fi

# Check domain
if [ -z "$domain" ] 
then
	echo -e "$ORANGE[ ! ] Usage example (simple):$CLEAR_FONT$RED_BOLD bash $0 $example_domain $CLEAR_FONT"
 	echo -e "$ORANGE[ ! ] Usage example (proxy): $CLEAR_FONT$RED_BOLD bash $0 $example_domain 192.168.1.1 8080$CLEAR_FONT"
	exit
else
	### Check if the folder for outputs is existed. IF not, create a folder
	if [ ! -d "$folder" ]; then mkdir "$folder"; fi
	## Create an output file
	filename=$(date +%Y%m%d_%H%M%S)_$domain.txt
	
	echo -e "$ORANGE[ ! ] Get information about:   $CLEAR_FONT $RED_BOLD$domain$CLEAR_FONT"
	
	if [ -n "$proxyurl" ] && [ -n "$proxyport" ]
	then
		echo -e "$ORANGE[ ! ] Proxy set to:   $CLEAR_FONT $RED_BOLD$proxyurl Port: $proxyport$CLEAR_FONT"
	fi
	echo -e "$ORANGE[ ! ] Output file is saved:    $CLEAR_FONT $RED_BOLD$(pwd)$folder/$filename$CLEAR_FONT"
fi

### Function to get information about the site ### START
function Query {
	result="";
	for start in `seq 0 10 40`; ##### Last number - quantity of possible answers
		do
			index=$(( RANDOM % useragentlength ))
			randomuseragent=${useragentsarray[$index]}

			if [ -n "$proxyurl" ] && [ -n "$proxyport" ]
				then 
					query=$(echo; curl --proxy "$proxyurl:$proxyport" -sS -b "CONSENT=YES+srp.gws-20211028-0-RC2.es+FX+330" -A "\"$randomuseragent\"" "https://www.google.com/search?q=$gsite%20$1&start=$start&client=firefox-b-e")	
				else
					query=$(echo; curl -sS -b "CONSENT=YES+srp.gws-20211028-0-RC2.es+FX+330" -A "\"$randomuseragent\"" "https://www.google.com/search?q=$gsite%20$1&start=$start&client=firefox-b-e")
			fi

			checkban=$(echo $query | grep -io "https://www.google.com/sorry/index")
			if [ "$checkban" == "https://www.google.com/sorry/index" ]
			then 
				echo -e "\n\t$RED_BOLD[ ! ]$CLEAR_FONT Google thinks you are the robot and has banned you;) How dare he? So, you have to wait some time to unban or change your ip!"; 
				exit;
			fi
				
			checkdata=$(echo $query | grep -Eo "(http|https)://[a-zA-Z0-9./?=_~-]*$domain/[a-zA-Z0-9./?=_~-]*")
			
			sleeptime=$(shuf -i8-12 -n1);
			if [ -z "$checkdata" ]
				then
					sleep $sleeptime; # Sleep to prevent banning
					break; # Exit the loop
				else
					result+="$checkdata ";
					sleep $sleeptime; # Sleep to prevent banning
			fi
	done

	### Echo results
	if [ -z "$result" ] 
		then
			echo -e "\n\t$RED_BOLD[ - ]$CLEAR_FONT No results"
		else
			IFS=$'\n' sorted=($(sort -u <<<"${result[@]}" | tr " " "\n")) # Sort the results
			echo -e " "
			for each in "${sorted[@]}"; do echo -e "\t$GREEN[ + ]$CLEAR_FONT $each"; done
	fi

	### Unset variables
	unset IFS sorted result checkdata checkban query
}
### Function to get information about site ### END

### Function to print the results ### START
function PrintTheResults {
	for dirtrav in $@; 
		do
		clearrequest=$(echo $dirtrav | sed 's/+/ /g;s/%\(..\)/\\x\1/g;' | xargs -0 printf '%b');
		echo -en "$BLUE[ > ]$CLEAR_FONT" Checking $(echo $dirtrav | cut -d ":" -f 2 | tr '[:lower:]' '[:upper:]' | sed "s@+@ @g;s@%@\\\\x@g" | xargs -0 printf "%b") $(echo "   $ORANGE[ Google query:"$CLEAR_FONT$BLUE $gsite $clearrequest$CLEAR_FONT "$ORANGE]$CLEAR_FONT")
		Query $dirtrav 
	done
echo " "
}
### Function to print the results ### END

# Exploit
echo -e "$GREEN_BOLD[ * ] Checking Login Page:$CLEAR_FONT"; PrintTheResults "${loginpagearray[@]}" | tee -a $folder/$filename;
echo -e "$GREEN_BOLD[ * ] Checking specific files:$CLEAR_FONT"; PrintTheResults "${filetypesarray[@]}" | tee -a $folder/$filename;
echo -e "$GREEN_BOLD[ * ] Checking path traversal:$CLEAR_FONT"; PrintTheResults "${dirtravarray[@]}" | tee -a $folder/$filename;