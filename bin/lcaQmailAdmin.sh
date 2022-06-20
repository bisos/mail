#!/bin/bash

IcmBriefDescription="NOTYET: Short Description Of The Module"

ORIGIN="
* Revision And Libre-Halaal CopyLeft -- Part Of ByStar -- Best Used With Blee
"

####+BEGIN: bx:bash:top-of-file :vc "cvs" partof: "bystar" :copyleft "halaal+brief"
### Args: :control "enabled|disabled|hide|release|fVar"  :vc "cvs|git|nil" :partof "bystar|nil" :copyleft "halaal+minimal|halaal+brief|nil"
typeset RcsId="$Id: dblock-iim-bash.el,v 1.4 2017-02-08 06:42:32 lsipusr Exp $"
# *CopyLeft*
__copying__="
* Libre-Halaal Software"
#  This is part of ByStar Libre Services. http://www.by-star.net
# Copyright (c) 2011 Neda Communications, Inc. -- http://www.neda.com
# See PLPC-120001 for restrictions.
# This is a Halaal Poly-Existential intended to remain perpetually Halaal.
####+END:

__author__="
* Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
"


####+BEGIN: bx:bsip:bash:seed-spec :types "seedActions.bash"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedActions.bash]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailAdmin.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedActions.bash -l $0 "$@" 
    exit $?
fi
####+END:


_CommentBegin_
####+BEGIN: bx:dblock:global:file-insert-cond :cond "./blee.el" :file "/libre/ByStar/InitialTemplates/software/plusOrg/dblock/inserts/topControls.org"
*  /Controls/ ::  [[elisp:(org-cycle)][| ]]  [[elisp:(show-all)][Show-All]]  [[elisp:(org-shifttab)][Overview]]  [[elisp:(progn (org-shifttab) (org-content))][Content]] | [[file:Panel.org][Panel]] | [[elisp:(blee:ppmm:org-mode-toggle)][Nat]] | [[elisp:(bx:org:run-me)][Run]] | [[elisp:(bx:org:run-me-eml)][RunEml]] | [[elisp:(delete-other-windows)][(1)]] | [[elisp:(progn (save-buffer) (kill-buffer))][S&Q]]  [[elisp:(save-buffer)][Save]]  [[elisp:(kill-buffer)][Quit]] [[elisp:(org-cycle)][| ]]
** /Version Control/ ::  [[elisp:(call-interactively (quote cvs-update))][cvs-update]]  [[elisp:(vc-update)][vc-update]] | [[elisp:(bx:org:agenda:this-file-otherWin)][Agenda-List]]  [[elisp:(bx:org:todo:this-file-otherWin)][ToDo-List]]
####+END:
_CommentEnd_



_CommentBegin_
*      ================
*      ################ CONTENTS-LIST ################
*      ======[[elisp:(org-cycle)][Fold]]====== *[Current-Info]* Status/Maintenance -- General TODO List
_CommentEnd_

