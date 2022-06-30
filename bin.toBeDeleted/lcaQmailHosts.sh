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


####+BEGIN: bx:bsip:bash:seed-spec :types "seedSubjectAction.sh"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedSubjectAction.sh]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailHosts.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedSubjectAction.sh -l $0 "$@" 
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

  DESCRIPTION
       Configure the mail system according to specified host parameters.

       gcf_ Generate Configuration Files
_EOF_
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Prefaces (Imports/Libraries)
_CommentEnd_

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/opDoAtAsLib.sh
. ${opBinBase}/lpParams.libSh
. ${opBinBase}/lpReRunAs.libSh


. ${opBinBase}/mmaLib.sh
. ${opBinBase}/mmaDaemontoolsLib.sh
. ${mailBinBase}/mmaQmailLib.sh
. ${opBinBase}/mmaDnsLib.sh
. ${opBinBase}/mmaUcspiLib.sh

. ${opBinBase}/lpReRunAs.libSh

#setBasicItemsFiles mmaQmailNewHostItems
setBasicItemsFiles mmaQmailHostItems

opNetCfg_paramsGet ${opRunClusterName} ${opRunHostName}
# ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}


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
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""
  typeset doLibExamples=`doLibExamplesOutput ${G_myName}`

  visLibExamplesOutput ${G_myName}
 cat  << _EOF_
EXAMPLES:
--- INFORMATION ---
${G_myName} ${extraInfo} -s all -a summary
${G_myName} ${extraInfo} -s ${opRunHostName} -a describe
${G_myName} ${extraInfo} -s ${opRunHostName} -a serverType
${G_myName} ${extraInfo} -s all -a walkObjects
${G_myName} ${extraInfo} -s ${opRunHostName} -a walkObjects
${G_myName} ${extraInfo} -s ${opRunHostName} -a acctAddrsFqmaShow
--- Server Software Profile (update/verify/delete) ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a serviceSoftwareProfile verify
--- SERVER ACTIONS FULL ---
=== Details with -- -T 7 ===
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullVerify
${G_myName} ${extraInfo} -s ${opRunHostName} -a configFullUpdate -e "services not included"
${G_myName} ${extraInfo} -s ${opRunHostName} -a serviceFullUpdate -e "assumes configFullUpdate has been done"
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullUpdate -e "everything"
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullDelete
--- SERVICES CONFIGURATION ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesConfig all
-- SERVICES ACTIVATION ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesEnable
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesDisable
${G_myName} ${extraInfo} -i servicesEnable  inNetSmtp 
${G_myName} ${extraInfo} -i servicesEnable  inNetVerify
${G_myName} ${extraInfo} -i servicesEnable  outNetSmtp 
${G_myName} ${extraInfo} -i servicesDisable inNetSmtp 
${G_myName} ${extraInfo} -i servicesDisable inNetVerify
${G_myName} ${extraInfo} -i servicesDisable outNetSmtp 
--- SERVICES MANIPULATION ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesList
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesShow all
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStop all
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStop outNetSmtp 
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStop inNetSmtp 
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStop inNetVerify
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStart all
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStart outNetSmtp 
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStart inNetSmtp 
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStart inNetVerify
${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesRestart all
--- QMAIL CONFIGURATION ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a configure
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
--- SUBMIT/RELAY ACCESS CONTROL ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a submitServerAccessShow
${G_myName} ${extraInfo} -s ${opRunHostName} -a submitServerAllowList
${G_myName} ${extraInfo} -s ${opRunHostName} -a submitServerDenyList
--- OLD TO NEW CONVERSION ---
${G_myName} ${extraInfo} -i bootRcDeInstall
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullConvert
${G_myName} ${extraInfo} -s ${opRunHostName} -a configFilesRenew
--- Qmail Raw Report ---
${G_myName} ${extraInfo} -i rawReport
${G_myName} ${extraInfo} -i rawUserReport
_EOF_
}


