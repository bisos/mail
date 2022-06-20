#!/bin/bash
#!/bin/bash

typeset RcsId="$Id: mmaQmailListsWebProc.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
    `dirname $0`/seedActions.sh -l $0  "$@"
    exit $?
fi

typeset -t fromAddress=MANDATORY
typeset -t listManagerDomain=MANDATORY
typeset -t listSubscriberAddress=MANDATORY

typeset -t FirstName=""
typeset -t LastName=""
typeset -t compantName=""

typeset -t subscribeTo=""
typeset -t unsubscribeTo=""

typeset -t carbonCopyAddress=""
typeset -t subjectField=""

function vis_examples {

  typeset oneDomain="lists.mail.intra"
  typeset oneDistList="testDistList"

  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
--- Information
${G_myName} -p fromAddress="webmaster@${oneDomain}" -p listManagerDomain=${oneDomain} -p subscribeTo="ofice-news@${oneDomain} test@${oneDomain}" -p listSubscriberAddress="pinneke@neda.com" -p subjectField="Mailing List Request Form" -i process
${G_myName} -p fromAddress="webmaster@${oneDomain}" -p listManagerDomain=${oneDomain} -p subscribeTo="ofice-news@${oneDomain} test@${oneDomain}" -p listSubscriberAddress="pinneke@neda.com" -p subjectField="MailingListRequestForm" -i process
_EOF_
}


function noArgsHook {
  vis_examples
}

function vis_help {

  cat  << _EOF_
#
# Description:
#       This is a generalized mail-out script intende
#       for use by cgi through the web.
#
#       The header files are passed to it as traditional
#       argv parameters.
#       The body is expected to have
#        attribute=value
#       format which the recepient (usually human) then processes.
#
_EOF_
}

function vis_process {

   opParamMandatoryVerify

   if [[ "${carbonCopyAddress}_" == "_" ]] ; then
     carbonCopyAddress=${fromAddress}
   fi

   typeset subsLocalPart=`MA_localPart ${listSubscriberAddress}`
   typeset subsDomainPart=`MA_domainPart ${listSubscriberAddress}`

   typeset lists=""
   print ${subscribeTo}
   for list in ${subscribeTo} ; do
     typeset localListPart=`MA_localPart ${list}`
     typeset domainListPart=`MA_domainPart ${list}`
     typeset toAddress="${localListPart}-subscribe-${subsLocalPart}=${subsDomainPart}@${listManagerDomain}"
     typeset subjectFieldAfter="${subjectField}--${localListPart}@${listManagerDomain}"
     print ${toAddress}
     ${opBinBase}/mmaQmailInject.sh -p dashN="_nil" -p envelopeSpecMethod="ARGUMENT" -p envelopeAddr="${fromAddress}" -p fromAddr="${fromAddress}" -p toAddrList="${toAddress}" -p ccAddrList="${carbonCopyAddress}" -p subjectLine="${subjectFieldAfter}" -i inject
   done
}