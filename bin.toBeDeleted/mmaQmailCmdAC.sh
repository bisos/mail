#!/bin/bash
#!/bin/bash

typeset RcsId="$Id: mmaQmailCmdAC.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
     `dirname $0`/seedActions.sh -l $0 "$@"
    exit $?
fi

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh

if [[ "${opRunOsType}_" == "SunOS_" ]] ; then
  mhListProg=/opt/sfw/bin/mhlist 
else
  mhListProg=/usr/bin/mh/mhlist
fi

# PRE parameters
typeset -t acctName="MANDATORY"

typeset msgBodyPartsList=""

function vis_examples {
  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
  typeset extraInfo="-v -n showRun"
  typeset oneSender="envelope@mohsen.banan.1.byname.net"
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
--- ACCESS CONTROL FACILITIES ---
cat /opt/public/osmt/samples/email/plainText.inMail  | env SENDER=${oneSender} ${G_myName} ${extraInfo} -p acSpec=./mailBot.accessControl -i accessControlVerify
cat /opt/public/osmt/samples/email/html.inMail  | ${G_myName} ${extraInfo} -p acSpec=./mailBot.accessControl -i accessControlVerify
cat /opt/public/osmt/samples/email/pdfAttach.inMail  | ${G_myName} ${extraInfo} -p acSpec=./mailBot.accessControl -i accessControlVerify
cat /opt/public/osmt/samples/email/ps-tif.inMail   | ${G_myName} ${extraInfo} -p acSpec=./mailBot.accessControl -i accessControlVerify
--- GENERIC ANALYSIS FACILITIES ---
cat /etc/motd | ${G_myName} -p acctName=sa-20051 -i environmentCapture
cat /etc/motd | ${G_myName} -v -n showRun -i environmentCapture
cat /etc/motd | ${G_myName} -v -n showRun -i messageCapture
--- END-TO-END TESTING ---
mimeMailInject.sh -p toAddrList="faxout-4256442886@mohsen.banan.1.byname.net" -i email_qmail /opt/public/osmt/samples/ps/small.ps 
mimeMailInject.sh -p toAddrList="faxout-4256442886@mohsen.banan.1.byname.net" -i email_qmail /opt/public/osmt/samples/ps/small.pdf
_EOF_
}


function vis_help {
  cat  << _EOF_

_EOF_
}

function noArgsHook {
    vis_examples
}

function vis_environmentCapture {
  
  if [[ "${acctName}_" == "_" ]] ; then
    EH_problem "acctName does not exist and/or does not belong in ${opRunHostName}."
    return 1
  else
    opAcctInfoGet ${acctName}

    if [[ "${G_verbose}_" == "verbose_" ]] ; then
      echo "opAcct_homeDir=${opAcct_homeDir}"
    fi
  fi
}


function vis_accessControlVerify {

  typeset retVal=0

  . ${acSpec}

  from=$SENDER
  to="$EXT@$HOST2"

  tmpMsgFile=/tmp/$$.inMail
  
  cat >> ${tmpMsgFile}


#   typeset  isMsg=`file -b ${tmpMsgFile} | grep mail`
#   if [[ "${isMsg}_" != "_" ]] ; then
#       EH_problem "Not in Mail Format"
#       return 1
#   fi

  acMaxSizeVerify ${tmpMsgFile}
  retVal=$?

  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "acMaxSizeVerify Succeeded -- Message Accepted"
  else
    ANT_raw "acMaxSizeVerify Failed -- Message Rejected"
    return ${qmailCmdExitFailHard}
  fi


  acBodyPartsAllowVerify ${tmpMsgFile}
  retVal=$?

  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "acBodyPartsAllowVerify Succeeded -- Message Accepted"
  else
    acBodyPartsDenyVerify ${tmpMsgFile}
    retVal=$?
    if [[ ${retVal} -eq 0 ]] ; then
      ANT_raw "acBodyPartsDenyVerify Succeeded -- Message Rejected"
      return ${qmailCmdExitFailHard}
    else
      ANV_raw "acBodyPartsDenyVerify Failed -- Message Accepted"
    fi
  fi


  acEnvelopeAllowVerify ${tmpMsgFile}
  retVal=$?

  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "acEnvelopeAllowVerify Succeeded -- Message Accepted"
  else
    acEnvelopeDenyVerify ${tmpMsgFile}
    retVal=$?
    if [[ ${retVal} -eq 0 ]] ; then
      ANT_raw "acEnvelopeDenyVerify Succeeded -- Message Rejected"
      return ${qmailCmdExitFailHard}
    else
      ANV_raw "acEnvelopeDenyVerify Failed -- Message Accepted"
    fi
  fi

  #acFromAllowVerify ${tmpMsgFile}
  #retVal=$?

  return ${qmailCmdExitSuccess}
}

