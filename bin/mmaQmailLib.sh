
. ${opBinBase}/opDoAtAsLib.sh

qmailCmdExitSuccess=0
qmailCmdExitSuccessFinish=99
qmailCmdExitFailHard=100
qmailCmdExitFailSoft=111

if [ -d "/var/qmail" ] ; then
    qmailVarDir=/var/qmail
else
    qmailVarDir=/var/lib/qmail    
fi

if [ -d "/var/qmail/control" ] ; then
    qmailControlBaseDir="/var/qmail/control"
else
    qmailControlBaseDir="/etc/qmail"
fi


qmailVirDomFile=${qmailVarDir}/control/virtualdomains
#qmailVirDomFile=/etc/qmail/virtualdomains


qmailUsersBaseDir=${qmailVarDir}/users
#qmailUsersBaseDir=/etc/qmail/users

if [ -d "${qmailVarDir}/bin" ] ; then
    qmailBinBaseDir=${qmailVarDir}/bin
else
    qmailBinBaseDir="/usr/sbin"
fi


qmailInject=${qmailBinBaseDir}/qmail-inject   # Backwards compatibility
qmailInjectProgram=${qmailBinBaseDir}/qmail-inject

if [ -x "/usr/bin/maildirmake" ] ; then 
    qmailMaildirmakeProgram="/usr/bin/maildirmake"
else
    qmailMaildirmakeProgram="${qmailBinBaseDir}/maildirmake"
fi 

if [ -x "/usr/bin/preline" ] ; then 
    qmailPrelineProgram="/usr/bin/preline"
else
    qmailPrelineProgram="${qmailBinBaseDir}/preline"
fi

qmailPw2uProgram="${qmailBinBaseDir}/qmail-pw2u"
qmailNewuProgram="${qmailBinBaseDir}/qmail-newu"
qmailTcpEnvProgram="${qmailBinBaseDir}/tcp-env"

# Component base
mmaEzmlmCompBase=/opt/public/mma/ezmlm
mmaEzmlmCompBinBase=${mmaEzmlmCompBase}/bin

#
# ---------
#

function mmaQmailUsersAndGroupsAdd {
  print "Creating Basic Qmail User Ids"

  #${opBinBase}/opAcctGroups.sh -s gid_qmailNofile -a verifyAndFix
  ${opBinBase}/opAcctGroups.sh -s gid_qmail -a verifyAndFix

  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_alias -a verifyAndFix
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmaild -a verifyAndFix
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmaill -a verifyAndFix
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailp -a verifyAndFix
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailq -a verifyAndFix
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailr -a verifyAndFix
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmails -a verifyAndFix
}

# mmaQmailProgramUsersAndGroupsDel
function mmaQmailUsersAndGroupsDel {
  print "Deleting Basic Qmail User Ids"

  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_alias -a delete
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmaild -a delete
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmaill -a delete
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailp -a delete
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailq -a delete
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailr -a delete
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmails -a delete

    # Groups should be deleted after users have been deleted

  #${opBinBase}/opAcctGroups.sh -s gid_qmailNofile -a delete
  ${opBinBase}/opAcctGroups.sh -s gid_qmail -a delete
}

function mmaQmailUsersAndGroupsInfo {
  #${opBinBase}/opAcctGroups.sh -s gid_qmailNofile -a info
  ${opBinBase}/opAcctGroups.sh -s gid_qmail -a info

  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_alias -a info
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmaild -a info
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmaill -a info
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailp -a info
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailq -a info
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmailr -a info
  ${opBinBase}/opAcctUsers.sh -p acctType=mmaProgramAccount -s qmailUsr_qmails -a info
}

function mmaQmailLocDeliveryAcctsProcess {


      print "Running ${qmailPw2uProgram}"
    opDo eval cat /etc/passwd \| ${qmailPw2uProgram}  \> ${qmailUsersBaseDir}/assign

    opDoRet ${qmailNewuProgram}

    # NOTYET, is this really needed
    print "pkill -HUP 'qmail-send'"
    opDo pkill -HUP 'qmail-send'
    return 0
}


