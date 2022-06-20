#!/bin/bash
#!/bin/bash

typeset RcsId="$Id: mmaQmailOldHosts.sh,v 1.1.1.1 2016-06-08 23:49:52 lsipusr Exp $"



# (replace-string "ivd_qmailFile_locals" "ivd_qmailSendFile_locals" nil)

if [ "${loadFiles}X" == "X" ] ; then
     seedSubjectAction.sh -l $0 "$@"
     exit $?
fi

G_humanUser=TRUE

. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh
. ${opBinBase}/mmaDnsLib.sh
. ${opBinBase}/opInetdLib.sh

setBasicItemsFiles mmaQmailOldHostItems

opNetCfg_paramsGet ${opRunClusterName} ${opRunHostName}
# ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}

function vis_examples {
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""
  typeset doLibExamples=`doLibExamplesOutput ${G_myName}`
 cat  << _EOF_
EXAMPLES:
${doLibExamples}
--- INFORMATION ---
${G_myName} ${extraInfo} -s all -a summary
${G_myName} ${extraInfo} -s ${opRunHostName} -a describe
${G_myName} ${extraInfo} -s ${opRunHostName} -a serverType
${G_myName} ${extraInfo} -s all -a walkObjects
${G_myName} ${extraInfo} -s ${opRunHostName} -a walkObjects
${G_myName} ${extraInfo} -s ${opRunHostName} -a acctAddrsFqmaShow
--- SERVER ACTIONS FULL ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a configure
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullVerify
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullUpdate
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullDelete
--- NETLISTENER ACTIONS ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a netListenerEnable
${G_myName} ${extraInfo} -s ${opRunHostName} -a netListenerDisable
${G_myName} ${extraInfo} -s ${opRunHostName} -a netListenerShow
${G_myName} ${extraInfo} -s ${opRunHostName} -a netListenerVerify
--- SERVER ACTIONS SPECIFIC ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a distListUpdate
${G_myName} ${extraInfo} -s ${opRunHostName} -a distListDelete
${G_myName} ${extraInfo} -s ${opRunHostName} -a distListCronsUpdate
${G_myName} ${extraInfo} -s ${opRunHostName} -a distListCronsDelete
--- ALL SEREVER ACCOUNTS AND ADDRESSES UPDATES: (Main And VirDoms)
${G_myName} ${extraInfo} -s ${opRunHostName} -a acctUpdate
${G_myName} ${extraInfo} -s ${opRunHostName} -a acctAddrsUpdate
--- DNS MANIPULATION ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a dnsUpdate
${G_myName} ${extraInfo} -s ${opRunHostName} -a dnsDelete
_EOF_
}


function vis_help {
  cat  << _EOF_
  DESCRIPTION
       Configure the mail system according to specified host parameters.

       gcf_ Generate Configuration Files
_EOF_
  return 0
}

noArgsHook() {
  vis_examples
}


firstSubjectHook() {
  case ${action} in
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
  case ${action} in
    "summary")
	       echo "----------------------------------------------------"
       ;;
    *)
       return
       ;;
  esac
}

function do_summary {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}
  typeset -L10 v1=${iv_qmailHost}
  typeset -L20  v2=${iv_qmailSetup}
  typeset -L20  v3=${iv_qmailHost_mainDomRef}
  typeset -L80  v4=${iv_qmailHost_VirDomsRefList[@]}

  print "${v1}${v2}${v3}${v4}"
}

function do_walkObjects {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  print -- "\n${G_myName}: L1 -- item_${subject}: ${iv_qmailHost} ${iv_qmailSetup} ${iv_qmailHost_mainDomRef} ${iv_qmailHost_VirDomsRefList[@]}"

  # Main Domain Information
  print -- "${G_myName}: L2 -- ${iv_qmailHost_mainDomRef}"
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a walkObjects

  # Each Of The Virtual Domain Information
  print -- "${G_myName}: L2 -- ${iv_qmailHost_VirDomsRefList[@]}"
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_VirDomsRefList[@]} ; do
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a walkObjects
  done

  # Each of the mailing lists
  print -- "${G_myName}: L2 -- ${iv_qmailHost_distListsRefList[@]}"
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_distListsRefList[@]} ; do
    opDoRet mmaQmailLists.sh -p listsDom=${thisOne} -s all -a walkObjects
  done

}


