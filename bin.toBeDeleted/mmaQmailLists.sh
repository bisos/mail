#!/bin/bash
#!/bin/bash

typeset RcsId="$Id: mmaQmailLists.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
     `dirname $0`/seedSubjectAction.sh -l $0 "$@"
     exit $?
fi

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh
. ${opBinBase}/mmaDnsLib.sh
. ${opBinBase}/mmaWebLib.sh
. ${opBinBase}/opCronLib.sh

# PRE parameters
typeset -t listsDom="_nil"
typeset -t specificOutHtmlBaseDir="MANDATORY"
typeset -t specificMailFolder="MANDATORY"

function G_postParamHook {
 if [[ "${listsDom}_" != "_nil_" ]] ; then
    ItemsFiles=${opSiteControlBase}/${opRunSiteName}/mmaQmailListItems.${listsDom}
    if [[ -f ${opSiteControlBase}/${opRunSiteName}/mmaQmailListItems.special ]] ; then
      ItemsFiles="${ItemsFiles} ${opSiteControlBase}/${opRunSiteName}/mmaQmailListItems.special"
    fi
 else
   doNothing
   #EH_problem "listsDom is MANDATORY"
 fi
}

# NOTYET, where should this be properly defined
#MHONARC="${mmaBase}/MHonArc/bin/mhonarc -reverse -treverse -multipg -rcfile ${mmaBase}/MHonArc/bin/mhonarchResourceFile.rc"
MHONARC="mhonarc -spammode -reverse -treverse -multipg -rcfile ${mmaBase}/MHonArc/bin/mhonarchResourceFile.rc"

function vis_examples {
  typeset oneSubscriber="webmaster@lists.mail.intra"
  #typeset oneDomain="lists.mail.intra"
  typeset oneDomain="lists.payk.net"
  typeset oneDistList="testDistList"
  #oneDistList=`${G_myName} -p listsDom=${oneDomain} -i ls | head -1`

  typeset doLibExamples=`doLibExamplesOutput ${G_myName}`
 cat  << _EOF_
EXAMPLES:
${doLibExamples}

---- INFORMATION ---
${G_myName} -p listsDom=${oneDomain} -s all -a summary
${G_myName} -p listsDom=${oneDomain} -s all -a listServerInfo
${G_myName} -p listsDom=${oneDomain} -s officeNewsListsMailIntra -a listServerInfo
${G_myName} -p listsDom=${oneDomain} -s all -a walkObjects
--- INITIAL ACTIONS -- Mailing Lists Top Domain Manipulation ---
${G_myName} -p listsDom=${oneDomain} -i distListVirDomShow
${G_myName} -p listsDom=${oneDomain} -i distListVirDomUpdate
${G_myName} -p listsDom=${oneDomain} -i distListVirDomDelete
${G_myName} -p listsDom=${oneDomain} -i dnsUpdate
${G_myName} -p listsDom=${oneDomain} -i accessControlUpdate
--- FULL CONFIGURATION ACTIONS ---
${G_myName} -p listsDom=${oneDomain} -s all -a fullVerify
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a fullVerify
${G_myName} -p listsDom=${oneDomain} -s all -a fullUpdate
${G_myName} -p listsDom=${oneDomain} -s all -a fullDelete
--- LIST SERVER SETUP ---
${G_myName} -p listsDom=${oneDomain} -s all -a listServerUpdate
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a listServerUpdate
${G_myName} -p listsDom=${oneDomain} -s all -a listServerDelete
${G_myName} -p listsDom=${oneDomain} -s all -a listOwnerAssign
--- LIST SERVER RESTRICTIONS ---
${G_myName} -p listsDom=${oneDomain} -s allowDistList -a subsShow
${G_myName} -p listsDom=${oneDomain} -s denyDistList -a subsShow
${G_myName} -p listsDom=${oneDomain} -s allowDistList -a subsUpdate ${oneSubscriber}
${G_myName} -p listsDom=${oneDomain} -s allowDistList -a subsDelete ${oneSubscriber}
${G_myName} -p listsDom=${oneDomain} -s denyDistList -a subsUpdate ${oneSubscriber}
${G_myName} -p listsDom=${oneDomain} -s denyDistList -a subsDelete ${oneSubscriber}
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a postRestrictionsVerify
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a postRestrictionsUpdate
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a postRestrictionsDelete
--- LIST SERVER MAINTENANCE ---
${G_myName} -p listsDom=${oneDomain} -s all -a sendPeriodic
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a sendPeriodic
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a disable
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a restore
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a snapShotTake
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a snapShotRestore
--- LIST SERVER CRON MANIPULATION ---
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a cronEntryShow
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a cronEntryVerify
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a cronEntryUpdate
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a cronEntryDelete
--- SUBSCRIBER MAINTENANCE ---
${G_myName} -p listsDom=${oneDomain} -s all -a subsUpdate ${oneSubscriber}
${G_myName} -p listsDom=${oneDomain} -s all -a subsDelete ${oneSubscriber}
${G_myName} -p listsDom=${oneDomain} -s all -a subsShow
--- MAIL ARCHIVING ---
${G_myName} -p listsDom=${oneDomain} -s all -a archiverVerify
${G_myName} -p listsDom=${oneDomain} -s all -a archiverUpdate
${G_myName} -p listsDom=${oneDomain} -s all -a archiverDelete
---- LIST WEB INTERAFCE ---
${G_myName} -p listsDom=${oneDomain} -s all -a htmlUpdate
${G_myName} -p listsDom=${oneDomain} -s all -a htmlRebuild
${G_myName} -p listsDom=${oneDomain} -s all -a webFullUpdateToFile
${G_myName} -p listsDom=${oneDomain} -s all -a webSummaryUpdate > /tmp/xxx
${G_myName} -p listsDom=${oneDomain} -s all -a webSummaryUpdateToFile
${G_myName} -p listsDom=${oneDomain} -s officeNewsListsMailIntra -a webDescUpdate > /tmp/xxx
${G_myName} -p listsDom=${oneDomain} -s all -a webDescUpdateToFile
${G_myName} -p listsDom=${oneDomain} -s all -a webBaseSubsForm > /tmp/xxx
${G_myName} -p listsDom=${oneDomain} -s all -a webBaseSubsFormToFile
${G_myName} -p listsDom=${oneDomain} -i webBaseProcessScript > /tmp/xxx
${G_myName} -p listsDom=${oneDomain} -i webBaseProcessScriptToFile
--- INTEGRITY CHECKS ---
${G_myName} -p listsDom=${oneDomain} -s all -a schemaVerify
${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a schemaVerify
--- SPECIAL --
${G_myName} -p specificOutHtmlBaseDir="/usr/devenv/webs/paykPublic/htdocs/mailingLists/pnw-iranians/html/1993" -p specificMailFolder="/acct/progs/qmaildom/net/payk/records/lists-pnw-iranians.jan-dec93.clean" -i htmlUpdateSpecial
_EOF_
}

function vis_help {
  cat  << _EOF_
  DESCRIPTION

--- General ---

-p listsDom=mailDomain should always be set

itemSpecial_allowDistList and itemSpecial_allowDistList
used  to maintain access control

--- INITIAL ACTIONS -- Mailing Lists Top Domain Manipulation ---
vis_dnsSetup:

vis_distListVirDomCreate:

--- FULL CONFIGURATION ACTIONS ---
do_fullVerify:

do_fullUpdate
--- LIST SERVER SETUP ---
do_listServerCreate

do_listServerDelete

do_listOwnerAssign
--- LIST SERVER RESTRICTIONS ---
do_accessControlUpdate

do_postRestrictionsVerify
do_postRestrictionsUpdate
do_postRestrictionsDelete

--- LIST SERVER MAINTENANCE ---
do_sendPeriodic

do_disable
do_restore

do_snapShotStore
do_snapShotRestore
         Store a snap shot of the mailing list including
         all memebers, ... so that the mailing list can
         be moved and restored elsewhere.

--- LIST SERVER CRON MANIPULATION ---
cronEntryShow
cronEntryVerify
cronEntryUpdate
cronEntryDelete
--- SUBSCRIBER MAINTENANCE ---
subsUpdate ${oneSubscriber}
subsDelete ${oneSubscriber}
subsShow
--- MAIL ARCHIVING ---
archiverVerify
archiverUpdate
archiverDelete
---- LIST WEB INTERAFCE ---
htmlUpdate
--htmlRebuild--OBSOLETED
webSummaryUpdate > /tmp/xxx
webSummaryUpdateToFile
webDescUpdate > /tmp/xxx
webDescUpdateToFile
_EOF_
}

noArgsHook() {
  vis_examples
}

firstSubjectHook() {
  case ${action} in
    "webSummaryUpdate")
       webSummaryFirstHook
       ;;
    "webBaseSubsForm")
       webBaseSubsFormFirstHook
       ;;
    "walkObjects")
       walkObjectsFirstHook
       ;;
    "summary")
	       typeset -L20 f1="Host" f2="Setup"
	       print "$f1$f2"
	       echo "----------------------------------------------------"
       ;;
    *)
       return
       ;;
  esac

}