function mmaQmailLocDeliveryAcctAdd {
  # $1 -- An account to become a local delivery target

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  if USER_isInPasswdFile ${1} ; then
    FN_lineAddToFile "^${1}\$" "${1}" ${qmailUsersBaseDir}/include
    ANV_raw "$0: $1 was added to ${qmailUsersBaseDir}/include"

    opDoRet mmaQmailLocDeliveryAcctsProcess || return $?
  else
    print "$0: Skipping ${1} because it is not in the passwd file"
  fi
  return 0
}

function mmaQmailLocDeliveryAcctDelete {
  # $1 -- An account to be deleted

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  if USER_isInPasswdFile ${1} ; then
    FN_lineRemoveFromFile "^${1}\$" ${qmailUsersBaseDir}/include
    #print "$0: $1 was deleted from ${qmailUsersBaseDir}/include"

    opDoRet mmaQmailLocDeliveryAcctsProcess
  else
    print "$0: Skipping ${1} because it is not in the passwd file"
  fi
  return 0
}

function mmaQmailLocDeliveryAcctVerify {
  # $1 -- An account to verify as a local delivery target

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  typeset acctName=`egrep ":$1:" ${qmailUsersBaseDir}/assign`

  if [[ "${acctName}_" == "_" ]] ; then
    EH_problem "$1 not found in ${qmailVirDomFile}"
    return 1
  fi

  return 0
}