function do_serverType {
  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? == 0 ]] ; then
    ${targetSubject}
    if [[ ${iv_qmailSetup} == "" ]] ; then
      EH_problem ""
      return 1
    fi
    print "${iv_qmailSetup}"
    return 0
  else
    print "noService"
    return 1
  fi
}


# gcf_  Generate Configuration File

function gcf_qmailGlobals {
  # QMAIL Global control files

  continueAfterThis

  # me
  ivd_qmailGlobalFile_me=${iv_qmailSenderDomainPart}

  # _DONT_ means don't create that file
  if [ "${ivd_qmailGlobalFile_me}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailGlobalFile_me=${ivd_qmailGlobalFile_me}"
    echo "${ivd_qmailGlobalFile_me}" > ${qmailControlBaseDir}/me
    chmod 644 ${qmailControlBaseDir}/me
  fi
}


function gcf_qmailInject {
  #  QMAIL-INJECT control files
  
  continueAfterThis

  # defaulthost
  ivd_qmailInjectFile_defaulthost=${iv_qmailSenderDomainPart}

  if [ "${ivd_qmailInjectFile_defaulthost}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_defaulthost=${ivd_qmailInjectFile_defaulthost}"
    echo "${ivd_qmailInjectFile_defaulthost}" > ${qmailControlBaseDir}/defaulthost
    chmod 644 ${qmailControlBaseDir}/defaulthost
  fi

  # defaultdomain
  ivd_qmailInjectFile_defaultdomain=${iv_qmailSenderDomainPart}

  if [ "${ivd_qmailInjectFile_defaultdomain}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_defaultdomain=${ivd_qmailInjectFile_defaultdomain}"
    echo "${ivd_qmailInjectFile_defaultdomain}" > ${qmailControlBaseDir}/defaultdomain
    chmod 644 ${qmailControlBaseDir}/defaultdomain
  fi

  # idhost
  ivd_qmailInjectFile_idhost="${iv_qmailMsgIdTag}.${iv_qmailSenderDomainPart}"

  if [ "${ivd_qmailInjectFile_idhost}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_idhost=${ivd_qmailInjectFile_idhost}"
    echo "${ivd_qmailInjectFile_idhost}" > ${qmailControlBaseDir}/idhost
    chmod 644 ${qmailControlBaseDir}/idhost
  fi

  # plusdomain
  ivd_qmailInjectFile_plusdomain=${iv_qmailSenderDomainPart}

  if [ "${ivd_qmailInjectFile_plusdomain}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_plusdomain=${ivd_qmailInjectFile_plusdomain}"
    echo "${ivd_qmailInjectFile_plusdomain}" > ${qmailControlBaseDir}/plusdomain
    chmod 644 ${qmailControlBaseDir}/plusdomain
  fi
}

function gcf_qmailSend {
  #  QMAIL-SEND control files
    #set -x

  continueAfterThis

  # locals
  ivd_qmailSendFile_locals=${iv_qmailLocalDelivery}

  # locals
  if [ "${ivd_qmailSendFile_locals}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailSendFile_locals=${ivd_qmailSendFile_locals}"
    echo "${ivd_qmailSendFile_locals}" > ${qmailControlBaseDir}/locals
    chmod 644 ${qmailControlBaseDir}/locals
  fi
}


function gcf_qmailRemote {
  #  QMAIL-REMOTE control files

  continueAfterThis

  # helohost
  ivd_qmailRemoteFile_helohost="${iv_qmailMsgIdTag}.${iv_qmailSenderDomainPart}"

  if [ "${ivd_qmailRemoteFile_helohost}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailRemoteFile_helohost=${ivd_qmailRemoteFile_helohost}"
    echo "${ivd_qmailRemoteFile_helohost}" > ${qmailControlBaseDir}/helohost
    chmod 644 ${qmailControlBaseDir}/helohost
  fi


  # smtproutes
  ivd_qmailRemoteFile_smtproutes=${iv_qmailSmtpRoutes}

  if [ "${ivd_qmailRemoteFile_smtproutes}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailRemoteFile_smtproutes=${ivd_qmailRemoteFile_smtproutes}"
    print "${ivd_qmailRemoteFile_smtproutes}" > ${qmailControlBaseDir}/smtproutes
    chmod 644 ${qmailControlBaseDir}/smtproutes
  fi
}

function gcf_qmailSmtpd {
  #  QMAIL-SMTPD control files

  continueAfterThis

    #set -x

  # rcpthosts
  ivd_qmailSmtpdFile_rcpthosts="${iv_qmailAcceptDestinedTo}"

  if [ "${ivd_qmailSmtpdFile_rcpthosts}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailSmtpdFile_rcpthosts=${ivd_qmailSmtpdFile_rcpthosts}"
    echo "${ivd_qmailSmtpdFile_rcpthosts}" > ${qmailControlBaseDir}/rcpthosts
    chmod 644 ${qmailControlBaseDir}/rcpthosts
  fi
}


function do_dnsUpdate {

  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? == 0 ]] ; then
    ${targetSubject}
  else
    print -- "$0: DNS Hook Skipped for ${subject}"
    return 1
  fi


  continueAfterThis

  opDoExit mmaDnsServerHosts.sh -i hostIsOrigContentServer
  # NOTYET, opDoRetNow

  typeset needsProcessing="nil"

  case ${iv_qmailSetup} in
    "submitServerSmtp"|"fullServer")
       needsProcessing="t"
       break
       ;;
  esac

  if [[ ${needsProcessing} == "nil" ]] ; then
    print -- "Skipped -- ${subject}"
    return 0
  fi

  # Main Domain
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a dnsUpdate

  # Each Of The Virtual Domains
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_VirDomsRefList[@]} ; do
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a dnsUpdate
  done

  # Each of the mailing lists
  for thisOne in  ${iv_qmailHost_distListsRefList[@]} ; do
    opDoRet mmaQmailLists.sh -p listsDom=${thisOne} -i dnsUpdate
  done

  opDoRet mmaDnsServerHosts.sh -v -n showRun -i contentCombineData
}

function do_acctAddrsUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  # Main Domain
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a mainDomAcctsUpdate
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a addrsUpdate

  # Each Of The Virtual Domains
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_VirDomsRefList[@]} ; do
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a virDomUpdate
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a addrsUpdate
  done
}

function do_distListUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  # Each of the mailing lists
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_distListsRefList[@]} ; do
    opDoRet mmaQmailLists.sh -p listsDom=${thisOne} -i distListVirDomUpdate
    opDoRet mmaQmailLists.sh -p listsDom=${thisOne} -s all -a fullUpdate
  done
}

function do_distListCronsUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  # Each of the mailing lists
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_distListsRefList[@]} ; do
    opDoRet mmaQmailLists.sh -p listsDom=${thisOne} -s all -a cronEntryUpdate
  done
}