lastSubjectHook() {
  typeset thisDateTag=`date`
  case ${action} in
    "webSummaryUpdate")
       webSummaryLastHook
       ;;
    "webBaseSubsForm")
       webBaseSubsFormLastHook
       ;;
    "summary")
	       echo "----------------------------------------------------"
       ;;
    *)
       return
       ;;
  esac
}


function distList_subjectAnalyze {

  EH_assert [[ "${iv_distList_name}_"  != "_" ]]
  EH_assert [[ "${iv_distList_owners}_" != "_" ]]
  EH_assert [[ "${iv_distList_domainName}_" != "_" ]]

  #echo "${opBinBase}/opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a prUid"
  typeset acctName=`${opBinBase}/opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a prUid`

  if [[ "${acctName}_" == "_" ]] ; then
    EH_problem "qvd- acctName does not exist and/or does not belong in ${opRunHostName}."
    return 1
  else
    opAcctInfoGet ${acctName}
    EH_assert [[ "${opAcct_homeDir}_" != "_" ]]

    distListHomeDir=${opAcct_homeDir}/${iv_distList_name}
    distListDotQmail=${opAcct_homeDir}/.qmail-${iv_distList_name}

    EH_assert [[ "${distListHomeDir}" != "_" ]]

    if [[ "${G_verbose}_" == "verbose_" ]] ; then
      echo "listName=${iv_distList_name}"
      echo "listOwners=${iv_distList_owners}"
      echo "listDomainName=${iv_distList_domainName}"
      
      echo "opAcct_homeDir=${opAcct_homeDir}"

      echo "distListHomeDir=${distListHomeDir}"
      echo "distListDotQmail=${distListDotQmail}"
    fi
  fi
}


function do_summary {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  typeset -L20 v1=${iv_distList_name}
  typeset -L20  v2=${iv_distList_domainName}

  print "${v1}${v2}"
}


function do_listServerInfo {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  ANT_raw "Processing ${subject}"

  G_verbose="verbose"
  distList_subjectAnalyze
}


function walkObjectsFirstHook {
  itemsList=`typeset +f | egrep '^item_'`

  itemDefault_distList

  itemsList=`print -n ${itemsList}`
  print -- "\n${G_myName}: L1 -- ${iv_distList_domainName}: ${itemsList}"
}

function do_walkObjects {
  subjectValidatePrepare

  print -- "${G_myName}: L2 -- ${subject}"
  print "\tlistName -- ${iv_distList_name}"
  print "\tlistArchive -- ${iv_distList_archiver}"
}

function vis_distListVirDomShow {
  itemDefault_distList

  acctName=`${opBinBase}/opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a prUid`

  opDoExit opAcctInfoGet ${acctName}

  print -- "Virtual Domain: ${iv_distList_domainName} -- AcctId: ${acctName}"
  opDoExit mmaQmailVirDomVerify ${iv_distList_domainName}
}


function vis_distListVirDomCreate {
    EH_problem "Backwards compat- Use vis_distListVirDomUpdate"
    vis_distListVirDomUpdate  "$@"
}

function vis_distListVirDomUpdate {
  itemDefault_distList

  opDoComplain opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a verifyAndFix

  acctName=`${opBinBase}/opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a prUid`

  opDoExit opAcctInfoGet ${acctName}

  print -- "Virtual Domain: ${iv_distList_domainName} -- AcctId: ${acctName}"
  opDoExit mmaQmailVirDomUpdate ${iv_distList_domainName} ${acctName}

  opDoExit mmaQmailAddrs.sh -p acctName=${acctName} -s qmailAddrsList_tldRoles -a addrUpdate

  vis_dnsUpdate

  vis_accessControlUpdate
}


function vis_distListVirDomDelete {
  itemDefault_distList

  acctName=`${opBinBase}/opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a prUid`

  opDoExit opAcctInfoGet ${acctName}

  print -- "Virtual Domain: ${iv_distList_domainName} -- AcctId: ${acctName}"

    # NOTYET, this should not be done if all the lists have not been deactivated
    # prior to this (listServerDelete)
  opDoExit mmaQmailVirDomDelete ${iv_distList_domainName}

}

function vis_dnsUpdate {

  opDoExit mmaDnsServerHosts.sh -i hostIsOrigContentServer

  typeset thisSubject=""
  thisSubject=`${G_myName} -p listsDom=${listsDom} -i ls | head -1`
  EH_assert [[ "${thisSubject}_" != "_" ]]

  subject=${thisSubject}
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  # NOTYET, What opRunHostName should be instead?
  #opDoExit opNetCfg_paramsGet ${opRunClusterName} ${opRunHostName}
  # ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}

  #opDoRet mmaDnsEntryMxUpdate ${iv_distList_domainName} ${opNetCfg_ipAddr}
  opDoRet mmaDnsEntryMxUpdate ${iv_distList_domainName} ${opRunHostName}
}


function do_fullVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  EH_problem "NOTYET -- Incomplete"
  return 1
}


function do_fullUpdate {

  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  # First Verify That The Virtual Domain Exists
  # NOTYET, below goes into an infinite loop -- debug later
  #acctName=`${opBinBase}/opAcctUsers.sh -p acctType=programUser -s ${iv_distList_acctRef} -a prUid`
  #opDoComplain mmaQmailAccountAnalyze ${acctName}
  #if [[ $? != 0 ]] ; then
    #vis_distListVirDomCreate
  #fi

  # Create The List
  opDoComplain do_listServerUpdate
  opDoComplain do_textUpdate
  opDoComplain do_listOwnerAssign

  #do_subsUpdate

  opDoComplain do_archiverUpdate

  opDoComplain do_postRestrictionsUpdate

  opDoComplain do_cronEntryUpdate

  opDoComplain do_sendPeriodic

  opDoComplain do_htmlUpdate

  opDoComplain do_webFullUpdateToFile

  return 0
}


function do_fullDelete {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoComplain do_listServerDelete

  opDoComplain do_cronEntryDelete
  return 0
}


function do_listServerCreate {
    EH_problem "Backwards compat- Use do_listServerUpdate"
    do_listServerUpdate "$@"
}

function do_listServerUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  listServerUpdate
}

function listServerUpdate {

  distList_subjectAnalyze

  if [[ -d ${distListHomeDir} ]] ;   then
    echo "${distListHomeDir} exists"
    echo "No action taken for: ${iv_distList_name}"
    return 0
  fi

  # NOTYET, check to see if public or private
  # and use the -P option

  # ezmlm-make  dir dot local host
  opDoExit ${mmaEzmlmCompBinBase}/ezmlm-make ${distListHomeDir} ${distListDotQmail} ${iv_distList_name} ${iv_distList_domainName}

  # NOTYET: Check to see if this is actually needed
  echo "${opAcct_name}-${iv_distList_name}"  > ${distListHomeDir}/inlocal

  #opDoRet chmod 600 ${dotQmailFile}
  opDoRet chown -R ${opAcct_name} ${distListHomeDir}

  return 0
}



do_listServerDelete() {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  distList_subjectAnalyze

  if [[ -d ${distListHomeDir} ]] ;   then
    FN_dirSafeKeep  ${distListHomeDir}
    FN_fileSafeKeep ${distListDotQmail}
    FN_fileSafeKeep ${distListDotQmail}-*
  else
    print -- "${distListHomeDir} does not exist"
  fi


  return 0
}

function do_textUpdate {

  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  distList_subjectAnalyze

  EH_assert [[ "${distListHomeDir}_"  != "_" ]]

  typeset tmp=`typeset +f | grep 'iv_distList_text_top'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_top > ${distListHomeDir}/text/top
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_bottom'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_bottom > ${distListHomeDir}/text/bottom
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_bottom'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_bottom > ${distListHomeDir}/text/bottom
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_subConfirm'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_subConfirm > ${distListHomeDir}/text/sub-confirm
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_subOk'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_subOk > ${distListHomeDir}/text/sub-ok
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_subBad'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_subBad > ${distListHomeDir}/text/sub-bad
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_subNop'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_subNop > ${distListHomeDir}/text/sub-nop
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_unsubOk'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_unsubOk > ${distListHomeDir}/text/unsub-ok
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_unsubBad'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_unsubBad > ${distListHomeDir}/text/unsub-bad
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_unsubConfirm'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_unsubConfirm > ${distListHomeDir}/text/unsub-confirm
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_unsubNop'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_unsubNop > ${distListHomeDir}/text/unsub-nop
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_bounceBottom'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_bounceBottom > ${distListHomeDir}/text/bounce-bottom
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_bounceNum'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_bounceNum > ${distListHomeDir}/text/bounce-num
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_bounceProbe'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_bounceProbe > ${distListHomeDir}/text/bounce-probe
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_bounceWarn'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_bounceWarn > ${distListHomeDir}/text/bounce-warn
  fi

  typeset tmp=`typeset +f | grep 'iv_distList_text_getBad'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_text_getBad > ${distListHomeDir}/text/get-bad
  fi
}


