#!/bin/bash
#!/bin/bash

# example of mhlist
# /usr/bin/mh/mhlist -type application/postscript -type image/tif -noheaders -f ../samples/email/twoAttach.inMail

typeset RcsId="$Id: mmaQmailCmd.sh,v 1.1.1.1 2016-06-08 23:49:52 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
     `dirname $0`/seedActions.sh -l $0 "$@"
    exit $?
fi

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh

mhListProg=/usr/bin/mh/mhlist

# PRE parameters
typeset -t acctName="MANDATORY"

typeset msgBodyPartsList=""

function vis_examples {
  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
  typeset extraInfo="-v -n showRun"
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
--- ACCESS CONTROL FACILITIES ---
cat /opt/public/osmt/samples/email/plainText.inMail  | ${G_myName} ${extraInfo} -p acSpec=./mailBot.accessControl -i accessControlVerify
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
MB: 2008
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


function vis_messageCapture {
  
  if [[ "${acctName}_" == "_" ]] ; then
    EH_problem "acctName does not exist and/or does not belong in ${opRunHostName}."
    return 1
  else
    opAcctInfoGet ${acctName}

    if [[ "${G_verbose}_" == "verbose_" ]] ; then
      echo "opAcct_homeDir=${opAcct_homeDir}"
    fi
  fi

  from=$SENDER
  to="$EXT@$HOST2"

  # When invoked by qmail, generated dirs are 700
  umask 22

  typeset myTmp="${opAcct_homeDir}/tmp"

  mkdir -p ${myTmp}

  tmpFile=${myTmp}/$$.inMail
    #echo "${G_myName}" > ${tmpFile}
    #echo "${acctName}" >> ${tmpFile}
    #echo "To is ${to}" >> ${tmpFile}
    #echo "From is ${from}" >> ${tmpFile}

  
  cat >> ${tmpFile}

  ftmp=${myTmp}/mhs$$
  rm -rf $ftmp.d
  mkdir $ftmp.d
  cd $ftmp.d
  export PATH=/usr/bin/mh:${PATH}
  mhstore + -auto -file ${tmpFile} -noverbose 2>/dev/null

  typeset outFiles=""
  
  for finp in $ftmp.d/*
  do
    tipo=$(file -b $finp)
    case "$tipo" in
      HTML\ *)
	       /usr/bin/htmldoc --webpage -t ps $finp > ${finp}.ps
	       outFiles="${outFiles} ${finp}.ps"
	       ;;
      PDF\ *) 
	      outFiles="${outFiles} $finp"
	      ;;
      ASCII\ *) 
              enscript -o ${finp}.ps $finp 2>/dev/null
	       outFiles="${outFiles} ${finp}.ps"
	      ;;
      PostScript\ *)
		     outFiles="${outFiles} $finp"
		     ;;
      *)
	 EH_problem "Unknown File Type"
	 ;;
    esac
  done

    # NOTYET
    # Parse from and to and envelope and 
    # capture and validate phone number
    # Sumbit to sendfax

  typeset thisTo=`print $EXT  | cut -d "-" -f2`
  opDoComplain /usr/bin/sendfax -D -n -f "$from" -d "$thisTo" ${outFiles}
  #opDoComplain /usr/bin/sendfax -D -f "$from" -d "$thisTo" ${outFiles}

    # Clean-up -- Comment out for debugging
  rm -rf $ftmp.d
  /bin/rm ${tmpFile}
}


function vis_accessControlVerify {
    #set -x

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


  acBodyPartsAllowVerify ${tmpMsgFile}
  retVal=$?

  if [[ ${retVal} -eq 0 ]] ; then
    ANV_raw "acBodyPartsAllowVerify Succeeded"
  else
    acBodyPartsDenyVerify ${tmpMsgFile}
    retVal=$?
    ANV_raw "acBodyPartsDenyVerifySucceeded"
    return 1
  fi

}

function acBodyPartsAllowVerify {
  # $1 -- msgFile

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
  # Returns 0 if should be 

  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi
  
  mail_partsAreInMsg $1 ${ac_bodyPartsAllowList}
  retVal=$?

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