function do_distListCronsDelete {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  # Each of the mailing lists
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_distListsRefList[@]} ; do
    opDoRet mmaQmailLists.sh -p listsDom=${thisOne} -s all -a cronEntryDelete
  done
}

function do_acctAddrsFqmaShow {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  # Main Domain
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a acctAddrsFqmaShow

  # Each Of The Virtual Domains
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_VirDomsRefList[@]} ; do
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a acctAddrsFqmaShow
  done
}



function do_acctUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  # Main Domain
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a mainDomainAcctsUpdate

  # Each Of The Virtual Domains
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_VirDomsRefList[@]} ; do
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a virDomUpdate
  done
}


function do_configure {
  do_fullUpdate
}

function do_fullVerify {
  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? == 0 ]] ; then
    ${targetSubject}
  else
    itemPre_qmailHost
    itemPost_qmailHost
  fi

  #mmaQmailAdmin.sh -i fullReport
  opDo mmaQmailAdmin.sh -i showProcs

  opDo mmaQmailAdmin.sh -i injectFirst mohsen@neda.com

  opDo mmaQmailAdmin.sh -i showQueue
}



function do_fullUpdate {
  targetSubject=item_${subject}

  subjectIsValid
  if [ $? == 0 ] ; then
    ${targetSubject}
  else
    itemPre_qmailHost
    itemPost_qmailHost
  fi

  continueAfterThis

  #set -x

  # NOTYET, verify that the daemons have been stopped.
  opDo mmaQmailAdmin.sh -i stop

  FN_dirDefunctMake ${qmailControlBaseDir} ${qmailVarDir}/notused.control.${dateTag}
  FN_dirCreatePathIfNotThere ${qmailControlBaseDir}

  FN_dirDefunctMake ${qmailUsersBaseDir} ${qmailVarDir}/notused.users.${dateTag}
  FN_dirCreateIfNotThere ${qmailUsersBaseDir}


  case ${iv_qmailSetup} in
    "submitClientSmtp")
       TM_trace 7 "Setup for null client"

       gcf_qmailGlobals
       gcf_qmailInject
       gcf_qmailSend
       gcf_qmailRemote
       ;;

    "submitServerSmtp")
       TM_trace 7 "Setup for submit server"

       gcf_qmailGlobals
       gcf_qmailInject
       gcf_qmailSmtpd
       gcf_qmailSend
       gcf_qmailRemote

       vis_inetdSmtpdLineAdd
       ;;

    "fullServer")
       TM_trace 7 "Setup for Full Server"

       gcf_qmailGlobals
       gcf_qmailInject
       gcf_qmailSmtpd
       gcf_qmailSend
       gcf_qmailRemote

       do_acctAddrsUpdate

       do_distListUpdate

       do_dnsUpdate

       vis_inetdSmtpdLineAdd ${m_doing}
       ;;

    *)
       EH_problem "Unknown:  ${iv_qmailSetup}"
       exit 1
       ;;
  esac

  do_itemActions

  mmaQmailAdmin.sh -i start
  mmaQmailAdmin.sh -i showProcs
  mmaQmailAdmin.sh -i injectFirst mohsen@neda.com
  mmaQmailAdmin.sh -i showQueue
}