# --- LIST SERVER RESTRICTIONS ---
# ${G_myName} -p listsDom=${oneDomain} -i accessControlUpdate
# ${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a postRestrictionsVerify
# ${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a postRestrictionsUpdate
# ${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a postRestrictionsDelete

function vis_accessControlUpdate {

  targetSubject=itemSpecial_allowDistList
  # verify that function exists
  ${targetSubject}
  listServerUpdate

  targetSubject=itemSpecial_denyDistList
  # NOTYET, verify that function exists
  ${targetSubject}
  listServerUpdate

  itemDefault_distList

  typeset allowAddresses=${ivg_distList_allowAddreses[@]}
  typeset denyAddresses=${ivg_distList_denyAddreses[@]}

  typeset thisItem=""
  for thisItem in  ${allowAddresses} ; do
    itemSpecial_allowDistList
    subsUpdate ${thisItem}
  done

  for thisItem in  ${denyAddresses} ; do
    itemSpecial_denyDistList
    subsUpdate ${thisItem}
  done
}


function do_postRestrictionsVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  EH_problem "NOTYET"
  return 1
}

function do_postRestrictionsUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  typeset issubnProgram="${mmaEzmlmCompBase}/bin/ezmlm-issubn"
  #
  opDoRet distList_subjectAnalyze

  typeset allowHomeDir=${opAcct_homeDir}/allow
  typeset denyHomeDir=${opAcct_homeDir}/deny

  EH_assert [[ -d ${allowHomeDir} ]]
  EH_assert [[ -d ${denyHomeDir} ]]

  typeset distListEditor="${distListHomeDir}/editor"

  FN_lineIsInFile  "ezmlm-issubn" ${distListEditor}

  if [[ $? == 0 ]] ; then
    print -- "ezmlm-issubn already in ${distListEditor} -- exitCode=$?"
    return 0
  fi

  FN_fileSafeCopy ${distListEditor} ${distListEditor}.${dateTag}

  sed -e '2,$d'  ${distListEditor}.${dateTag} > ${distListEditor}

  print -- "|${issubnProgram} '${distListHomeDir}' '${allowHomeDir}' || ( echo \"You are not allowed to post to ${iv_distList_name}@${iv_distList_domainName} list\"; exit 100 )" >> ${distListEditor}

  print -- "|/var/qmail/bin/except  ${issubnProgram}  '${denyHomeDir}' || ( echo \"You are denied permission to post to ${iv_distList_name}@${iv_distList_domainName} list\"; exit 100 )" >> ${distListEditor}

  sed -e '1d'  ${distListEditor}.${dateTag} >> ${distListEditor}

  ls -l ${distListDotQmail}
  #cat ${distListDotQmail}

  itemSpecial_allowDistList
  subsUpdate ${iv_distList_postMemeber}

  return 0
}

function do_postRestrictionsDelete {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  EH_problem "NOTYET"
  return 1
}


# ${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a disable
# ${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a restore


function do_disable {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  EH_assert [[ -d ${distListHomeDir} ]]

  typeset distListEditor="${distListHomeDir}/editor"

  FN_fileSafeCopy ${distListEditor} ${distListEditor}.SAVED

  cp /dev/null ${distListEditor}

  typeset thisItem=""
  for thisItem in  ${iv_distList_owners} ; do
    FN_lineAddToFile "${thisItem}" "| forward ${thisItem}" ${distListEditor}
  done

  ls -l ${distListDotQmail}
  cat ${distListDotQmail}
}


function do_restore {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  EH_assert [[ -d ${distListHomeDir} ]]

  typeset distListEditor="${distListHomeDir}/editor"

  FN_fileSafeCopy ${distListEditor}.SAVED  ${distListEditor}.${dateTag}

  opDoComplain mv  ${distListEditor}.SAVED ${distListEditor}

  ls -l ${distListDotQmail}
  cat ${distListDotQmail}
}

#${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a snapShotStore
#${G_myName} -p listsDom=${oneDomain} -s ${oneDistList} -a snapShotRestore

function do_snapShotStore {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  EH_assert [[ -d ${distListHomeDir} ]]

  EH_problem "NOTYET"
  return 1
}


function do_snapShotRestore {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  EH_assert [[ -d ${distListHomeDir} ]]

  EH_problem "NOTYET"
  return 1
}