function vis_describe {  cat  << _EOF_
*      ======[[elisp:(org-cycle)][Fold]]====== *[Description:]*
*      ======[[elisp:(org-cycle)][Fold]]====== *[Related/Xrefs:]*  <<Xref-Here->>  -- External Documents 
**      ====[[elisp:(org-cycle)][Fold]]==== [[file:/libre/ByStar/InitialTemplates/activeDocs/bxServices/versionControl/fullUsagePanel-en.org::Xref-VersionControl][Panel Roadmap Documentation]]
Human visibile administration and monitoring of
qmail.
_EOF_
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Prefaces (Imports/Libraries)
_CommentEnd_

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/opDoAtAsLib.sh
. ${opBinBase}/lpParams.libSh
. ${opBinBase}/lpReRunAs.libSh


. ${opBinBase}/mmaDnsLib.sh
. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh



# PRE parameters

baseDir=""

function G_postParamHook {
     return 0
}


_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Examples
_CommentEnd_


function vis_examplesToBecome {
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""

  visLibExamplesOutput ${G_myName} 
  cat  << _EOF_
$( examplesSeperatorTopLabel "BASIC" )
$( examplesSeperatorChapter "Chapter Title" )
$( examplesSeperatorSection "Section Title" )
${G_myName} ${extraInfo} -i doTheWork
_EOF_
}


function vis_examples {
    typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
PROCESS STATUS ---
${G_myName} -i showProcs
${G_myName} -i killProcs
${G_myName} -i start
${G_myName} -i stop
SYSTEM INFORMATION ---
${G_myName} -i showProgAccts
${G_myName} -i fullReport
--- SEREVER WIDE MANIPULATION ---
mmaQmailHosts.sh
mmaQmailHosts.sh -s all -a summary
mmaQmailHosts.sh -s shoosh -a serverType
mmaQmailHosts.sh -s all -a walkObjects
mmaQmailHosts.sh -s shoosh -a walkObjects
mmaQmailHosts.sh -s shoosh -a acctAddrsFqmaShow
--- MAIL DOMAIN WIDE MANIPULATION ---
mmaQmailDoms.sh
mmaQmailDoms.sh -s all -a summary
mmaQmailDoms.sh -s qmailDomMain_mailIntra -a acctAddrsFqmaShow
mmaQmailDoms.sh -s qmailDomVir_recordsMailIntra -a acctAddrsFqmaShow
--- ACCTS AND ADDRESSES ADMINISTRATION ---
mmaQmailAddrs.sh
mmaQmailAddrs.sh -i help
--- MAILING LIST ADMINISTRATION ---
mmaQmailLists.sh 
--- FULL MANIPLATORS --- 
${G_myName} -i fullVerify
${G_myName} -i fullUpdate
--- USAGE EXAMPLES ---
${G_myName} -n showRun -i qmailExampleGnatsUpdate
${G_myName} -n showRun -i qmailExampleGnatsDelete
--- QUEUE STATUS ---
${G_myName} -i showQueueStatistics
${G_myName} -i showQueue
${G_myName} -i forceQueue
--- TEST AND VERIFY ---
${G_myName} -i injectFirst mohsen@neda.com
--- LOGS AND REPORTS ---
${G_myName} -h -n showRun -i showLogs
${G_myName} -i showSmtpdLog
${G_myName} -i showAuthSmtpdLog
${G_myName} -i showPubinSmtpdLog
${G_myName} -i showSslinSmtpdLog
${G_myName} -i showBasicLog
${G_myName} -i showLogCommands
--- DIAGNOSTICS SPAM ---
mconnect
mozilla -remote "openurl(http://www.dnsstuff.com)"
=== OLD BACKWARDS COMPATIBILITY
--- LOGS AND REPORTS ---
${G_myName} -n showOnly -i showLogOld
${G_myName} -i showLogOld
${G_myName} -i runFunc cat /var/log/qmail/current | matchup 5>tmp.5 | senders
${G_myName} -i runFunc apt-get install qmailanalog-installer
apt-get install isoqlog
isoqlog
--- RLB Stuff ---
_EOF_
}


noArgsHook() {
  vis_examples
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Module Functions
_CommentEnd_


function vis_doTheWork {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    lpDo vis_failExample
    EH_retOnFail

    lpReturn
}


noArgsHook() {
    vis_examples
}

#qmailUsersBaseDir=/var/qmail/users/
#qmailBinBaseDir=/var/qmail/bin

vis_start() {
  #/etc/init.d/mma-qmail start
    /etc/init.d/qmail start
}

vis_stop() {
  /etc/init.d/qmail stop
}

vis_fullReport() {
  vis_showProcs
  vis_showProgAccts

  ${qmailBinBaseDir}/qmail-showctl
}

vis_showProcs() {
  #
  typeset -i procsNum=`pgrep  'qmail|splogger' | wc -l`
  if [ "${procsNum}_" != "5_" ] ; then
    echo "Some Qmail Processes Are Missing, ${procsNum}"
  else
    echo "All Qmail Processes Running"
  fi
  pgrep -l 'qmail|splogger'
}

vis_killProcs() {

  # NOTYET, This is not safe and right Just temporary
  #

  pkill 'qmail-send'
  pkill 'splogger'
  pkill 'qmail-lspawn'
  pkill 'qmail-rspawn'
  pkill 'qmail-clean'

    vis_showProcs
}

vis_showProgAccts() {
    mmaQmailUsersAndGroupsInfo
}

function vis_showQueue {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;

    opDoComplain qmail-qread 
    #opDoComplain ${qmailBinBaseDir}/qmail-qread 
    #opDoComplain mailq

}


function vis_showQueueStatistics {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;

    opDoComplain qmail-qstat
    #opDoComplain ${qmailBinBaseDir}/qmail-qstat 
}


vis_forceQueue() {
    opDoComplain pkill -SIGALRM qmail-send
}



vis_showLogOld() {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    opDo tail -50 /var/adm/maillog

  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    opDo tail -50 /var/log/mail.log

  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}

function vis_showLogs {
    vis_showSmtpdLog
    continueAfterThis
    vis_showBasicLog
}
    
function vis_showAuthSmtpdLog {
    #opDo tail -50 /var/log/qmail/authsmtpd/current
    opDo tail -50 /var/log/qmail/authsmtpd/current | tai64nlocal

}

function vis_showPubinSmtpdLog {
    #opDo tail -50 /var/log/qmail/pubinsmtpd
    opDo tail -50 /var/log/qmail/pubinsmtpd/current | tai64nlocal

}

function vis_showSslinSmtpdLog {
    opDo eval tail -50 /var/log/qmail/sslinsmtpd/current '|' tai64nlocal
    ANT_raw tail -50 /var/log/qmail/sslinsmtpd/current '|' tai64nlocal
}

function vis_showSmtpdLog {
    opDo tail -50 /var/log/qmail/smtpd/current | tai64nlocal
}

vis_showBasicLog() {
    opDo eval tail -50 /var/log/qmail/current '|' tai64nlocal
    ANT_raw tail -50 /var/log/qmail/current '|' tai64nlocal
}

function vis_showLogCommands {
    ANT_raw "tail -50 /var/log/qmail/current | tai64nlocal"
    ANT_raw "tail -50 /var/log/qmail/smtpd/current | tai64nlocal"
    ANT_raw "tail -50 /var/log/qmail/pubinsmtpd/current | tai64nlocal"
    ANT_raw "tail -50 /var/log/qmail/authsmtpd/current  | tai64nlocal"
    ANT_raw "tail -50 /var/log/qmail/sslinsmtpd/current  | tai64nlocal"
}


function vis_qmailExampleGnatsUpdate {
  # GNATS
  opDoExit mmaQmailVirDomUpdate "gnats.mail.intra" gnats

  #opDoExit mmaQmailAddrs.sh -p acctName=gnats -s qmailAddrsList_tldRoles -a addrUpdate

  # -p progs=gnatsProcessor
  opDoExit mmaQmailAddrs.sh -p FQMA=bugs@gnats.mail.intra -p mbox=Main.mboxMma -i addrUpdate

  opDoRet mmaDnsEntryMxUpdate "gnats.mail.intra" "shoosh"

  mmaQmailAdmin.sh -i injectFirst bugs@gnats.mail.intra
}


function vis_qmailExampleGnatsDelete {
  # GNATS

  # -p progs=gnatsProcessor
  opDoExit mmaQmailAddrs.sh -p FQMA=bugs@gnats.mail.intra -p mbox=Main.mboxMma -i addrDelete

  #opDoExit mmaQmailAddrs.sh -p acctName=gnats -s qmailAddrsList_tldRoles -a addrDelete

  opDoExit mmaQmailVirDomDelete "gnats.mail.intra" gnats

  opDoRet mmaDnsEntryMxDelete "gnats.mail.intra" "shoosh"
}


function vis_injectFirst {
  # $@, list of FQMAs to be used in the to list

  EH_assert [[ $# -gt 0 ]]
  
  typeset thisOne=""

  mmaQmailMsgDefaults

  #mmaQmailMsg_dashN="_t"

  #mmaQmailMsg_envelopeSpecMethod="${envelopeSpecMethod}"

  mmaQmailMsg_envelopeAddr="admin@mohsen.banan.1.byname.net"
  mmaQmailMsg_fromAddr="admin@byname.net"

  #mmaQmailMsg_ccAddrList=""
  mmaQmailMsg_subjectLine="Welcome First Message"
  
  tmpContentFile=/tmp/${G_myName}.$0.$$


 cat  << _EOF_ > ${tmpContentFile}
Some Text ${thisOne}
_EOF_

  mmaQmailMsg_contentFile=${tmpContentFile}

  for thisOne in  ${@} ; do
    print -- Sending Mail To: ${thisOne}
    mmaQmailMsg_extraHeaders="_nil"
    mmaQmailMsg_toAddrList="${thisOne}"
    mmaQmailMsgInject
  done

  FN_fileRmIfThere  ${tmpContentFile}
}

### NOTYET  -- Get all addrs for a domain, then send them each 
# a particular message.

function vis_injectFirstAll {

  typeset serverAddrList=""
  typeset thisOne=""

  serverAddrList=`mmaQmailHosts.sh -s shoosh -a acctAddrsGenFull`

  mmaQmailMsgDefaults

  #mmaQmailMsg_dashN="_t"

  #mmaQmailMsg_envelopeSpecMethod="${envelopeSpecMethod}"

  mmaQmailMsg_envelopeAddr="admin@mohsen.banan.1.byname.net"
  mmaQmailMsg_fromAddr="admin@byname.net"

  #mmaQmailMsg_ccAddrList=""
  mmaQmailMsg_subjectLine="Welcome First Message"
  
  tmpContentFile=/tmp/${G_myName}.$0.$$


 cat  << _EOF_ > ${tmpContentFile}
Some Text ${thisOne}
_EOF_

  mmaQmailMsg_contentFile=${tmpContentFile}

  for thisOne in  ${serverAddrList} ; do
    print -- Sending Mail To: ${thisOne}
    mmaQmailMsg_extraHeaders="_nil"
    mmaQmailMsg_toAddrList="${thisOne}"
    mmaQmailMsgInject
  done

  FN_fileRmIfThere  ${tmpContentFile}
}

function vis_fullVerify {
  EH_problem "NOTYET"
  # mimic fullUpdate
}


function vis_fullUpdate {
  opDoRet mmaSendmailActions.sh -i sendmailDefunct
  opDoRet  mmaQmailBinsPrep.sh -i qmailInitInstall
}

#   # NOTYET, verify that the software is in place
#   
#   
#   mmaQmailHosts.sh -s ${opRunHostName} -a configure
#   mmaQmailAdmin.sh -i start
#   mmaQmailAdmin.sh -i fullReport
#   # Originate a test message
#   mmaQmailAdmin.sh -p from=mohsen@neda.com -p envelope=mohsen@neda.com -p to=mohsen@neda.com -i injectEnvTest
#   mmaQmailAdmin.sh -i showQueue
#   echo "To see the logs, run:"
#   echo "mmaQmailAdmin.sh -i showLog"



####+BEGIN: bx:dblock:bash:end-of-file :type "basic"
_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  Common        ::  /[dblock] -- End-Of-File Controls/ [[elisp:(org-cycle)][| ]]
_CommentEnd_
#+STARTUP: showall
#local variables:
#major-mode: sh-mode
#fill-column: 90
# end:
####+END:
