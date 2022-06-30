#!/bin/bash
#!/bin/bash 

typeset RcsId="$Id: mmaQmailInject.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
    `dirname $0`/seedActions.sh -l $0 "$@"
    exit $?
fi

. ${opBinBase}/opDoAtAsLib.sh
. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh

# NOTYET
# Make all the parameters match the library convention
# 
# Provide reasonable examples
# Provide doit and doNot and passthem through opDoAtAs in the library
#
# Discover, what defaults are used when not specified.
# Verfiy return codes.
# Go back and replace other uses of mail sending 
#

# PRE parameters

#typeset -t dashN="_nil"
#typeset -t dashN="_t"

typeset -t envelopeSpecMethod="ENVIRONMENT"

typeset -t envelopeAddr="_nil"

typeset -t fromAddr="_nil"
typeset -t toAddrList="_nil"
typeset -t ccAddrList="_nil"
typeset -t subjectLine="_nil"
typeset -t extraHeaders="_nil"

typeset -t contentFile="_nil"


vis_examples() {

  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
  typeset exampleFromAddr="mohsen@neda.com"
  typeset exampleToAddr="mohsen@neda.com"
  cat  << _EOF_
EXAMPLES:
${visLibExamples}
--- SEND MAIL WITH CONTENT FILE FROM STANDARD IN ---
cat /etc/motd | ${G_myName} -n showRun -p contentFile=stdin -p toAddrList="${exampleToAddr}" -i inject
cat /etc/motd | ${G_myName} -v -n showOnly -p contentFile=stdin -p toAddrList="${exampleToAddr}" -p envelopeAddr="${exampleFromAddr}" -p fromAddr="${exampleFromAddr}" -p subjectLine="testing" -i inject
--- SEND MAIL WITH CONTENT FILE FROM A FILE ---
${G_myName} -n showOnly -p envelopeSpecMethod="ARGUMENT" -p envelopeAddr="${exampleFromAddr}" -p fromAddr="${exampleFromAddr}" -p toAddrList="${exampleToAddr},pinneke@neda.com" -p ccAddrList="ab,sgh" -p subjectLine="testing" -p contentFile="/acct/employee/pinneke/tmp/testMmaQmailInject" -i inject
--- OBSOLETE ---
cat /etc/motd | ${G_myName} -p dashN="both" -p contentFile=stdin -p toAddrList="${exampleToAddr}" -i inject
_EOF_
}

vis_help () {
  cat  << _EOF_
Command Line and Library Examples for mmaQmailInject.
To see examples run:
${G_myName} -i examples
_EOF_
}

noArgsHook() {
    vis_examples
}


function vis_inject {
  # $1=doit|doNot
  # stdin may have message content
  #
  #
  typeset this_m_doingDefault=$*

  integer retVal=0
   doAtAsMode=`doAtAsModeSet ${this_m_doingDefault}` || retVal=$?

  if [ ${retVal} -eq 1 ] ; then
    EH_problem "Too many args"
    return 1
  elif [ ${retVal} -eq 2 ] ; then
    EH_problem "Unknown Qualifier: ${this_m_doingDefault}"
    return 1
  elif [ ${retVal} -ne 0 ] ; then
    EH_problem "Bad Value: ${this_m_doingDefault}"
    return 1
   fi

  mmaQmailMsgDefaults

  mmaQmailMsg_envelopeSpecMethod="${envelopeSpecMethod}"

  mmaQmailMsg_envelopeAddr="${envelopeAddr}"
  mmaQmailMsg_fromAddr="${fromAddr}"
  mmaQmailMsg_toAddrList="${toAddrList}"
  mmaQmailMsg_ccAddrList="${ccAddrList}"
  mmaQmailMsg_subjectLine="${subjectLine}"
  mmaQmailMsg_extraHeaders="${extraHeaders}"

  #mmaQmailMsg_subjectLine="Subject Line -- Test Message, Ignore"
  #mmaQmailMsg_extraHeaders="${mmaQmailMsg_extraHeaders}X-Enevelope: mohsen@neda.com\n" 
  #mmaQmailMsg_extraHeaders="${mmaQmailMsg_extraHeaders}ToBad: mohsen@neda.com\n"

  mmaQmailMsg_contentFile="${contentFile}"

  mmaQmailMsgInject

  #FN_fileRmIfThere  ${tmpContentFile}

}






