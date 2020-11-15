#!/bin/bash
# By Mustafa - twitter.com/c0brabaghdad1
cat<<'EOF'
                 _..._
               .'     '.
              /  _   _  \
              | (o)_(o) |
               \(     ) /
               //'._.'\ \ 
              //   .   \ \
             ||   .     \ \
             |\   :     / |
             \ `) '   (`  /_
           _)``".C0bra,.'"` (_
           )     )'--'(     (
            '---`      `---`
/------------------------------------------------\
| Written by: Mustafa , Twitter - @c0brabaghdad1 |
| Copyright (C) 2020  [DNS Hunt v1.0]            |
\------------------------------------------------/
EOF

cat<<'EOF'

[+] 0  : DNS Records (A,AAA,MX,NS,CNAME,SOA)
[+] 1  : Autonomous System (AS)
[+] 2  : Subdomains Enumeration
[+] 3  : DNS Zone Transfer Lookup
[+] 4  : Shared DNS Servers
[+] 5  : Reverse DNS Lookup
[+] 6  : Sender Policy Framework (SPF)  
[+] 7  : Domain Keys Identified Mail (DKIM)
[+] 8  : DNS Certification Authority Authorization (CAA)
[+] 9  : Domain Name System Security Extensions (DNSSEC)
[+] 10 : Domain Message Authentication Reporting and Conformance (DMARC)

EOF


read -p '[DNS-hunt][default] > ' option

case "$option" in
#DNS Records
   0) 
cat<<'EOF'

[+] 0  : A Record
[+] 1  : AAA Record
[+] 2  : MX Recor
[+] 3  : NS Record
[+] 4  : CNAME Record
[+] 5  : SOA Record

EOF

  read -p '[DNS-hunt][DNS-Records] > ' record
  read -p 'Enter Domain Name : '  domainName
  case "$record" in
        0)
        dig A $domainName +short
        ;;
        1)
        dig AAA $domainName +short
        ;;
        2)
        dig MX $domainName +short
        ;;
        3)
        dig NS $domainName +short
        ;;
        4)
        dig CNAME $domainName +short
        ;;
        5)
        dig SOA $domainName +short
        ;;
        *)
        exit 
        ;; 
   esac 
   ;;
#Autonomous System 
   1) 
cat<<'EOF'
[+] 1  : Gathering Information About The Autonomous System
[+] 2  : Check Autonomous System Number (ASN)
EOF

  read -p '[DNS-hunt][AS-Lookup] > ' as
  case "$as" in
        1)
        read -p 'Enter Domain Name > ' domainNameAs
        Ipv4_output=`dig A $domainNameAs +short`
        whois -h whois.cymru.com $Ipv4_output
        ;;
        2)
        read -p "Enter (ASN/IP) : " checkAs
        curl -s https://api.hackertarget.com/aslookup/?q=AS$checkAs
        ;;
        *)
        exit ;; 
   esac 
   ;;
#Subdomains Enumeration 
    2) 
   read -p "Enter Domain Name  : " enum
   read -p "Enter File Name for Save Result : " fileName
   amass_enum= amass enum --passive -d $enum > $fileName
   hackertarget= curl -s https://api.hackertarget.com/hostsearch/?q=$enum | sort -u >>  $fileName
   ;;
#DNS Zone Transfer
   3) 
   read -p "Enter Domain name : " zone
   for server in $(host -t ns $zone |cut -d" " -f4);do 
   host -l $zone $server | grep "has address" 
   done  
   ;;
#Shared DNS Servers
   4) 
   read -p "Enter Host Name of DNS Server :" hostName
   curl -s https://api.hackertarget.com/findshareddns/?q=$hostName   
   ;;
#Reverse DNS Lookup  
   5) 
  read -p "Enter IP address or Domain name : " range
  curl -s https://api.hackertarget.com/reversedns/?q=$range
   ;;
#SPF
   6) 
   read -p "Enter Domain Name : " spf
   nslookup  -type=txt $spf   
   ;;
#DKIM   
   7)
   read -p "Enter Domain Name : " dkim
   dig TXT google._domainkey.$dkim
   ;;
#CAA 
   8) 
   read -p "Enter Domain Name : " caa
   dig CAA $caa +short
   ;;   
#DNSSEC 
   9) 
   read -p "Enter Domain Name : " dnssec
   whois $dnssec | grep -i "dnssec"
   ;;
#DMARC
   10)
   read -p "Enter Domain Name : " dmarc
   dig TXT _dmarc.$dmarc +short
   ;;
   *)
   exit;;
esac