function mmaQmailVirDomEntryAdd {
  # $1 -- Virtaul Domain Name
  # $2 -- accountName

  if [[ $# -ne 2 ]] ; then
    EH_problem "Expected 2 args, got $#"
    return 1
  fi

  # NOTYET, does this work?
  #EH_assert [[ USER_isInPasswdFile ${2} ]]

  if USER_isInPasswdFile ${2} ; then
    FN_lineAddToFile "^${1}:${2}\$" "${1}:${2}" ${qmailVirDomFile}
  else
    print "$0: Skipping ${2} because it is not in the passwd file"
    return 2
  fi

  #grep ${2} ${qmailVirDomFile}

  print "pkill -HUP 'qmail-send'"
  pkill -HUP 'qmail-send'
  return 0
}

function mmaQmailVirDomEntryDelete {
  # $1 -- Virtaul Domain Name
  # $2 -- accountName

  if [[ $# -ne 2 ]] ; then
    EH_problem "Expected 2 args, got $#"
    return 1
  fi

  # NOTYET, does this work?
  #EH_assert [[ USER_isInPasswdFile ${2} ]]

  if USER_isInPasswdFile ${2} ; then
    FN_lineRemoveFromFile "^${1}:${2}\$" ${qmailVirDomFile}
  else
    print "$0: Skipping ${2} because it is not in the passwd file"
    return 2
  fi

  #grep ${2} ${qmailVirDomFile}

  print "pkill -HUP 'qmail-send'"
  pkill -HUP 'qmail-send'
  return 0
}

function mmaQmailLocDeliveryDomainGet {
  head -1 ${qmailControlBaseDir}/locals
  return 0
}


mmaQmailRcpthostsEntryAdd() {
  # $1 -- Domain (e.g., Virtaul Domain Name)

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 args, got $#"
  fi

  FN_lineAddToFile "^${1}\$" "${1}"  ${qmailControlBaseDir}/rcpthosts

  #grep ${1} ${qmailControlBaseDir}/rcpthosts

  # Is there a need to send a signal to qmail-smtpd?
  return 0
}

mmaQmailRcpthostsEntryDelete() {
  # $1 -- Domain (e.g., Virtaul Domain Name)

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 args, got $#"
  fi

  FN_lineRemoveFromFile "^${1}\$" ${qmailControlBaseDir}/rcpthosts

  #grep ${1} ${qmailControlBaseDir}/rcpthosts

  # Is there a need to send a signal to qmail-smtpd?
  return 0
}

function mmaQmailVirDomAcctGet {
  # $1 -- Virtaul Domain Name
  # Given a virDom find corresponding account

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  typeset acctName=`egrep "^$1:" ${qmailVirDomFile} | cut -d : -f 2`

  if [[ "${acctName}_" == "_" ]] ; then
    EH_problem "$1 not found in ${qmailVirDomFile}"
    return 1
  fi
  
  print ${acctName}
  return 0
}

function mmaQmailVirDomDomainGet {
  # $1 -- acctName
  # Given an account find corresponding domain

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  typeset domainName=`egrep ":$1$" ${qmailVirDomFile} | cut -d : -f 1`

  if [[ "${domainName}_" == "_" ]] ; then
    EH_problem "$1 not found in ${qmailVirDomFile}"
    return 1
  fi
  
  print ${domainName}
  return 0
}

function mmaQmailVirDomVerify {
  # $1 -- Virtaul Domain Name

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
  fi
  EH_problem "NOTYET"
  return 1
}


function mmaQmailVirDomUpdate {
  # $1 -- Virtaul Domain Name
  # $2 -- accountName

  if [[ $# -ne 2 ]] ; then
    EH_problem "Expected 2 args, got $#"
  fi

  opDoRet mmaQmailLocDeliveryAcctAdd ${2}
  opDoRet mmaQmailVirDomEntryAdd ${1} ${2}
  opDoRet mmaQmailRcpthostsEntryAdd ${1}
}

function mmaQmailVirDomDelete {
  # $1 -- Virtaul Domain Name
  # $2 -- accountName

  if [[ $# -ne 2 ]] ; then
    EH_problem "Expected 2 args, got $#"
  fi

  opDoRet mmaQmailLocDeliveryAcctDelete ${2}
  opDoRet mmaQmailVirDomEntryDelete ${1} ${2}
  opDoRet mmaQmailRcpthostsEntryDelete ${1}
}



typeset mmaQmail_acctName=""
typeset mmaQmail_domainPart=""
typeset mmaQmail_domainType=""
typeset mmaQmail_localPart=""
typeset mmaQmail_myLocalPart=""
typeset mmaQmail_dotQmailFile=""
typeset mmaQmail_mboxFiles=""

# Module local
function m_mboxFilesGet {
  # Given mmaQmail_dotQmailFile,
  # Setup mmaQmail_mboxFiles
  
  EH_assert [[ "${mmaQmail_dotQmailFile}_" != "_" ]] 

  # NOTYET, need to come up with a better way of doing this
  # Below is temporary
  mmaQmail_mboxFiles=`head -1 ${mmaQmail_dotQmailFile}`
  return 0
}

function mmaQmailAccountAnalyze {
#set -x
  # $1 -- acctName  (mandatory)
  # $2 -- localPart (optional)
  # Given an acctName and localPart find corresponding
  #          - mmaQmail_acctName
  #          - mmaQmail_domainPart
  #          - mmaQmail_domainType
  #          - mmaQmail_localPart
  #          - mmaQmail_myLocalPart
  #          - mmaQmail_dotQmailFile
  #          - mmaQmail_mboxFiles
  #

  if [[ $# -lt 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  mmaQmail_acctName=$1

  opDoExit opAcctInfoGet ${mmaQmail_acctName}

  opDoRet  mmaQmailLocDeliveryAcctVerify ${mmaQmail_acctName}

  if [[ $# -eq 1 ]] ; then
    mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail

    # NOTYET, MB 2010 Experiment
    mmaQmail_domainType=virDomain

    print ${mmaQmail_acctName} 
    return 0

  elif [[ $# -eq 2 ]] ; then
    mmaQmail_localPart=$2

    mmaQmail_acctName=${mmaQmail_localPart%%-*}
    mmaQmail_myLocalPart=${mmaQmail_localPart#*-}
    if [[ "${mmaQmail_myLocalPart}_" == "${mmaQmail_localPart}_" ]] ; then
      mmaQmail_myLocalPart=""
      mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail
      m_mboxFilesGet
    else
      mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail-${mmaQmail_myLocalPart}
      m_mboxFilesGet
    fi
    
    print  ${mmaQmail_acctName} ${mmaQmail_dotQmailFile}
    return 0
  else
    EH_problem "Expected 1 or 2 args, got $#"
    return 1
  fi

}

#
# MOHSEN: Nov. 30, 03 Broken Big time. mmaQmailAccountAnalyze loops

# function mmaQmailAccountAnalyze {
#   # $1 -- acctName  (mandatory)
#   # $2 -- localPart (optional)
#   # Given an acctName and localPart find corresponding
#   #          - mmaQmail_acctName
#   #          - mmaQmail_domainPart
#   #          - mmaQmail_domainType
#   #          - mmaQmail_localPart
#   #          - mmaQmail_myLocalPart
#   #          - mmaQmail_dotQmailFile
#   #          - mmaQmail_mboxFiles
#   #

#     set -x

#   if [[ $# -lt 1 ]] ; then
#     EH_problem "Expected 1 arg, got $#"
#     return 1
#   fi

#   mmaQmail_acctName=$1

#   opDoExit opAcctInfoGet ${mmaQmail_acctName}

#   opDoRet  mmaQmailLocDeliveryAcctVerify ${mmaQmail_acctName}

#   opDoExit mmaQmailAccountAnalyze ${mmaQmail_acctName}

#   if [[ $# -eq 1 ]] ; then
#     print ${mmaQmail_domainPart} ${mmaQmail_localPart} ${mmaQmail_myLocalPart} ${mmaQmail_acctName} ${mmaQmail_domainType}
#     return 0

#   elif [[ $# -eq 2 ]] ; then
#     mmaQmail_localPart=$2

#     if [[ "${mmaQmail_domainPart}_" == "${mainDomain}_" ]] ; then 
#       mmaQmail_acctName=${mmaQmail_localPart%%-*}
#       mmaQmail_myLocalPart=${mmaQmail_localPart#*-}
#       if [[ "${mmaQmail_myLocalPart}_" == "${mmaQmail_localPart}_" ]] ; then
# 	mmaQmail_myLocalPart=""
# 	mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail
# 	m_mboxFilesGet
#       else
# 	mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail-${mmaQmail_myLocalPart}
# 	m_mboxFilesGet
#       fi
#     elif [[ "${mmaQmail_domainType}_" == "virDomain_" ]] ; then 
#       mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail-${mmaQmail_localPart}
#       m_mboxFilesGet
#     else
#       EH_oops "Bad domain type: ${mmaQmail_domainType}"
#     fi

#     print ${mmaQmail_domainPart} ${mmaQmail_localPart} ${mmaQmail_myLocalPart} ${mmaQmail_acctName} ${mmaQmail_domainType} ${mmaQmail_dotQmailFile} ${mmaQmail_mboxFiles}
#     return 0
#   else
#     EH_problem "Expected 1 or 2 args, got $#"
#     return 1
#   fi
# }

function mmaQmailFqmaAnalyze {
  # $1 -- FQMA localPart@domainPart
  # Given a FQMA find corresponding
  #          - mmaQmail_acctName
  #          - mmaQmail_localPart
  #          - mmaQmail_myLocalPart
  #          - mmaQmail_domainPart
  #          - mmaQmail_domainType
  #          - mmaQmail_dotQmailFile
  #          - mmaQmail_mboxFiles

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  typeset FQMA=$1

  #
  mmaQmail_domainPart=`MA_domainPart ${FQMA}`
  mmaQmail_localPart=`MA_localPart ${FQMA}`
  typeset acctName=`mmaQmailVirDomAcctGet ${mmaQmail_domainPart} 2> /dev/null`
    
  if [[ "${acctName}_" == "_" ]] ; then
    typeset mainDomain=`mmaQmailLocDeliveryDomainGet`
    if [[ "${mmaQmail_domainPart}_" == "${mainDomain}_" ]] ; then 
      mmaQmail_acctName=${mmaQmail_localPart%%-*}
      opDoExit opAcctInfoGet ${mmaQmail_acctName}
      mmaQmail_myLocalPart=${mmaQmail_localPart#*-}
      if [[ "${mmaQmail_myLocalPart}_" == "${mmaQmail_localPart}_" ]] ; then
	mmaQmail_myLocalPart=""
	mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail
	m_mboxFilesGet
      else
	mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail-${mmaQmail_myLocalPart}
	m_mboxFilesGet
      fi
      mmaQmail_domainType=mainDomain
    else
      EH_problem "Invalid $1"
      return 1
    fi
  else
    mmaQmail_acctName=${acctName}
    opDoExit opAcctInfoGet ${mmaQmail_acctName}
    mmaQmail_domainType=virDomain
    mmaQmail_myLocalPart=${mmaQmail_localPart}
    mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail-${mmaQmail_localPart}
    m_mboxFilesGet
  fi

  print ${mmaQmail_domainPart} ${mmaQmail_localPart} ${mmaQmail_myLocalPart} ${mmaQmail_acctName} ${mmaQmail_domainType}

  return 0
}

function mmaQmailDomainAnalyze {
  # $1 -- domainPart
  # Given a domainPart find corresponding
  #          - mmaQmail_acctName
  #          - mmaQmail_domainPart
  #          - mmaQmail_domainType
  #          - mmaQmail_dotQmailFile

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  mmaQmail_domainPart=$1

  mmaQmail_localPart=`MA_localPart ${FQMA}`
  typeset acctName=`mmaQmailVirDomAcctGet ${mmaQmail_domainPart} 2> /dev/null`
    
  if [[ "${acctName}_" == "_" ]] ; then
    typeset mainDomain=`mmaQmailLocDeliveryDomainGet`
    if [[ "${mmaQmail_domainPart}_" == "${mainDomain}_" ]] ; then 
      mmaQmail_acctName=alias
      opDoExit opAcctInfoGet ${mmaQmail_acctName}
      mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail
      m_mboxFilesGet
    else
      EH_problem "Invalid $1"
      return 1
    fi
  else
    mmaQmail_acctName=${acctName}
    opDoExit opAcctInfoGet ${mmaQmail_acctName}
    mmaQmail_domainType=virDomain
    mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail
    m_mboxFilesGet
  fi

  print ${mmaQmail_domainPart} ${mmaQmail_localPart} ${mmaQmail_myLocalPart} ${mmaQmail_acctName} ${mmaQmail_domainType}

  return 0
}


mmaQmailMsgDefaults() {

  #mmaQmailMsg_dashN="_t"  # _nil=forReal, _t=JustDashN, "both"=forReal and dashN
  #mmaQmailMsg_dashN="_nil"  # _nil=forReal, _t=JustDashN, "both"=forReal and dashN
  mmaQmailMsg_envelopeSpecMethod="ENVIRONMENT" #  ENVIRONMENT or ARGUMENT

  mmaQmailMsg_envelopeAddr="_nil"

  mmaQmailMsg_fromAddr="_nil"
  mmaQmailMsg_toAddrList="_nil"
  mmaQmailMsg_ccAddrList="_nil"
  mmaQmailMsg_subjectLine="_nil"
  mmaQmailMsg_extraHeaders="_nil"

  mmaQmailMsg_contentFile="_nil"  # (stdin, later possible)

}

mmaQmailMsgInject() {

  typeset G_runModeDefault="runOnly"

  if [[ "${G_runMode}_" == "_" ]] ; then
    G_runMode="${G_runModeDefault}"
  fi

  typeset envelopeDomain=""
  typeset envelopeLocal=""
  typeset envCmdLineArg=""
  typeset headerFull=""
  typeset tmpFile=""


  if [ "${mmaQmailMsg_envelopeSpecMethod}_" == "ENVIRONMENT_" -o "${mmaQmailMsg_envelopeSpecMethod}_" == "_" ] ; then
    envCmdLineArg=""
    if [ "${mmaQmailMsg_envelopeAddr}_" != "_nil_" ] ; then
     envelopeDomain=`MA_domainPart ${mmaQmailMsg_envelopeAddr}`
     envelopeLocal=`MA_localPart ${mmaQmailMsg_envelopeAddr}`

     export QMAILHOST=${envelopeDomain}
     export QMAILUSER=${envelopeLocal}
    fi

  elif [ "${mmaQmailMsg_envelopeSpecMethod}_" == "ARGUMENT_" ] ; then
    if [ "${mmaQmailMsg_envelopeAddr}_" != "_nil_" ] ; then
      envCmdLineArg="-f ${mmaQmailMsg_envelopeAddr}"
    fi
  else
    EH_oops ""
    return 1
  fi

  #Now Generate the full header as a string

  headerFull=""

  if [ "${mmaQmailMsg_fromAddr}_" != "_nil_" ] ; then
    headerFull="${headerFull}From: ${mmaQmailMsg_fromAddr}\n"
  fi

  if [ "${mmaQmailMsg_toAddrList}_" != "_nil_" ] ; then
    headerFull="${headerFull}To: ${mmaQmailMsg_toAddrList}\n"
  fi

  if [ "${mmaQmailMsg_ccAddrList}_" != "_nil_" ] ; then
    headerFull="${headerFull}CC: ${mmaQmailMsg_ccAddrList}\n"
  fi

  if [ "${mmaQmailMsg_bccAddrList}_" != "_nil_" ] ; then
    headerFull="${headerFull}BCC: ${mmaQmailMsg_bccAddrList}\n"
  fi

  if [ "${mmaQmailMsg_subjectLine}_" != "_nil_" ] ; then
    headerFull="${headerFull}Subject: ${mmaQmailMsg_subjectLine}\n"
  fi

  if [ "${mmaQmailMsg_extraHeaders}_" != "_nil_" ] ; then
    mmaQmailMsg_extraHeaders="${mmaQmailMsg_extraHeaders}X-Origin: mmaQmailInject Script\n"
  else
    mmaQmailMsg_extraHeaders="X-Origin: mmaQmailInject Script\n"
  fi

   headerFull="${headerFull}${mmaQmailMsg_extraHeaders}"


   LOG_message "Send TO:${mmaQmailMsg_toAddrList} FROM-ENVELOPE:${mmaQmailMsg_envelopeAddr}"

   tmpFile=/tmp/${G_progName}.mmaQmailInject.$$

   #print ${headerFull} > ${tmpFile}
   /bin/echo -e ${headerFull} > ${tmpFile}

   case ${mmaQmailMsg_contentFile} in
     ""|"_nil" )
	doNothing
	;;
     "-"|"stdin")
	while read line ; do
 	print "$line" >> ${tmpFile}
 	done
	;;
     * )
        if [ ! -f ${mmaQmailMsg_contentFile} ] ; then
	  EH_problem "mmaQmailMsg_contentFile: ${mmaQmailMsg_contentFile} Not found"
	  return 1
	else
	  cat ${mmaQmailMsg_contentFile} >> ${tmpFile}
	fi
	;;
   esac

   integer mmaQmailInject_exitCode=0

   #

   if [ "${G_runMode}_" == "showOnly_" ] ; then 
     opDoExit eval "(cat ${tmpFile} | ${qmailInject} ${envCmdLineArg} -n || mmaQmailInject_exitCode=$?)"
     if  [[ "${G_verbose}_" == "verbose_" ]] ; then 
       echo "--- EXACT MESSAGE BEGIN ---"
       # No opDoExit in front of this because of showOnly
       cat ${tmpFile} | ${qmailInject} ${envCmdLineArg} -n || mmaQmailInject_exitCode=$?
       echo "--- EXACT MESSAGE END ---"
     fi
     opDoExit mmaQmailInjectExitCodeCheck ${mmaQmailInject_exitCode}
   elif [ "${G_runMode}_" == "runOnly_" ] ; then 
     opDoExit  eval "(cat ${tmpFile} | ${qmailInject} ${envCmdLineArg} || mmaQmailInject_exitCode=$?)"
     opDoExit mmaQmailInjectExitCodeCheck ${mmaQmailInject_exitCode}
   elif [ "${G_runMode}_" == "showRun_" ] ; then 
     opDoExit eval "(cat ${tmpFile} | ${qmailInject} ${envCmdLineArg}  || mmaQmailInject_exitCode=$?)"
     if  [[ "${G_verbose}_" == "verbose_" ]] ; then 
       echo "--- EXACT MESSAGE BEGIN ---"
       opDoExit eval "(cat ${tmpFile} | ${qmailInject} ${envCmdLineArg} -n || mmaQmailInject_exitCode=$?)"
       echo "--- EXACT MESSAGE END ---"
     fi
     opDoExit mmaQmailInjectExitCodeCheck ${mmaQmailInject_exitCode}
   else 
     EH_problem "Bad Usage"
     return 1
   fi

   #FN_fileRmIfThere ${tmpFile}
}

function mmaQmailInjectExitCodeCheck {

  # $1 = the mmaQmailInject_exitCode that are being checked

  if [ $1 -ne 0 ] ; then
    if [ $1 -eq 100 ] ; then
      EH_problem "$0: qmail-inject was invoked improperly or severe syntax error in the message"
      return 1
    elif [ $1 -eq 111 ] ; then
      EH_problem "$0: qmail-inject temporary errors"
      return 1
    fi
  fi
}


function mmaMultiArchSymLinks {
  # $1  -- originPoint
  # $2  -- endPoint

  if  [[ $# -ne 2 ]] ; then
    EH_problem "$0 requires two args: Args=$@"
    return 1
  fi

  FN_multiArchSymLinks $1 /here/archLinks/$1 $2
}



function mmaMultiArchSymLinks {
  # $1  -- originPoint
  # $2  -- endPoint

  if  [[ $# -ne 2 ]] ; then
    EH_problem "$0 requires two args: Args=$@"
    return 1
  fi

  FN_multiArchSymLinks $1 /here/archLinks/$1 $2
}

function qmailLocalEnvCapture  {

qmailLocal_SENDER=${SENDER}
qmailLocal_NEWSENDER=${NEWSENDER}
qmailLocal_RECIPIENT=${RECIPIENT}
qmailLocal_USER=${USER}
qmailLocal_HOME=${HOME}
qmailLocal_LOCAL=${LOCAL}
qmailLocal_HOST=${HOST}
qmailLocal_HOST2=${HOST2}
qmailLocal_HOST3=${HOST3}
qmailLocal_HOST4=${HOST4}
qmailLocal_EXT=${EXT}
qmailLocal_EXT2=${EXT2}
qmailLocal_EXT3=${EXT3}
qmailLocal_EXT4=${EXT4}
qmailLocal_DEFAULT=${DEFAULT}
qmailLocal_DTLINE=${DTLINE}
qmailLocal_RPLINE=${RPLINE}
qmailLocal_UFLINE=${UFLINE}

}

function qmailLocalEnvCaptureStdout  {
 cat  << _EOF_
qmailLocal_SENDER=${SENDER}
qmailLocal_NEWSENDER=${NEWSENDER}
qmailLocal_RECIPIENT=${RECIPIENT}
qmailLocal_USER=${USER}
qmailLocal_HOME=${HOME}
qmailLocal_LOCAL=${LOCAL}
qmailLocal_HOST=${HOST}
qmailLocal_HOST2=${HOST2}
qmailLocal_HOST3=${HOST3}
qmailLocal_HOST4=${HOST4}
qmailLocal_EXT=${EXT}
qmailLocal_EXT2=${EXT2}
qmailLocal_EXT3=${EXT3}
qmailLocal_EXT4=${EXT4}
qmailLocal_DEFAULT=${DEFAULT}
qmailLocal_DTLINE=${DTLINE}
qmailLocal_RPLINE=${RPLINE}
qmailLocal_UFLINE=${UFLINE
_EOF_
}


##
## Junk Yard
##


# function mmaQmailDomainGet {
#   # $1 -- acctName
#   # Given an account find corresponding domain

#   if [[ $# -ne 1 ]] ; then
#     EH_problem "Expected 1 arg, got $#"
#     return 1
#   fi

#   typeset acctName=$1

#   opDoExit  mmaQmailLocDeliveryAcctVerify ${acctName}

#   mmaQmail_domainPart=`mmaQmailVirDomDomainGet ${acctName} 2> /dev/null`

#   if [[ "${mmaQmail_domainPart}_" == "_" ]] ; then
#     mmaQmail_domainPart=`mmaQmailLocDeliveryDomainGet`
#     mmaQmail_domainType="mainDomain"
#     if [[ "${mmaQmail_domainPart}_" == "_" ]] ; then
# 	EH_problem "$1 not found in localDelivery"
# 	return 1
#     fi
#   else
#     mmaQmail_domainType="virDomain"
#   fi
  
#   return 0
# }

# function mmaQmailAcctGet {
#   # $1 -- Domain Name
#   # Given a domainName find corresponding account

#   if [[ $# -ne 1 ]] ; then
#     EH_problem "Expected 1 arg, got $#"
#     return 1
#   fi

#   typeset acctName=`egrep "^$1:" ${qmailVirDomFile} | cut -d : -f 2`

#   if [[ "${acctName}_" == "_" ]] ; then
#     typeset mainDomain=`mmaQmailLocDeliveryDomainGet`
#     if [[ "$1_" == "${mainDomain}_" ]] ; then 
#       acctName=alias
#     else
#       EH_problem "Invalid $1"
#       return 1
#     fi
#   fi
  
#   print ${acctName}
#   return 0
# }