function do_subsUpdate {
  if [[ $# -lt 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  #subjectValidatePrepare

  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  subsUpdate "$@"
}

function subsUpdate {
  if [[ $# -lt 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  opDoRet distList_subjectAnalyze

  typeset thisOne=""
  for thisOne in "$@" ; do
    print -- "Subs Adding ${thisOne} to distListHomeDir=${distListHomeDir}"

    opDoExit ${mmaEzmlmCompBinBase}/ezmlm-sub  ${distListHomeDir} ${thisOne}
  done

  return 0
}


function do_subsDelete {
  if [[ $# -ne 1 ]] ; then
    EH_problem "Expected 1 arg, got $#"
    return 1
  fi

  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  print -- "UnSubs Removing $1 from distListHomeDir=${distListHomeDir}"

  opDoExit ${mmaEzmlmCompBinBase}/ezmlm-unsub  ${distListHomeDir} ${1}
}


function do_subsShow {
  subjectValidatePrepare

  #targetSubject=item_${subject}
  #subjectValidVerify
  #${targetSubject}

  opDoRet distList_subjectAnalyze

  print -- "Subs Listing: ${subject} -- ${iv_distList_name} -- ${opAcct_name}"

  opDoExit ${mmaEzmlmCompBinBase}/ezmlm-list  ${distListHomeDir}
}


function do_sendPeriodic {
  typeset tmpContentFile=""

  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  mmaQmailMsgDefaults

  mmaQmailMsg_dashN="_nil"
  #mmaQmailMsg_dashN="_t"

  #mmaQmailMsg_envelopeSpecMethod="ENVIRONMENT"
  mmaQmailMsg_envelopeSpecMethod="ARGUMENT"

  mmaQmailMsg_envelopeAddr="${iv_distList_postMemeber}"
  mmaQmailMsg_fromAddr="${iv_distList_name}-owner@${iv_distList_domainName}"
  mmaQmailMsg_toAddrList="${iv_distList_name}@${iv_distList_domainName}"
  #mmaQmailMsg_ccAddrList=""
  mmaQmailMsg_subjectLine="ADMINISTRATIVE NOTE: ${iv_distList_name} Periodic List Information Update"

  tmpContentFile=/tmp/${G_progName}.$$

  mmaQmailMsg_contentFile="${tmpContentFile}"  # (stdin, later possible)

  cat > ${tmpContentFile} << _EOF_

This is an administrative note which is periodicaly posted to
the ${mmaQmailMsg_toAddrList} list.

This list is being managed by the ezmlm software.

To receive instructions for subscribing or unsubscribing to
this list, send a message to ${iv_distList_name}-help@${iv_distList_domainName}.

To contact the person responsible for maintaining this
list, send your message to ${iv_distList_name}-owner@${iv_distList_domainName}.

You can access archives of this mailing list through
http://${iv_distList_webDomainName}

The purpose and scope of this list is also described on that web page.

_EOF_

  mmaQmailMsgInject

  #cat ${tmpContentFile}
  FN_fileRmIfThere  ${tmpContentFile}
}


function do_cronEntryShow {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  opDoComplain opCron_show ${opAcct_name} pretty ${subject}
  return 0
}


function do_cronEntryVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  opDoComplain opCron_show ${opAcct_name} pretty

  EH_problem "Now verify that items file matches cron entry"

  return 0
}

function do_cronEntryUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  # Put this in the explicit user's cronTabFile
  # To send him an email every so often

  typeset sendPeriodicCmd="${opBinBase}/${G_myName} -p listsDom=${listsDom} -s ${subject} -a sendPeriodic"


  TM_trace 7 " Crontab line: ${sendPeriodicCmd}"
  opDoComplain opCron_periodicSched "Set" ${opAcct_name} ${iv_distList_basicCronPeriod} ${sendPeriodicCmd}
}


function do_cronEntryDelete {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  opDoComplain opCron_removeAll ${opAcct_name}
  return 0
}


function do_listOwnerAssign {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoRet distList_subjectAnalyze

  typeset ownerFile="${distListHomeDir}/owner"
  FN_fileSafeCopy ${ownerFile} ${ownerFile}.${dateTag}

  typeset thisItem=""
  for thisItem in  ${iv_distList_owners} ; do
    FN_lineAddToFile "${thisItem}" "| forward ${thisItem}" ${ownerFile}
  done

  #opDoExit cat ${ownerFile}
  return 0
}


function do_archiverVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  opDoComplain mmaQmailAddrs.sh -p FQMA="${iv_distList_archiver}" -i addrCtlFileShow

  EH_problem "NOTYET -- Incomplete"
  return 1
}


function do_archiverUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}


  typeset domainPart=`MA_domainPart ${iv_distList_archiver}`
  typeset localPart=`MA_localPart ${iv_distList_archiver}`

  EH_assert [[ "${domainPart}_" != "_" ]]
  EH_assert [[ "${localPart}_" != "_" ]]

  typeset htmlUpdateCmd="${opBinBase}/${G_myName} -p listsDom=${listsDom} -s ${subject} -a htmlUpdate"
  typeset mboxFile="${localPart}.mmaInbox"

  print "${iv_distList_archiver} ${domainPart} ${localPart}"

  opDoComplain mmaQmailAddrs.sh -p FQMA="${iv_distList_archiver}" -p mbox="${mboxFile}" -p progs="${htmlUpdateCmd}" -i addrUpdate
  #eval mmaQmailAddrs.sh -p FQMA="${iv_distList_archiver}" -p mbox=Mbox -p progs=\""${htmlUpdateCmd}"\" -i addrUpdate

  opDoComplain mmaQmailAddrs.sh -p FQMA="${iv_distList_archiver}" -i addrCtlFileShow


  # Add the archiver address to the list
  do_subsUpdate "${iv_distList_archiver}"

  do_subsShow

  return 0
}


function do_archiverDelete {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  EH_problem "NOTYET"
  return 1
}

function do_htmlUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  mmaWebFqdnAnalyze ${iv_distList_webDomainName}

  typeset outHtmlBaseDir="${mmaWeb_htdocsBase}/mailingLists/${iv_distList_name}/html/current"

  FN_dirCreatePathIfNotThere ${outHtmlBaseDir}

  opDoComplain mmaQmailFqmaAnalyze ${iv_distList_archiver}

  typeset inFolderBaseDir=`FN_dirsPart ${mmaQmail_dotQmailFile}`
  typeset mailFolder="${inFolderBaseDir}/${mmaQmail_mboxFiles}"


  umask 22
  
  if test -f ${outHtmlBaseDir}/maillist.html ; then
    # Then we just need to update it
    if [[ "${G_verbose}_" == "verbose_" ]] ; then
	opDoExit ${MHONARC} -outdir ${outHtmlBaseDir} -add "${mailFolder}" # > /dev/null 2>&1
    else
        # NOTYET, need more testing on how to work with /dev/null 2>&1
	opDoExit ${MHONARC} -outdir ${outHtmlBaseDir} -add "${mailFolder}" # > /dev/null 2>&1
    fi
  else
    # We need to create it
    ${MHONARC} -outdir ${outHtmlBaseDir}  "${mailFolder}" # > /dev/null 2>&1
  fi

  # NOTYET, must be done woth opDoAtAs
  chown ${mmaQmail_acctName} ${outHtmlBaseDir}
  chown ${mmaQmail_acctName} ${outHtmlBaseDir}/*
  # NOTYET, chmod too
}

function vis_htmlUpdateSpecial {

  #itemDefault_distList
  opParamMandatoryVerify
  #mmaWebFqdnAnalyze ${iv_distList_webDomainName}

  typeset outHtmlBaseDir="${specificOutHtmlBaseDir}"
  FN_dirCreatePathIfNotThere ${outHtmlBaseDir}

  EH_assert [[ -a ${specificMailFolder} ]]
  typeset mailFolder="${specificMailFolder}"


  umask 22
  
  if test -f ${outHtmlBaseDir}/maillist.html ; then
    # Then we just need to update it
    if [[ "${G_verbose}_" == "verbose_" ]] ; then
	opDoExit ${MHONARC} -outdir ${outHtmlBaseDir} -add "${mailFolder}" # > /dev/null 2>&1
    else
	opDoExit ${MHONARC} -outdir ${outHtmlBaseDir} -add "${mailFolder}" > /dev/null 2>&1
    fi
  else
    # We need to create it
    ${MHONARC} -outdir ${outHtmlBaseDir}  "${mailFolder}" # > /dev/null 2>&1
  fi

  # NOTYET, must be done woth opDoAtAs
  #chown ${mmaQmail_acctName} ${outHtmlBaseDir}
  #chown ${mmaQmail_acctName} ${outHtmlBaseDir}/*
  # NOTYET, chmod too
}

do_htmlRebuild () {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  EH_problem "$0 being phased out. htmlUpdate does the job"

  return 1
}

function do_webFullUpdateToFile {
    do_webSummaryUpdateToFile
    do_webDescUpdateToFile
    do_webBaseSubsFormToFile
}

function do_webSummaryUpdateToFile {
  itemDefault_distList
#   targetSubject=item_${subject}
#   subjectValidVerify
#   ${targetSubject}

  mmaWebFqdnAnalyze ${iv_distList_webDomainName}

  typeset destDir=${mmaWeb_htdocsBase}/mailingLists
  FN_dirCreatePathIfNotThere ${destDir}
  typeset destFile=${destDir}/index.html
  FN_fileSafeKeep ${destFile}


  ${G_myName} -p listsDom=${listsDom} -s all -a webSummaryUpdate > ${destFile}
}


function webSummaryFirstHook {
 itemDefault_distList
cat << _EOF_
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
   <TITLE>${iv_distList_httpTitle}</TITLE>
</HEAD>

<BODY BGCOLOR="#BFDFFF">

<CENTER><H1>${iv_distList_httpTitle}</H1></CENTER>

<P>
<HR>

_EOF_
iv_descriptionFunction
}


function webSummaryLastHook {
  typeset thisDateTag=`date`
cat << _EOF_
<P>
<HR>

<CENTER>
<H4>
<B>
[<A HREF="http://${iv_distList_webDomainName}">Home Page</A>]
</B>
</H4>
</CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>
Product and service names profiled herein are trademarks and service marks of their respective companies.
</FONT></ADDRESS></CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>Please send comments or problems about this web site to <A HREF="mailto:webmaster@${iv_distList_webDomainName##www.}" TITLE="webmaster@${iv_distList_webDomainName##www.}">webmaster@${iv_distList_webDomainName##www.}</A></FONT></ADDRESS></CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>
Last Updated:  ${thisDateTag}
</FONT></ADDRESS></CENTER>

<P>
<BR><HR>
<ADDRESS>
 
</ADDRESS>
</BODY>
</HTML>
_EOF_
}

function do_webSummaryUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  typeset thisDateTag=`date`

  # Create the html page that describes and accesses the web page.
  mmaWebFqdnAnalyze ${iv_distList_webDomainName}
  typeset destFile=${mmaWeb_htdocsBase}/mailingLists

  cat  << _EOF_
<DL>
<DD><P>
<DT><STRONG>${iv_distList_name}@${iv_distList_domainName}:</STRONG>&nbsp&nbsp&nbsp
<A HREF="/mailingLists/${iv_distList_name}/listDesc.html">List Description</A>&nbsp&nbsp&nbsp
_EOF_

if [[ "${iv_distList_archiving}_" == "yes_" ]] ; then
if [[ "${iv_distList_archiving_previousYear[@]}_" != "_" ]] ; then
  cat  << _EOF_
Mailing List Archives -- <A HREF="/mailingLists/${iv_distList_name}/html/current/maillist.html">Current</A>
_EOF_
typeset thisYear=""
for thisYear in ${iv_distList_archiving_previousYear[@]} ; do
  cat  << _EOF_
&nbsp&nbsp<A HREF="/mailingLists/${iv_distList_name}/html/${thisYear}/maillist.html">${thisYear}</A>
_EOF_
done
  cat  << _EOF_
</DL>
_EOF_
else
  cat  << _EOF_
<A HREF="/mailingLists/${iv_distList_name}/html/current/maillist.html">Mailing List Archives</A>
</DL>
_EOF_
fi
    else
  cat  << _EOF_
</DL>
_EOF_
    fi

}

function do_webDescUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  typeset thisDateTag=`date`
  # Create the html page that describes and accesses the web page.

  cat  << _EOF_
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
   <TITLE>Information About ${iv_distList_name}@${iv_distList_domainName}</TITLE>
</HEAD>

<BODY BGCOLOR="#BFDFFF">

<CENTER><H1>Information About ${iv_distList_name}@${iv_distList_domainName}</H1></CENTER>

<P ALIGN="LEFT"></P>
</DIV>
<P>
<HR>

<P>
<DL>
<DD><P>
<DT><STRONG><B>List Title: </B></STRONG>
<DD> ${iv_distList_name}@${iv_distList_domainName}

<P>
<DT><STRONG><B>List Description: </B></STRONG>
<DD>
_EOF_

iv_descriptionFunction

  cat  << _EOF_
<P>
<DT><STRONG><B>Joining The Mailing List: </B></STRONG>
<DD>You can join
        this mailing list by one of the subscription methods listed
        below under <A HREF="listDesc.html#subs-command">Subscription Commands</A>.

<P>
Please read through the archive before posting to the mailing
        list, since your topic of interest may have already been
        discussed.
_EOF_

  typeset tmp=`typeset +f | grep 'iv_distList_addObligation'`
  if [[ "${tmp}" != "" ]] ;   then
    iv_distList_addObligation
  fi

  cat  << _EOF_
<P>
<DT><STRONG><B>List Owner: </B></STRONG>
<DD><A HREF="mailto:${iv_distList_owner}">${iv_distList_owner}</A>

<P>
<DT><STRONG><B>Mailing List Maintainer Software: </B></STRONG>
<DD>This
        list is being maintained by EZMLM/IDX software.

The latest manual can be accessed at
        <A HREF="http://www.ezmlm.org">EZMLM.org</A>.

<P>
<DT><STRONG><B>Mailing List Archives: </B></STRONG>
<DD>This mailing list
        is archived on a daily basis.  You can access the archives
        through the <A HREF="html/current/maillist.html">web
        index</A>.

<P>
<DT><STRONG><B>Address for Posting To The Mailing List: </B></STRONG>
<DD>${iv_distList_name}@${iv_distList_domainName}

<P>
<DT><STRONG><B>Mailing List Posting Restrictions: </B></STRONG>
<DD>None

<P>
<DT><STRONG><B>Address for Mailing List Commands: </B></STRONG>
<DD>Requests for help and description of available commands should
        be sent to <A HREF="mailto:${iv_distList_name}-help@${iv_distList_domainName}">${iv_distList_name}-help@${iv_distList_domainName}</A>

<P>
<DT><STRONG><B><A NAME="subs-command">&#160;</A> Subscription Commands:</B> </STRONG>
<DD><P>
<UL>
<LI>
Web-Based: <A HREF="/mailingLists/mailingListRequestForm.html">Subscribe / Unsubscribe</A>
<P>
<LI>Email-Based: <A HREF="mailto:${iv_distList_name}-subscribe@${iv_distList_domainName}">Subscribe</A>-<A "HREF="mailto:${iv_distList_name}-unsubscribe@${iv_distList_domainName}">Unsubscribe</A>.
</UL>
<P>
</DL>
<P>
<HR>

<CENTER>
<H4>
<B>
[<A HREF="http://${iv_distList_webDomainName}">Home Page</A>]
</B>
</H4>
</CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>
Product and service names profiled herein are trademarks and service marks of their respective companies.
</FONT></ADDRESS></CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>Please send comments or problems about this web site to <A HREF="mailto:${iv_distList_owner}" TITLE="${iv_distList_owner}">${iv_distList_owner}</A></FONT></ADDRESS></CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>
Last Updated:  ${thisDateTag}
</FONT></ADDRESS></CENTER>

<P>
<BR><HR>
<ADDRESS>

</ADDRESS>
</BODY>
</HTML>
_EOF_
}

function do_webDescUpdateToFile {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  mmaWebFqdnAnalyze ${iv_distList_webDomainName}

  typeset destDir=${mmaWeb_htdocsBase}/mailingLists/${iv_distList_name}
  FN_dirCreatePathIfNotThere ${destDir}
  typeset destFile=${destDir}/listDesc.html
  FN_fileSafeKeep ${destFile}

  ${G_myName} -p listsDom=${listsDom} -s ${subject} -a webDescUpdate > ${destFile}
}

function do_webBaseSubsForm {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  cat  << _EOF_
<INPUT TYPE="checkbox" NAME="${subject}_subscribe" VALUE="${iv_distList_name}@${iv_distList_domainName}" CHECKED>${iv_distList_name}-subscribe@${iv_distList_domainName}  <INPUT TYPE="checkbox" NAME="${subject}_unsubscribe" VALUE="${iv_distList_name}@${iv_distList_domainName}" UNCHECKED>${iv_distList_name}-unsubscribe@${iv_distList_domainName}
_EOF_
}

function webBaseSubsFormFirstHook {

  cat  << _EOF_
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
   <TITLE>Mailing List Request Form</TITLE>
</HEAD>
<BODY BGCOLOR="#BFDFFF">

<H2 ALIGN=CENTER>Mailing List Request Form</H2>

<P>
<HR></P>

<P><FORM method="POST" action="/cgi-bin/mailing-list-request.pl"></P>

<PRE>
<P><B>CONTACT INFORMATION</B></P>
            First name:&nbsp;<INPUT NAME="firstName" VALUE="" SIZE=45>
             Last name:&nbsp;<INPUT NAME="lastName" VALUE="" SIZE=45>
          Company name:&nbsp;<INPUT NAME="companyName" VALUE="" SIZE=45>
   Your e-mail address:&nbsp;<INPUT NAME="emailAddress" VALUE="" SIZE=45>
   
I want to subscribe/unsubscribe to:  
_EOF_
}

function webBaseSubsFormLastHook {

  cat  << _EOF_

<P>Submit this request by clicking on the SUBMIT button.  

<P><INPUT TYPE=submit value="SUBMIT">                        <INPUT TYPE=reset value="RESET">
</P>
</PRE>

<P>
<HR></FORM></P>

</BODY>
</HTML>
_EOF_
}

function do_webBaseSubsFormToFile {

  itemDefault_distList

  mmaWebFqdnAnalyze ${iv_distList_webDomainName}
  #print "mmaWeb_httpBase=${mmaWeb_httpBase}"

  typeset destDir=${mmaWeb_htdocsBase}/mailingLists
  FN_dirCreatePathIfNotThere ${destDir}
  typeset destFile=${destDir}/mailingListRequestForm.html
  FN_fileSafeKeep ${destFile}


  ${G_myName} -p listsDom=${listsDom} -s all -a webBaseSubsForm > ${destFile}
}

function vis_webBaseProcessScript {

  itemDefault_distList

  itemsList=`typeset +f | egrep '^item_'` 

  cat  << _EOF_
#!/opt/public/mma/bin/perl

use CGI;

my \$query = new CGI;

&do_html_preamble();

#
# get args passed to script
#
my \$cookie = \$ENV{'HTTP_COOKIE'};
my \$emailAddress = \$query->param("emailAddress");
my \$firstName = \$query->param("firstName");
my \$lastName = \$query->param("lastName");
my \$companyName = \$query->param("companyName");
my \$trace_file = "/tmp/mailing-list-request.\$\$";
_EOF_

  integer numOfList=0
  for i in ${itemsList} ;  do    
    ${i}
    numOfList=`expr $numOfList + 1`
    cat  << _EOF_
my \$subscribe${numOfList} = \$query->param("${i##item_}_subscribe");
my \$unsubscribe${numOfList} = \$query->param("${i##item_}_unsubscribe");
_EOF_
  done

  cat  << _EOF_
my \$fromAddress = "webmaster\@${iv_distList_domainName}";
my \$listManagerDomain = "${iv_distList_domainName}";

_EOF_

  integer count=1
  typeset subscribeToCmd="" unsubscribeToCmd=""
  while (( $count <= $numOfList )) ; do
    subscribeToCmd="\$subscribe${count} ${subscribeToCmd}"
    unsubscribeToCmd="\$unsubscribe${count} ${unsubscribeToCmd}"
    count=`expr $count + 1`
  done

  #print "subscribeToCmd=${subscribeToCmd}"
  #print "unsubscribeToCmd=${unsubscribeToCmd}"


  cat  << _EOF_
my \$command_line = "${opBinBase}/mmaQmailListsWebProc.sh  -p fromAddress=\"\${fromAddress}\" -p listManagerDomain=\"\${listManagerDomain}\" -p subjectField=\"Mailing List Request Form\" -p listSubscriberAddress=\"\${emailAddress}\" -p subscribeTo=\"$subscribeToCmd\" -p unsubscribeTo=\"$unsubscribeToCmd\" -i process 1> \$trace_file 2>&1";
_EOF_

cat  << _EOF_

\$return_value = system(\$command_line);

if ( \$return_value == 0 ) {
    &do_ok();
} else {
    &do_barf();
    print "<p>command line is \$command_line<br>";
    print "<p>return value is \$return_value<br>";
    print "<p>check /tmp/mailing-list-request.pl.trace on webserver for more info.<br>";
}

&do_html_postamble();

exit 0;

# -------------------------------------------------------------------
# do_ok()
# -------------------------------------------------------------------

sub do_ok {

    print '<H4 ALIGN=LEFT> Thank You. Your request has been sent for processing.</H4>';
    print '<H4 ALIGN=LEFT>The mailing list that you subscribe:</H4>';
_EOF_

   for i in ${itemsList} ;  do    
     ${i}
     cat  << _EOF_
    print \$query->param("${i##item_}_subscribe"); 
    print '<H4 ALIGN=LEFT></H4>';
_EOF_
   done

     cat  << _EOF_

    print '<H4 ALIGN=LEFT>The mailing list that you unsubscribe:</H4>';
_EOF_
   for i in ${itemsList} ;  do    
     ${i}
     cat  << _EOF_
    print \$query->param("${i##item_}_unsubscribe"); 
    print '<H4 ALIGN=LEFT></H4>';
_EOF_
   done
   cat  << _EOF_
}

# -------------------------------------------------------------------
# do_barf() -- page to return when subscriber is not valid
# -------------------------------------------------------------------

sub do_barf {

    print '<H2 ALIGN=CENTER>Error Sending Message.</H2>';

    print "cookie is ";
    print \$ENV{'HTTP_COOKIE'};
    print \$query->dump();
}

# -------------------------------------------------------------------
# do_html_preamble()
# -------------------------------------------------------------------
sub do_html_preamble {

    print \$query->header("text/html");

    print '
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
   <TITLE>Mailing List Request Form</TITLE>
</HEAD>
<BODY BGCOLOR="#BFDFFF">

<H1 ALIGN=CENTER>${iv_distList_httpTitle}</H1>

<H2 ALIGN=CENTER>SUBMISSION RESULTS</H2>

<P>
<HR WIDTH="100%"></P>';

}

# -------------------------------------------------------------------
# do_html_postamble()
# -------------------------------------------------------------------
sub do_html_postamble() {

print '
<P>
<HR>

<CENTER>
<H4>
<B>
[<A HREF="http://${iv_distList_webDomainName}">Home Page</A>]
</B>
</H4>
</CENTER>

<CENTER>
<ADDRESS>
<FONT SIZE=2>Please send comments or problems about this web site to <A HREF="mailto:webmaster@${iv_distList_domainName}" TITLE="webmaster@${iv_distList_domainName}">webmaster@${iv_distList_domainName}</A></FONT></ADDRESS></CENTER>

<HR WIDTH="100%"></P>

</BODY>
</HTML>
';
}

_EOF_
}

function vis_webBaseProcessScriptToFile {

  itemDefault_distList

  mmaWebFqdnAnalyze ${iv_distList_webDomainName}

  typeset destDir=${mmaWeb_cgiBase}
  FN_dirCreatePathIfNotThere ${destDir}
  typeset destFile=${destDir}/mailing-list-request.pl
  FN_fileSafeKeep ${destFile}

  ${G_myName} -p listsDom=${listsDom} -i webBaseProcessScript > ${destFile}
  chmod 777 ${destFile}
}

function do_schemaVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  distList_subjectAnalyze
  return 0
}