function do_fullDelete {
  EH_problem "NOTYET"
  return 1
}



vis_inetdSmtpdLineAdd() {
    continueAfterThis
  mmaQmailSmtpdLine="smtp	stream	tcp	nowait	qmaild	/var/qmail/bin/tcp-env	tcp-env /var/qmail/bin/qmail-smtpd"

  FN_lineAddToFile '^smtp'  "${mmaQmailSmtpdLine}" /etc/inetd.conf

  echo "Sending Signal HUP to the inetd daemon"
  pkill -HUP inetd
}


if [[ "${opRunOsType}_" == "SunOS_" ]] ; then
  mmaQmailSmtpdLine="smtp	stream	tcp	nowait	qmaild	/var/qmail/bin/tcp-env	tcp-env /var/qmail/bin/qmail-smtpd"
elif [[ "${opRunOsType}_" == "Linux_" ]] ; then
  mmaQmailSmtpdLine="smtp	stream	tcp	nowait	qmaild	/var/qmail/bin/tcp-env	tcp-env /var/qmail/bin/qmail-smtpd"
else
  EH_problem "Unsupported OS: ${opRunOsType}"
  return 1
fi

function do_netListenerDisable {

  subjectValidatePrepare

  opInetdLineDelete "smtp"
  opInetdHUP
}

function do_netListenerEnable {

  subjectValidatePrepare

  opDoComplain opInetdLineUpdate "smtp" "${mmaQmailSmtpdLine}"
  opDoComplain opInetdHUP
}

function do_netListenerShow {

  subjectValidatePrepare

  opDoComplain opInetdLineShow "smtp"
}

function do_netListenerVerify {

  subjectValidatePrepare

  opDoComplain opInetdLineVerify "smtp" "${mmaQmailSmtpdLine}"
}


function do_schemaVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}
  print "NOTYET"
  exit 1
}

