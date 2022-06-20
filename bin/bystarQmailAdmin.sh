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
*  /This File/ :: /bisos/core/mail/bin/bystarQmailAdmin.sh 
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
**      ====[[elisp:(org-cycle)][Fold]]==== [[file:/libre/ByStar/InitialTemplates/activeDocs/bxServices/servicesManage/bxsoMailAddr/fullUsagePanel-en.org::Xref-BxsoMailAddr][Panel Roadmap Documentation]]
  NOTYETs:
    - Top level, do everything
     - Top Level information
     - Generate Test Messages
     - Cleanups, 
     - Delete accounts

  FILES
       ${opSiteControlBase}/${opSiteName}/acctSubsItems

_EOF_
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Prefaces (Imports/Libraries)
_CommentEnd_

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/opDoAtAsLib.sh
. ${opBinBase}/lpParams.libSh
. ${opBinBase}/lpReRunAs.libSh


. ${opBinBase}/bystarHook.libSh

# bxo_lib.sh
. ${opBinBase}/bxo_lib.sh
. ${opBinBase}/bynameLib.sh
. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh
. ${opBinBase}/mmaDnsLib.sh


. ${opBinBase}/bystarCentralAcct.libSh


. ${opBinBase}/bisosCurrents_lib.sh

# PRE parameters
typeset -t acctTypePrefix=""
typeset -t bystarUid="MANDATORY"