noArgsHook() {
  vis_examples
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Module Functions
_CommentEnd_


function vis_rawReport {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo echo qmailControlBaseDir=${qmailControlBaseDir}
    opDo ls -ldt ${qmailControlBaseDir}
    find ${qmailControlBaseDir} -maxdepth 1 -type f -print | egrep -v '.[0-9]' | grep -v .cdb | xargs grep '^.'

    lpReturn
}


function vis_rawUserReport {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    opDo echo qmailUsersBaseDir=${qmailUsersBaseDir}
    opDo ls -ldt ${qmailUsersBaseDir}
    find ${qmailUsersBaseDir}/* -maxdepth 1 -type f -print | egrep -v '.[0-9]' | grep -v .cdb | xargs grep '^.'
    #opDo find ${qmailUsersBaseDir} -maxdepth 1 -type f -print 

    lpReturn
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

function do_serviceSoftwareProfile {
  EH_assert [[ $# -eq 1 ]]
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}
  
  ANT_raw "Software Profile For ${subject}"

  softwareProfile=""

  for thisFeature in ${iv_qmailSetup} ; do
    case ${thisFeature} in
      "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
        softwareProfile="qmail"
	;;

      "submitServerSmtp"|"inNetSmtp")
        softwareProfile="qmailIsp"
	break
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
  done

  if [ "${softwareProfile}_" == "_" ] ; then
    ANT_raw "No Service"
    echo ""
    if [ "$1_" != "tag_" ] ; then
      echo "NoService"
    fi
    return
  fi

  case ${1} in
    "update"|"verify"|"delete")
	      echo "lcaQmailBinsPrep.sh -s ${softwareProfile} -a $1"
	       ;;
    "tag")
	      echo "${softwareProfile}"
	       ;;

    *)
       EH_problem "Unexpected Arg: $1"
       ;;
  esac
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
  #ivd_qmailGlobalFile_me=${iv_qmailSenderDomainPart}
  ivd_qmailGlobalFile_me=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

  # _DONT_ means don't create that file
  if [ "${ivd_qmailGlobalFile_me}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailGlobalFile_me=${ivd_qmailGlobalFile_me}"
    echo "${ivd_qmailGlobalFile_me}" > ${qmailControlBaseDir}/me
    opDo ls -l ${qmailControlBaseDir}/me
    opDo chmod 644 ${qmailControlBaseDir}/me
  fi
}


function gcf_qmailInject {
  #  QMAIL-INJECT control files

  continueAfterThis

  # defaulthost
  #ivd_qmailInjectFile_defaulthost=${iv_qmailSenderDomainPart}
  ivd_qmailInjectFile_defaulthost=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

  if [ "${ivd_qmailInjectFile_defaulthost}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_defaulthost=${ivd_qmailInjectFile_defaulthost}"
    echo "${ivd_qmailInjectFile_defaulthost}" > ${qmailControlBaseDir}/defaulthost
    chmod 644 ${qmailControlBaseDir}/defaulthost
  fi

  # defaultdomain
  #ivd_qmailInjectFile_defaultdomain=${iv_qmailSenderDomainPart}
  ivd_qmailInjectFile_defaultdomain=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

  if [ "${ivd_qmailInjectFile_defaultdomain}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_defaultdomain=${ivd_qmailInjectFile_defaultdomain}"
    echo "${ivd_qmailInjectFile_defaultdomain}" > ${qmailControlBaseDir}/defaultdomain
    opDo chmod 644 ${qmailControlBaseDir}/defaultdomain
  fi

  # idhost
  #ivd_qmailInjectFile_idhost="${iv_qmailMsgIdTag}.${iv_qmailSenderDomainPart}"
  ivd_qmailInjectFile_idhost=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

  if [ "${ivd_qmailInjectFile_idhost}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailInjectFile_idhost=${ivd_qmailInjectFile_idhost}"
    echo "${ivd_qmailInjectFile_idhost}" > ${qmailControlBaseDir}/idhost
    opDo chmod 644 ${qmailControlBaseDir}/idhost
  fi

  # plusdomain
  #ivd_qmailInjectFile_plusdomain=${iv_qmailSenderDomainPart}
  ivd_qmailInjectFile_plusdomain=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

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
  #ivd_qmailSendFile_locals=${iv_qmailLocalDelivery}
  ivd_qmailSendFile_locals=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

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
  #ivd_qmailRemoteFile_helohost="${iv_qmailMsgIdTag}.${iv_qmailSenderDomainPart}"
  ivd_qmailRemoteFile_helohost=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

  if [ "${ivd_qmailRemoteFile_helohost}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailRemoteFile_helohost=${ivd_qmailRemoteFile_helohost}"
    echo "${ivd_qmailRemoteFile_helohost}" > ${qmailControlBaseDir}/helohost
    opDo chmod 644 ${qmailControlBaseDir}/helohost
  fi


  # smtproutes
  ivd_qmailRemoteFile_smtproutes=${iv_qmailSmtpRoutes}

  if [ "${ivd_qmailRemoteFile_smtproutes}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailRemoteFile_smtproutes=${ivd_qmailRemoteFile_smtproutes}"
    print "${ivd_qmailRemoteFile_smtproutes}" > ${qmailControlBaseDir}/smtproutes
    opDo chmod 644 ${qmailControlBaseDir}/smtproutes
  fi
}

function gcf_qmailSmtpd {
  #  QMAIL-SMTPD control files

    #set -x

  continueAfterThis

  # rcpthosts
  #ivd_qmailSmtpdFile_rcpthosts="${iv_qmailAcceptDestinedTo}"
  ivd_qmailSmtpdFile_rcpthosts=$( echo ${opRunHostFamilyTag}.$( STR_toLower ${iv_qmailSenderDomainPart} ))

  if [ "${ivd_qmailSmtpdFile_rcpthosts}X" != "_DONT_X" ] ; then
    TM_trace 7 "ivd_qmailSmtpdFile_rcpthosts=${ivd_qmailSmtpdFile_rcpthosts}"
    echo "${ivd_qmailSmtpdFile_rcpthosts}" > ${qmailControlBaseDir}/rcpthosts
    opDo chmod 644 ${qmailControlBaseDir}/rcpthosts
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
  opDoRet mmaQmailDoms.sh -s ${iv_qmailHost_mainDomRef} -a mainDomAcctsUpdate

  # Each Of The Virtual Domains
  typeset thisOne=""
  for thisOne in  ${iv_qmailHost_VirDomsRefList[@]} ; do
    opDoRet mmaQmailDoms.sh -s ${thisOne} -a virDomUpdate
  done
}


function do_configure {
  opDo do_configFullUpdate
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
  subjectValidatePrepare

  do_servicesDisable
  continueAfterThis
  
  do_configFullUpdate
  do_serviceFullUpdate
}

function do_serviceFullUpdate {
  subjectValidatePrepare

  do_servicesDisable
  continueAfterThis

  do_servicesConfig all
  continueAfterThis

  do_servicesEnable
  continueAfterThis

  do_servicesShow all

}

function do_configFullUpdate {
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


  gcf_qmailGlobals
  gcf_qmailSend

  for thisFeature in ${iv_qmailSetup} ; do
    case ${thisFeature} in
      "localInjectAgent")
	  gcf_qmailInject
	  ;;

      "localDeliveryAgent")
          do_acctAddrsUpdate
          do_distListUpdate
	  ;;

      "outNetSmtp")
        gcf_qmailRemote
	;;

      "submitServerSmtp"|"inNetSmtp")
        gcf_qmailSmtpd
	# NOTYET, Server Enable
        # vis_inetdSmtpdLineAdd
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
  done

    # NOTYET, Temporarily Disabled
  #do_dnsUpdate

  do_itemActions

  opDo mmaQmailAdmin.sh -i start
  opDo mmaQmailAdmin.sh -i showProcs
  opDo mmaQmailAdmin.sh -i injectFirst mohsen@neda.com
  opDo mmaQmailAdmin.sh -i showQueue
}


function do_fullDelete {
  EH_problem "NOTYET"
  return 1
}


#
#  SERVICES CONFIGURATION
#

# Parameters
SOFTLIMIT_ABS=`which softlimit`
TCPSERVER_ABS=`which tcpserver`
SETUIDGID_ABS=`which setuidgid`
MULTILOG_ABS=`which multilog`
RBLSMTPD_ABS=`which rblsmtpd`

function do_servicesConfig {
  EH_assert [[ $# -gt 0 ]]
  subjectValidatePrepare

  opDoRet subjectIsRunHost || return $?

  continueAfterThis

  typeset argv=""
  if [[ "$1_" = "all_" ]] ; then
    argv=${iv_qmailSetup}
  else
    argv="$@"
  fi

  typeset thisOne=""
  #mailEngine submitServerSmtp fullServer
  for thisOne in ${argv} ; do
    case ${thisOne} in
      "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
	  sendDaemonConfig		    
	  ;;

      "submitServerSmtp"|"inNetSmtp")
	  smtpdDaemonConfig			    
	  ;;

      *)
	 EH_problem "Unknown:  ${thisOne}"
	 return 1  
	 ;;
    esac
  done
}

sendDaemonConfigVirgin="true"
function sendDaemonConfig {
 
  if [[ "${sendDaemonConfigVirgin}_" == "true_" ]] ; then
    sendDaemonConfigVirgin="false"
  else
    return
  fi

   FN_dirSafeKeep ${qmailVarDir}/supervise/qmail-send

   opDoComplain mkdir -p ${qmailVarDir}/supervise/qmail-send/log

   opDoComplain chmod +t ${qmailVarDir}/supervise/qmail-send

    m_myName=sendDaemonConfig

    case ${iv_qmailDefaultDeliveryFormat} in
      "./Mailbox")
		   doNothing
		   ;;
      "./Maildir/")
		    doNothing
		    ;;
      "")
	  iv_qmailDefaultDeliveryFormat="./Mailbox"	
	  ;;
      *)
	 EH_problem "Unknown iv_qmailDefaultDeliveryFormat: ${iv_qmailDefaultDeliveryFormat} in $0"
	 iv_qmailDefaultDeliveryFormat="./Mailbox"
	 ;;
    esac
    
cat  << _EOF_ > ${qmailVarDir}/supervise/qmail-send/run
#!/bin/sh
#
# MACHINE GENERATED with ${G_myName} and ${m_myName} on ${dateTag}
# DO NOT HAND EDIT
#
exec env - PATH="${qmailVarDir}/bin:\$PATH"  qmail-start ${iv_qmailDefaultDeliveryFormat}
_EOF_

    opDoComplain chmod 755 ${qmailVarDir}/supervise/qmail-send/run


cat  << _EOF_ > ${qmailVarDir}/supervise/qmail-send/log/run
#!/bin/sh
#
# MACHINE GENERATED with ${G_myName} and ${m_myName} on ${dateTag}
# DO NOT HAND EDIT
#
exec ${SETUIDGID_ABS} qmaill ${MULTILOG_ABS} t s1000000 n2000 /var/log/qmail
_EOF_

    opDoComplain mkdir -p /var/log/qmail
    opDoComplain chown qmaill /var/log/qmail
    opDoComplain chgrp -R qmail /var/log/qmail

    opDoComplain chmod 755 ${qmailVarDir}/supervise/qmail-send/log/run
}

smtpdDaemonConfigVirgin="true"
function smtpdDaemonConfig {
 
  if [[ "${smtpdDaemonConfigVirgin}_" == "true_" ]] ; then
    smtpdDaemonConfigVirgin="false"
  else
    return
  fi

  FN_dirSafeKeep ${qmailVarDir}/supervise/qmail-smtpd
    
    opDoComplain mkdir -p ${qmailVarDir}/supervise/qmail-smtpd/log
    
    opDoComplain chmod +t ${qmailVarDir}/supervise/qmail-smtpd

    m_myName=sendDaemonConfig
   
cat  << _EOF_ > ${qmailVarDir}/supervise/qmail-smtpd/run
#!/bin/sh
#
# MACHINE GENERATED with ${G_myName} and ${m_myName} on ${dateTag}
# DO NOT HAND EDIT
#

QMAILDUID=\`id -u qmaild\`
NOFILESGID=\`id -g qmaild\`
LOCAL=\`head -1 ${qmailVarDir}/control/me\`

if [ -z "\$QMAILDUID" -o -z "\$NOFILESGID" -o -z "\$LOCAL" ]; then
    echo QMAILDUID, NOFILESGID or LOCAL is unset in
    echo ${qmailVarDir}/supervise/qmail-smtpd/run
    exit 1
fi

if [ ! -f ${qmailVarDir}/control/rcpthosts ]; then
    echo "No ${qmailVarDir}/control/rcpthosts!"
    echo "Refusing to start SMTP listener because it'll create an open relay"
    exit 1
fi

#smtp ${RBLSMTPD_ABS} -r relays.ordb.org -r bl.spamcop.net


exec ${TCPSERVER_ABS} -v -H -R -l "\$LOCAL" -x /etc/tcp.smtp.cdb\
 -u "\$QMAILDUID" -g "\$NOFILESGID"\
 0 smtp ${RBLSMTPD_ABS} -r bl.spamcop.net ${qmailVarDir}/bin/qmail-smtpd 2>&1 
_EOF_

   opDoComplain chmod 755 ${qmailVarDir}/supervise/qmail-smtpd/run


cat  << _EOF_ > ${qmailVarDir}/supervise/qmail-smtpd/log/run
#!/bin/sh
#
# MACHINE GENERATED with ${G_myName} and ${m_myName} on ${dateTag}
# DO NOT HAND EDIT
#
exec ${SETUIDGID_ABS} qmaill ${MULTILOG_ABS} t s1000000 n2000 /var/log/qmail/smtpd
_EOF_

    opDoComplain mkdir -p /var/log/qmail/smtpd
    opDoComplain chown qmaill /var/log/qmail/smtpd
    opDoComplain chgrp -R qmail /var/log/qmail/smtpd

    opDoComplain chmod 755 ${qmailVarDir}/supervise/qmail-smtpd/log/run
}


#--- SERVICES MANIPULATION ---
#${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesList
#${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStop all
#${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesStart all
#${G_myName} ${extraInfo} -s ${opRunHostName} -a servicesRestart all

function do_servicesList {
  EH_assert [[ $# -eq 0 ]]
  do_serverType
}

function subjectIsRunHost {
  if [[ "${subject}_" != "${opRunHostName}_" ]] ; then
    EH_problem "Remote not supported subject=${subject} opRunHostName=${opRunHostName}"
    return 1
  fi
  return 0
}

function do_servicesStop {
  EH_assert [[ $# -gt 0 ]]
  subjectValidatePrepare

  opDoRet subjectIsRunHost || return $?

  typeset argv=""
  if [[ "$1_" = "all_" ]] ; then
      argv=${iv_qmailSetup}
      argv="${iv_qmailSetup} inNetVerify"
      echo "iv_qmailSetup=${iv_qmailSetup}"
  else
    argv="$@"
  fi

  typeset thisOne=""
  for thisOne in ${argv} ; do
    opDo serviceAction  "${thisOne}" "Stop"
  done
}

function do_servicesStart {
  EH_assert [[ $# -gt 0 ]]
  subjectValidatePrepare

  opDoRet subjectIsRunHost || return $?

  continueAfterThis

  typeset argv=""
  if [[ "$1_" = "all_" ]] ; then
    argv=${iv_qmailSetup}
  else
    argv="$@"
  fi

  typeset thisOne=""
  for thisOne in ${argv} ; do
    serviceAction  "${thisOne}" "Start"
  done
}

function do_servicesRestart {
  EH_assert [[ $# -gt 0 ]]
  subjectValidatePrepare

  opDoRet subjectIsRunHost || return $?

  typeset argv=""
  if [[ "$1_" = "all_" ]] ; then
    argv=${iv_qmailSetup}
  else
    argv="$@"
  fi

  typeset thisOne=""
  for thisOne in ${argv} ; do
    serviceAction  "${thisOne}" "Restart"
  done
}

function do_servicesShow {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
  EH_assert [[ $# -gt 0 ]]

  subjectValidatePrepare
  opDoRet subjectIsRunHost || return $?

  typeset argv=""
  if [[ "$1_" = "all_" ]] ; then
    argv=${iv_qmailSetup}
  else
    argv="$@"
  fi

  typeset thisOne=""
  for thisOne in ${argv} ; do
    serviceAction  "${thisOne}" "Show"
  done
}

qmailSendVirgin="true"
qmailSmtpdVirgin="true"
qmailVerifyVirgin="true"

function serviceAction {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }

  # $1 -- "service"
  # $2 --  action
  EH_assert [[ $# -eq 2 ]]

  if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

  case ${1} in
    "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
	if [[ "${qmailSendVirgin}_" == "true_" ]] ; then
	  qmailSendVirgin="false"
	  mmaDaemon${2} qmail-send		    
	  mmaDaemon${2} qmail-send/log
	fi
	;;

    "submitServerSmtp"|"inNetSmtp")
 	if [[ "${qmailSmtpdVirgin}_" == "true_" ]] ; then
	  qmailSmtpdVirgin="false"
	  mmaDaemon${2} qmail-smtpd
	  mmaDaemon${2} qmail-smtpd/log
	fi
	;;

    "inNetVerify")
 	if [[ "${qmailVerifyVirgin}_" == "true_" ]] ; then
	  qmailVerifyVirgin="false"
	  mmaDaemon${2} qmail-verify
	  mmaDaemon${2} qmail-verify/log
	fi
	;;

    *)
       EH_problem "Unknown:  ${1}"
       return 1  
       ;;
  esac
}


sendDaemonEnableVirgin="true"
function sendDaemonEnable {
  EH_assert [[ $# -eq 0 ]]

  if [[ "${sendDaemonEnableVirgin}_" == "true_" ]] ; then
    sendDaemonEnableVirgin="false"
  else
    return
  fi

  # sendDaemonConfig

  opDo mmaDaemonUpdate qmail-send  ${qmailVarDir}/supervise/qmail-send
}

smtpdDaemonEnableVirgin="true"
function smtpdDaemonEnable {
  EH_assert [[ $# -eq 0 ]]
  if [[ "${smtpdDaemonEnableVirgin}_" == "true_" ]] ; then
    smtpdDaemonEnableVirgin="false"
  else
    return
  fi

  # smtpdDaemonConfig

  # NOTYET, perhaps in initial /etc/tcp.smtp should be setup

  mmaDaemonUpdate qmail-smtpd  ${qmailVarDir}/supervise/qmail-smtpd
}


sendDaemonDisableVirgin="true"
function sendDaemonDisable {
  EH_assert [[ $# -eq 0 ]]

  if [[ "${sendDaemonDisableVirgin}_" == "true_" ]] ; then
    sendDaemonDisableVirgin="false"
  else
    return
  fi

  mmaDaemonStop qmail-send qmail-send/log
  mmaDaemonDelete qmail-send
}

smtpdDaemonDisableVirgin="true"
function smtpdDaemonDisable {
  EH_assert [[ $# -eq 0 ]]

  if [[ "${smtpdDaemonDisableVirgin}_" == "true_" ]] ; then
    smtpdDaemonDisableVirgin="false"
  else
    return
  fi

  mmaDaemonStop qmail-smtpd qmail-smtpd/log
  mmaDaemonDelete qmail-smtpd
}


verifyDaemonDisableVirgin="true"
function verifyDaemonDisable {
  EH_assert [[ $# -eq 0 ]]

  if [[ "${verifyDaemonDisableVirgin}_" == "true_" ]] ; then
    verifyDaemonDisableVirgin="false"
  else
    return
  fi

  mmaDaemonStop qmail-verify qmail-verify/log
  mmaDaemonDelete qmail-verify
}

#
# Server Enable/Disable
#

function do_servicesEnable  {

  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? != 0 ]] ; then
    EH_problem "Invalid Subject: ${targetSubject}"
    return 1
  fi

  ${targetSubject}

  typeset thisOne=""
  typeset thisFeature=""

  for thisFeature in ${iv_qmailSetup} ; do

    case ${thisFeature} in
      "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
        TM_trace 7 "Setup for mailEngine"

	sendDaemonEnable
	;;

      "submitServerSmtp")
	smtpdDaemonEnable

	do_submitServerAllowList
	do_submitServerDenyList
	;;

      "inNetSmtp")
	smtpdDaemonEnable
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
  done
}


function vis_servicesEnable  {

  EH_assert [[ $# -eq 1 ]]

  typeset thisFeature=""

  thisFeature=$1

    case ${thisFeature} in
      "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
        TM_trace 7 "Setup for mailEngine"

	sendDaemonEnable
	;;

      "submitServerSmtp")
	smtpdDaemonEnable

	do_submitServerAllowList
	do_submitServerDenyList
	;;

      "inNetSmtp")
	smtpdDaemonEnable
	;;

      "inNetVerify")
	verifyDaemonEnable
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
}


function do_servicesDisable  {

  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? != 0 ]] ; then
    EH_problem "Invalid Subject: ${targetSubject}"
    return 1
  fi

  ${targetSubject}

  typeset thisOne=""
  typeset thisFeature=""

  for thisFeature in ${iv_qmailSetup} ; do
    case ${thisFeature} in
      "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
	opDo sendDaemonDisable
	;;

      "submitServerSmtp"|"inNetSmtp")
	opDo smtpdDaemonDisable
	;;

      "inNetVerify")
	opDo verifyDaemonDisable
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
  done
}

function vis_servicesDisable  {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 1 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;

  typeset thisFeature=""

  thisFeature=$1

    case ${thisFeature} in
      "localInjectAgent"|"localDeliveryAgent"|"outNetSmtp")
	sendDaemonDisable
	;;

      "submitServerSmtp"|"inNetSmtp")
	smtpdDaemonDisable
	;;

      "inNetVerify")
	verifyDaemonDisable
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
}



function do_submitServerAccessShow {
  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? != 0 ]] ; then
    EH_problem "Invalid Subject: ${targetSubject}"
    return 1
  fi

  ${targetSubject}

  if LIST_isIn "submitServerSmtp" "${iv_qmailSetup}" ; then
    doNothing
  else
    EH_problem "Not a submitServerSmtp - echo ${iv_qmailSetup}"
    return 1
  fi

  opDoComplain cat /etc/tcp.smtp

}



function do_submitServerAllowList {
  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? != 0 ]] ; then
    EH_problem "Invalid Subject: ${targetSubject}"
    return 1
  fi

  ${targetSubject}

  typeset thisOne=""

  for thisOne in ${iv_qmailSubmitServerAllowList[@]} ; do
    opDoComplain mmaUcspiAllowAdd /etc/tcp.smtp ${thisOne} RELAYCLIENT=\"\"
  done
  mmaUcspiTcprulesCompile /etc/tcp.smtp /etc/tcp.smtp.cdb
}



function do_submitServerDenyList {
  targetSubject=item_${subject}

  subjectIsValid
  if [[ $? != 0 ]] ; then
    EH_problem "Invalid Subject: ${targetSubject}"
    return 1
  fi

  ${targetSubject}

  typeset thisOne=""

  for thisOne in ${iv_qmailSubmitServerDenyList[@]} ; do
    echo ${thisOne}
  done
}


function do_schemaVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}
  print "NOTYET"
  exit 1
}

# --- OLD TO NEW CONVERSION ---


# ./mmaBinsPrepLib.sh 
. ${opBinBase}/mmaBinsPrepLib.sh
. ${opBinBase}/opInetdLib.sh

function vis_bootRcDeInstall {
    filesList=" /etc/init.d/mma-qmail /etc/rc2.d/S88mma-qmail "

    opDoComplain bootRcDisable "${filesList}"
}


function do_fullConvert {
  targetSubject=item_${subject}

  subjectValidVerify
  ${targetSubject}

  # NOTYET, Stop qmail Services
  mmaQmailNewHosts.sh -v -n showRun -s beverly -a servicesStop all
  mmaQmailAdmin.sh -i killProcs

  vis_bootRcDeInstall

  do_netListenerDisable

  do_servicesConfig all
  do_servicesEnable
}

function do_configFilesRenew {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Used to be
#function do_configFilestransition {
_EOF_
    }

    #if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

  targetSubject=item_${subject}

  subjectIsValid
  if [ $? == 0 ] ; then
    ${targetSubject}
  else
    itemPre_qmailHost
    itemPost_qmailHost
  fi


  FN_fileSafeKeep ${qmailControlBaseDir}/me
  FN_fileSafeKeep ${qmailControlBaseDir}/defaulthost
  FN_fileSafeKeep ${qmailControlBaseDir}/defaultdomain
  FN_fileSafeKeep ${qmailControlBaseDir}/idhost
  FN_fileSafeKeep ${qmailControlBaseDir}/plusdomain
  FN_fileSafeKeep ${qmailControlBaseDir}/locals
  FN_fileSafeKeep ${qmailControlBaseDir}/helohost
  FN_fileSafeKeep ${qmailControlBaseDir}/smtproutes
  FN_fileSafeKeep ${qmailControlBaseDir}/rcpthosts


  gcf_qmailGlobals
  gcf_qmailSend

  for thisFeature in ${iv_qmailSetup} ; do
    case ${thisFeature} in
      "localInjectAgent")
	  gcf_qmailInject
	  ;;

      "localDeliveryAgent")
          doNothing
	  ;;

      "outNetSmtp")
        gcf_qmailRemote
	;;

      "submitServerSmtp"|"inNetSmtp")
        gcf_qmailSmtpd   # does rcpthosts which is okay the old way
	    #doNothing
	;;

      *)
       EH_problem "Unknown:  ${thisFeature}"
       return 1  
       ;;
    esac
  done

  

}


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