function acBodyPartsAllowVerify {
  # $1 -- msgFile
  # Returns 0 if should be allowed

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi
  
  mail_partsAreInMsg $1 ${ac_bodyPartsAllowList}
  retVal=$?

  return ${retVal}
}

function acBodyPartsDenyVerify {
  # $1 -- msgFile
  # Returns 0 if should be denied

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi
  
  typeset partType=""

  for partType in ${ac_bodyPartsDenyList} ; do
    if [[ "${partType}_" == "all_" ]] ; then
      return 0
    fi
  done

  mail_partsAreInMsg $1 ${ac_bodyPartsDenyList}
  retVal=$?

  return ${retVal}
}


function acEnvelopeAllowVerify {
  # $1 -- msgFile
  # Returns 0 if should be allowed

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  thisOne="all"
  integer retVal=0
  IS_inList "${thisOne}" ${ac_envelopDenyList} || retVal=$?
  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "${thisOne} is accepted"
    return 0
  fi

  typeset thisOne=$SENDER
  retVal=0
  IS_inList "${thisOne}" ${ac_envelopAllowList} || retVal=$?
  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "${thisOne} is allowed"
    continue
  else
    ANV_raw "${thisOne} is NOT allowed"
    return 1
  fi
}


function acEnvelopeDenyVerify {
  # $1 -- msgFile
  # Returns 0 if should be denied

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  thisOne="all"
  integer retVal=0
  IS_inList "${thisOne}" ${ac_envelopDenyList} || retVal=$?
  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "${thisOne} is denied"
    return 0
  fi


  thisOne=$SENDER
  retVal=0
  IS_inList "${thisOne}" ${ac_envelopDenyList} || retVal=$?
  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "${thisOne} is denied"
    continue
  else
    ANV_raw "${thisOne} is allowed"
    return 1
  fi

  return ${retVal}
}

function acMaxSizeVerify {
  # $1 -- msgFile
  # Returns 0 if should be 

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  integer msgSize=`cat ${1} | wc -c`

  #ANV_raw "msgSize=${msgSize} ac_maxSize=${ac_maxSize}"

  if [[ ${msgSize} -gt ${ac_maxSize} ]] ; then
    ANV_raw "$0: Message Too Large msgSize=${msgSize} ac_maxSize=${ac_maxSize}"
    return 1
  else  
    ANV_raw "$0: Message Size Acceptable -- msgSize=${msgSize} ac_maxSize=${ac_maxSize}"
    return 0
  fi

}


function mail_partsAreInMsg {
  #set -x

  # $1 -- msgFile
  # $2- $@ -- part types names
  # Return
  #   0 - if at least one part type was found
  #   1 - if part type is not in the message

  if [[ $# -lt 2 ]] ; then
    EH_problem "Expected more than one Arg, got $#"
    return 1
  fi

  typeset msgFile=$1
  typeset tmpFile=/tmp/partType.$$

  shift

  typeset retVal=1

  for partType in $@ ; do
    ${mhListProg} -type ${partType} -f ${msgFile} -noheaders  2> /dev/null | grep ${partType} > ${tmpFile}
    if [[ -s ${tmpFile} ]] ; then  
      ANV_raw "partType=${partType} found"
      retVal=0
      break
    else
      ANV_raw "partType=${partType} NOT found"
      continue
    fi
  done

  /bin/rm ${tmpFile}

  return ${retVal}
}


# accessControlVerify
# acFromVerify, acBodyPartsVerify, acEnvelopeVerify