function G_postParamHook {
    bystarUidHome=$( FN_absolutePathGet ~${bystarUid} )
    lpCurrentsGet
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Examples
_CommentEnd_


function vis_examplesToBecome {
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""

  visLibExamplesOutput ${G_myName} 
  cat  << _EOF_
$( examplesSeperatorTopLabel "${G_myName}" )
$( examplesSeperatorChapter "Chapter Title" )
$( examplesSeperatorSection "Section Title" )
${G_myName} ${extraInfo} -i doTheWork
_EOF_
}


function vis_examples {
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""
# NOTYET, outofdate
  typeset doLibExamples=`doLibExamplesOutput ${G_myName}`

  typeset thisAcctTypePrefix="sa"
  #typeset thisOneSaNu="sa-20051"
  #typeset thisOneSaNu=${oneBystarAcct}
  typeset thisOneSaNu=${currentBystarUid}
  #typeset thisOneSaNu=prompt
  typeset oneSubject="qmailAddr_test"
 cat  << _EOF_
EXAMPLES:
${doLibExamples}
--- PROVISIONING ACTIONS ---
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i  fullAdd
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -f -i  fullAdd
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i  fullEssentials
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i  fullSupplements
--- GENERATE NSP FILE
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i generateMailNspFile
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -f -i generateMailNspFile
---
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i dnsUpdate
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i virDomAdd
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i addrUpdate
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i injectWelcom
--- DEACTIVATION ACTIONS ---
${G_myName} -p bystarUid=${thisOneSaNu} -i  fullDelete
${G_myName} -p bystarUid=${thisOneSaNu} -i  addrDelete
${G_myName} -p bystarUid=${thisOneSaNu} -i  addrDelete
${G_myName} -p bystarUid=${thisOneSaNu} -i  virDomDelete
${G_myName} -p bystarUid=${thisOneSaNu} -i  dnsDelete
--- MAINTENANCE ACTIONS ---
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -i addrUpdate
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -f -i addrUpdate
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -s ${oneSubject} -a addrUpdate
${G_myName} ${extraInfo} -p bystarUid=${thisOneSaNu} -f -s ${oneSubject} -a addrUpdate
--- CONTROLLED ACCOUNTS - Master Acct Update ---
${G_myName} ${extraInfo} -p bystarUid=${currentMasterUid} -i addrCntldAcctsUpdate
${G_myName} ${extraInfo} -p bystarUid=${currentMasterUid} -i masterAcctUpdate ${currentBcaUid}
--- INFORMATION ---
${G_myName} -p bystarUid=${thisOneSaNu} -i addrSummary
${G_myName} -p bystarUid=${thisOneSaNu} -i addrFqmaShow
mmaQmailAddrs.sh  -p domainPart=${byname_acct_baseDomain} -p domainType=virDomain   -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -p acctName="${byname_acct_acctTypePrefix}-${byname_acct_uid}" -s $subject -a addrFqmaShow
_EOF_
}


noArgsHook() {
  vis_examples
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Module Functions
_CommentEnd_



function vis_generateMailNspFile {
    EH_assert [[ $# -eq 0 ]]
    EH_assert bystarUidCentralPrep

    bystarBagpLoad

    nspBaseDir=${cp_acctNspBaseDir}
    FN_dirCreatePathIfNotThere ${nspBaseDir}

    mailAddrListSet () {
	EH_assert [[ $# -eq 0 ]]
	bystarAcctAnalyze ${bystarUid}
	bystarServiceSupportHookRun mailAddrListSet
    }

    mailAddrListSet_BYNAME_DEFAULT () {
	if ! test -f ${nspBaseDir}/mailAddrItems.nsp ; then
	    #opDo /bin/cp ${opSiteControlBase}/${opRunSiteName}/NSP.mailAcct.sh ${nspBaseDir}/mailAddrItems.nsp
            opDo /bin/cp ${opSiteControlBase}/${opRunSiteName}/mmaQmailAddrItems.byname ${nspBaseDir}/mailAddrItems.nsp
	    opDo chown ${bystarUid}:subscrbr ${nspBaseDir}/mailAddrItems.nsp
	else
	    opDo ANT_raw "Skipped"
	fi
    }

    mailAddrListSet_BYSMB_DEFAULT () {
	if ! test -f ${nspBaseDir}/mailAddrItems.nsp ; then
	    #opDo /bin/cp ${opSiteControlBase}/${opRunSiteName}/mmaQmailAddrItems.secLvlDomBasic ${nspBaseDir}/mailAddrItems.nsp
	    opDo /bin/cp ${opSiteControlBase}/${opRunSiteName}/mmaQmailAddrItems.masterAcct ${nspBaseDir}/mailAddrItems.nsp
	    opDo chown ${bystarUid}:subscrbr ${nspBaseDir}/mailAddrItems.nsp
	else
	    if [[ "${G_forceMode}_" == "force_" ]] ; then
		# NOTYET, this is no good. There should be no forceMode.
		#   We should always safekeep and override.
		opDo /bin/cp ${opSiteControlBase}/${opRunSiteName}/mmaQmailAddrItems.masterAcct ${nspBaseDir}/mailAddrItems.nsp
		opDo chown ${bystarUid}:subscrbr ${nspBaseDir}/mailAddrItems.nsp
	    else
		opDo ANT_raw "Skipped"
	    fi
	fi
    }

    mailAddrListSet_BCA_DEFAULT () {
	if ! test -f ${nspBaseDir}/mailAddrItems.nsp ; then
	    # /opt/public/osmt/siteControl/nedaPlus/mmaQmailAddrItems.controlledAcct 
	    opDo /bin/cp ${opSiteControlBase}/${opRunSiteName}/mmaQmailAddrItems.controlledAcct  ${nspBaseDir}/mailAddrItems.nsp
	    opDo chown ${bystarUid}:reserved ${nspBaseDir}/mailAddrItems.nsp
	else
	    opDo ANT_raw "Skipped"
	fi
    }

    opDo mailAddrListSet


    opDo /bin/ls -l ${nspBaseDir}/mailAddrItems.nsp
}


vis_injectWelcome () {
  EH_assert [[ $# -eq 0 ]]

  bystarAcctAnalyze ${bystarUid}

  opDo bystarMsgInject.sh -p bystarUid=${bystarUid} -p msg="NOTYET" -i msgInject
}

function vis_fullSupplements {
    EH_assert [[ $# -eq 0 ]]
    EH_assert bystarUidCentralPrep
    ANT_cooked "Nothing in fullSupplements"
    return
}

function vis_fullEssentials {
    EH_assert [[ $# -eq 0 ]]
    EH_assert bystarUidCentralPrep

    bystarBagpLoad

    opDoComplain vis_generateMailNspFile

    opDoComplain vis_virDomAdd
    opDoComplain vis_addrUpdate

    # MB 20160524: The main default folder does not get created in addrUpdate -- MB 20160524
    opDo bystarMailFolderManage.sh -p ri=root:passive -h -v -n showRun -i maildirMakeIn ${cp_acctUidHome}/ByStarMailDir ${bystarUid}

    if bystarIsControlledAcct ${bystarUid} ; then
	opDo ${G_myName} ${extraInfo} -p bystarUid=${cp_MasterAcct} -i masterAcctUpdate ${bystarUid}
    fi
}

function vis_fullAdd {
    EH_assert [[ $# -eq 0 ]]
    EH_assert bystarUidCentralPrep

    bystarBagpLoad

    opDoComplain vis_dnsUpdate

    opDoComplain vis_fullEssentials

    opDoComplain vis_fullSupplements

}

function prepBaseDomain {
    EH_assert [[ $# -eq 0 ]]

    prepBaseDomainSpecific () {
	EH_assert [[ $# -eq 0 ]]
	bystarServiceSupportHookRun prepBaseDomainSpecific
    }

    prepBaseDomainSpecific_BCA_DEFAULT () {
	ANT_raw "Controlled Acct"
	# Get the Master Account -- Add to it relative

	opDo masterAcctBagpLoad

	acctBaseDomain=${cp_DomainRel}.${cp_master_acctFactoryBaseDomain}
	if [ "${cp_master_acctFactoryBaseDomain}_" != "${cp_master_acctMainBaseDomain}_" ] ; then
	    MainDomain=${cp_DomainRel}.${cp_master_acctMainBaseDomain}
	fi
    }

    prepBaseDomainSpecific_BYNAME_DEFAULTOLD_DELETEME_SOON () {
	ANT_raw "Controlled Acct -- BYNAME has no controlled account NOTYET"

	opDo masterAcctBagpLoad

	acctBaseDomain=${cp_DomainRel}.${cp_master_acctFactoryBaseDomain}
	if [ "${cp_master_acctFactoryBaseDomain}_" != "${cp_master_acctMainBaseDomain}_" ] ; then
	    MainDomain=${cp_DomainRel}.${cp_master_acctMainBaseDomain}
	fi
    }

    prepBaseDomainSpecific_BYNAME_DEFAULT () {
	ANT_raw "BYNAME Main Acct"

	acctBaseDomain=${cp_acctFactoryBaseDomain}
	if [ "${cp_acctFactoryBaseDomain}_" != "${cp_acctMainBaseDomain}_" ] ; then
	    MainDomain=${cp_acctMainBaseDomain}
	fi
    }


    prepBaseDomainSpecific_DEFAULT_DEFAULT () {
	ANT_raw "Main Acct"
	acctBaseDomain=${cp_acctFactoryBaseDomain}
	if [ "${cp_acctFactoryBaseDomain}_" != "${cp_acctMainBaseDomain}_" ] ; then
	    MainDomain=${cp_acctMainBaseDomain}
	fi
    }
   
    opDo prepBaseDomainSpecific

}


function vis_dnsUpdate {
  EH_assert [[ $# -eq 0 ]]
  EH_assert bystarUidCentralPrep

  opDoExit mmaDnsServerHosts.sh -i hostIsOrigContentServer

  opDoRet bystarAcctAnalyze ${bystarUid}

  opDoExit opNetCfg_paramsGet ${opRunClusterName} ${opRunHostName}
    # ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}
    
  #prepBaseDomain

  #echo "Virtual Domain: acctFactoryBaseDomain=${cp_acctFactoryBaseDomain} acctMainBaseDomain=${cp_acctMainBaseDomain} -- AcctId: ${bystarUid}" 


   acctDnsUpdateSpecific_BCA_DEFAULT () {
	ANT_raw "Controlled Acct"
	# Get the Master Account -- Add to it relative

	opDo masterAcctBagpLoad

	if [ "${cp_master_acctFactoryBaseDomain}_" != "${cp_master_acctMainBaseDomain}_" ] ; then
	    bcaMainBaseDomain=${cp_DomainRel}.${cp_master_acctMainBaseDomain}

	    opDoRet mmaDnsEntryMxUpdate ${bcaMainBaseDomain} ${opRunHostName}

	    opDoRet mmaDnsEntryAliasUpdate imap.${bcaMainBaseDomain} ${opRunHostName}
	    opDoRet mmaDnsEntryAliasUpdate pop.${bcaMainBaseDomain} ${opRunHostName}
	    opDoRet mmaDnsEntryAliasUpdate smtp.${bcaMainBaseDomain} ${opRunHostName}
	    opDoRet mmaDnsEntryAliasUpdate webmail.${bcaMainBaseDomain} ${opRunHostName}
	fi

        bcaFactoryBaseDomain=${cp_DomainRel}.${cp_master_acctFactoryBaseDomain}

        opDoRet mmaDnsEntryMxUpdate ${bcaFactoryBaseDomain} ${opRunHostName}

        opDoRet mmaDnsEntryAliasUpdate imap.${bcaFactoryBaseDomain} ${opRunHostName}
        opDoRet mmaDnsEntryAliasUpdate pop.${bcaFactoryBaseDomain} ${opRunHostName}
        opDoRet mmaDnsEntryAliasUpdate smtp.${bcaFactoryBaseDomain} ${opRunHostName}
        opDoRet mmaDnsEntryAliasUpdate webmail.${bcaFactoryBaseDomain} ${opRunHostName}


	opDo ls -l /etc/tinydns/origContent/data.origZones  1>&2
    }

    acctDnsUpdateSpecific_DEFAULT_DEFAULT () {
	ANT_raw "Main (Master) Acct"

	if [ "${cp_acctFactoryBaseDomain}_" != "${cp_acctMainBaseDomain}_" ] ; then

	    opDoRet mmaDnsEntryMxUpdate ${cp_acctMainBaseDomain} ${opRunHostName}

	    opDoRet mmaDnsEntryAliasUpdate imap.${cp_acctMainBaseDomain} ${opRunHostName}
	    opDoRet mmaDnsEntryAliasUpdate pop.${cp_acctMainBaseDomain} ${opRunHostName}
	    opDoRet mmaDnsEntryAliasUpdate smtp.${cp_acctMainBaseDomain} ${opRunHostName}
	    opDoRet mmaDnsEntryAliasUpdate webmail.${cp_acctMainBaseDomain} ${opRunHostName}
	fi

	#
	# FACTORY BASE DOMAIN
	#

        opDoRet mmaDnsEntryMxUpdate ${cp_acctFactoryBaseDomain} ${opRunHostName}

	opDoRet mmaDnsEntryAliasUpdate imap.${cp_acctFactoryBaseDomain} ${opRunHostName}
	opDoRet mmaDnsEntryAliasUpdate pop.${cp_acctFactoryBaseDomain} ${opRunHostName}
	opDoRet mmaDnsEntryAliasUpdate smtp.${cp_acctFactoryBaseDomain} ${opRunHostName}
	opDoRet mmaDnsEntryAliasUpdate webmail.${cp_acctFactoryBaseDomain} ${opRunHostName}

	#
	# BYNUMBER BASE DOMAIN
	#

        opDoRet mmaDnsEntryMxUpdate ${cp_acctBynumberBaseDomain} ${opRunHostName}

	opDoRet mmaDnsEntryAliasUpdate imap.${cp_acctBynumberBaseDomain} ${opRunHostName}
	opDoRet mmaDnsEntryAliasUpdate pop.${cp_acctBynumberBaseDomain} ${opRunHostName}
	opDoRet mmaDnsEntryAliasUpdate smtp.${cp_acctBynumberBaseDomain} ${opRunHostName}
	opDoRet mmaDnsEntryAliasUpdate webmail.${cp_acctBynumberBaseDomain} ${opRunHostName}


	opDo ls -l /etc/tinydns/origContent/data.origZones  1>&2
    }
   
    bystarServiceSupportHookRun acctDnsUpdateSpecific


  # NOTYET, revisit
  #opDoRet mmaDnsEntryMxUpdate ${cp_acctBynumberBaseDomain} ${opRunHostName}
}

function vis_virDomAdd {
  EH_assert [[ $# -eq 0 ]]
  EH_assert bystarUidCentralPrep

  bystarAcctAnalyze ${bystarUid}

  prepBaseDomain

  echo "Virtual Domain: acctBaseDomain=${acctBaseDomain} acctMainBaseDomain=${MainDomain} -- AcctId: ${bystarUid}"  

  opDoRet mmaQmailVirDomUpdate ${acctBaseDomain} ${bystarUid}

  if [ "${acctBaseDomain}_" != "${MainDomain}_" ] ; then
      opDoRet mmaQmailVirDomUpdate ${MainDomain} ${bystarUid}
  fi

  opDo ls -l ${qmailVarDir}/control/virtualdomains 
}


function vis_virDomAddUsedToBe {
  EH_assert [[ $# -eq 0 ]]
  EH_assert bystarUidCentralPrep

  bystarAcctAnalyze ${bystarUid}

  prepBaseDomain

  echo "Virtual Domain: acctFactoryBaseDomain=${cp_acctFactoryBaseDomain} acctMainBaseDomain=${cp_acctMainBaseDomain} -- AcctId: ${bystarUid}"  

  opDoRet mmaQmailVirDomUpdate ${cp_acctFactoryBaseDomain} ${bystarUid}

  if [ "${cp_acctFactoryBaseDomain}_" != "${cp_acctMainBaseDomain}_" ] ; then
      opDoRet mmaQmailVirDomUpdate ${cp_acctMainBaseDomain} ${bystarUid}
  fi

  opDo ls -l ${qmailVarDir}/control/virtualdomains 
}



function vis_addrCntldAcctsUpdate {
  EH_assert [[ $# -eq 0 ]]
  EH_assert bystarUidCentralPrep

  bystarAcctAnalyze ${bystarUid}

  masterUidHome=$( FN_absolutePathGet ~${bystarUid} )
  masterUid=${bystarUid}
  
  cntldAcctList=$( bystarCtldAcctAdmin.sh  -p controllerUid="${bystarUid}" -i cntldAcctList )

  for thisAcct in ${cntldAcctList} ; do
      ANT_raw "Master Email For Controlled: ${thisAcct}"

      opDoRet bystarAcctAnalyze ${thisAcct}
      
      #echo ${cp_acctUidHome} ${cp_acctUid} -- ${cp_MasterAcctMailName1} ${cp_MasterAcctMailFwd1}


      typeset dotQmailFile="${masterUidHome}/.qmail-${cp_MasterAcctMailName1}"

      echo "| forward ${cp_MasterAcctMailFwd1}" > ${dotQmailFile}
      chown ${masterUid} ${dotQmailFile}
      #chgrp qmail ${dotQmailFile}
      chmod 600 ${dotQmailFile}

      ls -l  ${dotQmailFile}
      cat ${dotQmailFile}
  done
}


function vis_masterAcctUpdate {
  EH_assert [[ $# -eq 1 ]]
  EH_assert bystarUidCentralPrep

  bystarAcctAnalyze ${bystarUid}

  masterUidHome=$( FN_absolutePathGet ~${bystarUid} )
  masterUid=${bystarUid}
  
  thisAcct=$1
  ANT_raw "Master Email For Controlled: ${thisAcct}"

  opDoRet bystarAcctAnalyze ${thisAcct}
      
  #echo ${cp_acctUidHome} ${cp_acctUid} -- ${cp_MasterAcctMailName1} ${cp_MasterAcctMailFwd1}


  typeset dotQmailFile="${masterUidHome}/.qmail-${cp_MasterAcctMailName1}"

  echo "| forward ${cp_MasterAcctMailFwd1}" > ${dotQmailFile}
  chown ${masterUid} ${dotQmailFile}
  #chgrp qmail ${dotQmailFile}
  chmod 600 ${dotQmailFile}

  ls -l  ${dotQmailFile}
  cat ${dotQmailFile}
}


function vis_addrUpdate {
  EH_assert [[ $# -eq 0 ]]
  EH_assert bystarUidCentralPrep

  bystarAcctAnalyze ${bystarUid}

    if [[ "${G_forceMode}_" == "force_" ]] ; then
      #opDoComplain mmaQmailAddrs.sh -f -p addrItemsFile="${cp_acctUidHome}/NSP/mailAddrItems.nsp" -p acctName="${cp_acctUid}" -s all -a addrUpdate
      opDoComplain mmaQmailAddrs.sh -f -p addrItemsFile="${cp_acctUidHome}/NSP/mailAddrItems.nsp" -p acctName="${cp_acctUid}"  -s qmailAddrsList_ordered -a addrUpdate
    else
      #opDoComplain mmaQmailAddrs.sh -p addrItemsFile="${cp_acctUidHome}/NSP/mailAddrItems.nsp" -p acctName="${cp_acctUid}" -s all -a addrUpdate
      opDoComplain mmaQmailAddrs.sh  -p addrItemsFile="${cp_acctUidHome}/NSP/mailAddrItems.nsp" -p acctName="${cp_acctUid}"  -s qmailAddrsList_ordered -a addrUpdate
    fi
 }

function do_addrUpdate {

  integer gotVal=0
  bynameAcctAnalyze || gotVal=$?

  if [[ ${gotVal} -ne 0 ]] ; then
    EH_problem "$0: not enough info."
    return 1
  fi

  if [[ "${G_forceMode}_" == "force_" ]] ; then
    opDoComplain mmaQmailAddrs.sh -f -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -p acctName="${byname_acct_acctTypePrefix}-${byname_acct_uid}" -s $subject -a addrUpdate
  else
    opDoComplain mmaQmailAddrs.sh -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -p acctName="${byname_acct_acctTypePrefix}-${byname_acct_uid}" -s $subject -a addrUpdate
  fi
}

function vis_addrFqmaShow {

  integer gotVal=0
  bynameAcctAnalyze || gotVal=$?

  if [[ ${gotVal} -eq 0 ]] ; then

    opDoComplain mmaQmailAddrs.sh  -p domainPart=${byname_acct_baseDomain} -p domainType=virDomain   -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -p acctName="${byname_acct_acctTypePrefix}-${byname_acct_uid}" -s all -a addrFqmaShow
  else
    EH_problem "$0: not enough info."
    return 1
  fi
}


function vis_addrDelete {
  opDoComplain byname_acctInfoGet ${SubsSelector} ${LastName} ${FirstName} ${acctTypePrefix}

 opDoComplain mmaQmailAddrs.sh -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -p acctName="${acctTypePrefix}-${byname_acct_uid}" -s all -a addrDelete
}

function vis_addrSummary {
  EH_assert [[ $# -eq 0 ]]
  EH_assert bystarUidCentralPrep

  bystarAcctAnalyze ${bystarUid}

  opDoRet mmaQmailAddrs.sh -p addrItemsFile="${cp_acctUidHome}/NSP/mailAddrItems.nsp" -s all -a summary
}

function vis_acctAdd {
  #set -x


  # NOTYET, verify that  ${SubsSelector} ${LastName} ${FirstName}
  # are all set
  #

  opDoComplain vis_virDomAdd 
  opDoComplain vis_updateOverWriteQmailFiles

}



function vis_fullDelete {
  #set -x

  # NOTYET, verify that  ${SubsSelector} ${LastName} ${FirstName}
  # are all set
  #
  opParamMandatoryVerify

  opDoComplain vis_addrDelete
  opDoComplain vis_virDomDelete
  opDoComplain vis_dnsDelete
}

function vis_dnsDelete {

  opDoExit mmaDnsServerHosts.sh -i hostIsOrigContentServer

  integer gotVal=0
  bynameAcctAnalyze || gotVal=$?

  if [[ ${gotVal} -eq 0 ]] ; then

    opDoExit opNetCfg_paramsGet ${opRunClusterName} ${opRunHostName}
    # ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}

    opDoRet mmaDnsEntryMxUpdate ${byname_acct_baseDomain} ${opRunHostName}
    opDoRet mmaDnsEntryMxUpdate ${byname_acct_numberDomain} ${opRunHostName}
  else
    EH_problem "$0: not enough info."
    return 1
  fi
}


function vis_aliasToMainAt {
  #set -x

  # NOTYET, verify that  ${SubsSelector} ${LastName} ${FirstName}
  # are all set
  #
  opParamMandatoryVerify

    echo  ${SubsSelector} ${LastName} ${FirstName}
    
    typeset dotQmailFile=~alias/.qmail-${FirstName}:${LastName}


    #NOTYET, verify that account exists

    opDoComplain byname_acctInfoGet ${SubsSelector} ${LastName} ${FirstName} ${acctTypePrefix} 

    typeset bynumberDotQmailFile=/acct/progs/qmaildom/net/bynumber/.qmail-${byname_acct_uid}

    echo "| forward main@${FirstName}.${LastName}.${SubsSelector}.byname.net" > ${dotQmailFile}
    chown alias ${dotQmailFile}
    chgrp qmail ${dotQmailFile}
    chmod 600 ${dotQmailFile}

    ls -l  ${dotQmailFile}
    cat ${dotQmailFile}

    echo "| forward main@${FirstName}.${LastName}.${SubsSelector}.byname.net" > ${bynumberDotQmailFile}

    # There should be a better way instead of qvd-0016
    chown qvd-0016  ${bynumberDotQmailFile}
    #chgrp qmail ${bynumberDotQmailFile}
    chmod 600 ${bynumberDotQmailFile}

   ls -l  ${bynumberDotQmailFile} 
    cat ${bynumberDotQmailFile} 
}


function vis_virDomDelete {

  integer gotVal=0
  bynameAcctAnalyze || gotVal=$?

  if [[ ${gotVal} -eq 0 ]] ; then
    acctName=${byname_acct_acctTypePrefix}-${byname_acct_uid}
    virDomFQDN="${byname_acct_baseDomain}"
    echo "Virtual Domain: ${virDomFQDN} -- AcctId: ${acctName}" 

    # NOTYET
    opDoExit mmaQmailVirDomDelete ${virDomFQDN} ${acctName}
  else
    EH_problem "$0: not enough info."
    return 1
  fi

}


function vis_updateOverWriteQmailFiles {

  integer gotVal=0
  bynameAcctAnalyze || gotVal=$?

  if [[ ${gotVal} -eq 0 ]] ; then

    if ! test -f ${byname_acct_NSPdir}/mailAddrItems.nsp ; then
      /bin/cp ${opSiteControlBase}/${opSiteName}/NSP.mailAcct.sh ${byname_acct_NSPdir}/mailAddrItems.nsp
    fi
    
    #echo "Running:\nmmaQmailAddrs.sh -p acctName=${acctTypePrefix}-${byname_acct_uid} -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -s all -a updateOverwrite"
    opDoComplain mmaQmailAddrs.sh -p acctName=${byname_acct_acctTypePrefix}-${byname_acct_uid} -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -s all -a updateOverwrite
  else
    EH_problem "$0: not enough info."
    return 1
  fi    
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
