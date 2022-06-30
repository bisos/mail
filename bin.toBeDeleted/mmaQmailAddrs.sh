#!/bin/bash 
#!/bin/bash

typeset RcsId="$Id: mmaQmailAddrs.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
    seedSubjectAction.sh -l $0 "$@"
    exit $?
fi


G_humanUser=TRUE

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/mmaLib.sh
# ./mmaQmailLib.sh 
. ${mailBinBase}/mmaQmailLib.sh

# PRE parameters

typeset -t acctName="nil"
typeset -t addrItemsFile="nil"

typeset -t domainPart="nil"
typeset -t domainType="nil"

typeset -t FQMA="nil"  # localPart@domainPart
typeset -t localPart="nil"

typeset -t mbox=""
typeset -t maildir=""
typeset -t forwards=""
typeset -t progs=""

setBasicItemsFiles mmaQmailAddrItems

function G_postParamHook {
  if [[  "${addrItemsFile}_" != "nil_" ]] ; then
    ItemsFiles=${addrItemsFile}
  fi
}

function vis_examples {
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""
    typeset doLibExamples=`doLibExamplesOutput ${G_myName} ${extraInfo}`
 cat  << _EOF_ 
EXAMPLES:
${doLibExamples} 
--- INFORMATION ---
${G_myName} ${extraInfo} -i summary
${G_myName} ${extraInfo} -s qmailAcctsList_mailIntra -a summary 
mmaQmailAddrs.sh -s qmailAcct_alias -a summary    
mmaQmailAddrs.sh -s qmailAddr_postmaster -a summary  
mmaQmailAddrs.sh -p addrItemsFile=/acct/subs/2/simpson/homer19/NSP/mailAddrItems.nsp -s all -a summary
--- ACCOUNT MANIPULATION ---
${G_myName} ${extraInfo} -p acctName=alias -i acctVerify
${G_myName} ${extraInfo} -p acctName=alias -i acctUpdate
${G_myName} ${extraInfo} -p acctName=alias -i acctDelete
${G_myName} ${extraInfo} -s qmailAcctsList_mailIntra -a acctUpdate
${G_myName} ${extraInfo} -s qmailAcct_alias -a acctUpdate
--- ADDRESS MANIPULATION  ---
${G_myName} ${extraInfo} -p acctName=alias -p localPart=nobody -p mbox=archive -i addrVerify
${G_myName} ${extraInfo} -p acctName=alias -p localPart=nobody -p mbox=archive -i addrUpdate
${G_myName} ${extraInfo} -f -p acctName=alias -p localPart=nobody -p mbox=archive -i addrUpdate
${G_myName} ${extraInfo} -p FQMA=webmaster@mail.intra -p mbox=Mbox -i addrUpdate
${G_myName} ${extraInfo} -p acctName=xxx -p localPart=list-some -i addrDelete
${G_myName} ${extraInfo} -s qmailAcctsList_mailIntra -a addrUpdate
${G_myName} ${extraInfo} -f -s qmailAcctsList_mailIntra -a addrUpdate
${G_myName} ${extraInfo} -s qmailAcct_alias -a addrUpdate
${G_myName} ${extraInfo} -p acctName=alias -s qmailAddr_postmaster -a addrUpdate
--- SPAM/Maildrop CONTROL ---
${G_myName} ${extraInfo}    -p acctName=mohsen -p localPart=mohsen-public -p maildir=mmaMailDir/public -i addrSpamUpdate
${G_myName} ${extraInfo} -f -p acctName=mohsen -p localPart=mohsen-public -p maildir=mmaMailDir/public -i addrSpamUpdate
${G_myName} ${extraInfo} -s qmailAcct_alias -a addrSpamUpdate
--- ACCT/ADDR MANIPULATION ---
${G_myName} ${extraInfo} -s qmailAcctsList_mailIntra -a acctAddrsUpdate
${G_myName} ${extraInfo} -s qmailAcct_alias -a acctAddrsUpdate
--- ACCOUNT VIRTUAL DOMAIN MANIPULATION ---
${G_myName} ${extraInfo} -p domainPart=gnats.mail.intra -p acctName=qvd-0001 -i virDomVerify
${G_myName} ${extraInfo} -p domainPart=gnats.mail.intra -p acctName=qvd-0001 -i virDomUpdate
${G_myName} ${extraInfo} -p domainPart=gnats.mail.intra -p acctName=qvd-0001 -i virDomDelete
${G_myName} ${extraInfo} -p domainPart=gnats.mail.intra -p domainType=virDomain -s qmailAcctsList_gnatsMailIntra -a acctAddrsVirDomUpdate
--- ACCOUNT FQMA  ITEM ADDRESS GENERATION ---
${G_myName} ${extraInfo} -p acctName=alias -i addrsFqmaShow
${G_myName} ${extraInfo} -p acctName=gnats -i addrsFqmaShow
${G_myName} ${extraInfo} -p domainPart=mail.intra -p domainType=mainDomain -s qmailAcctsList_mailIntra -a acctAddrsFqmaShow
${G_myName} ${extraInfo} -p domainPart=mail.intra -p domainType=mainDomain -s qmailAcct_alias -a acctAddrsFqmaShow
${G_myName} ${extraInfo} -p domainPart=mail.intra -p domainType=mainDomain -p acctName=alias -s qmailAddr_postmaster -a addrFqmaShow
--- ADDR Control File Show ---
${G_myName} ${extraInfo} -p FQMA=webmaster@mail.intra -i addrCtlFileShow
${G_myName} ${extraInfo} -p acctName=alias -p localPart=postmaster  -i addrCtlFileShow
${G_myName} ${extraInfo} -p acctName=alias -p localPart=some  -i addrCtlFileUpdate < /tmp/t1
${G_myName} ${extraInfo} -p acctName=alias -p localPart=some  -f -i addrCtlFileUpdate < /tmp/t1
--- ON-HOLD/Resume ---
${G_myName} ${extraInfo} -p acctName=alias  -i acctDeliveryOnHold
${G_myName} ${extraInfo} -p acctName=alias  -i acctDeliveryResume
${G_myName} ${extraInfo} -p acctName=alias -p localPart=postmaster  -i acctAddrDeliveryOnHold
${G_myName} ${extraInfo} -p acctName=alias -p localPart=postmaster  -i acctAddrDeliveryResume
--- ACCOUNT+ADDR Test ---
${G_myName} ${extraInfo} -p acctName=alias -p localPart=postmaster  -i acctAddrDeliveryTestShow
--- See Also ---
${G_myName} ${extraInfo} -p acctName=alias -p localPart=postmaster  -i acctAddrDeliveryTestShow
_EOF_
}


function vis_help {
  cat  << _EOF_
   
Account Processing:
===================
   vis_acct{Manipulate}:        -p acctName
   do_acct{Manipulate}:         -s qmailAcctsList_
                                -s qmailAcct_

   ** Manipulate an account entry as locDeliveryAcct
      in ${qmailVarDir}/users/

Address Processing:
===================
   vis_addr{Manipulate}:        -p acctName -p localPart -p mbox,forward,progs
                                -p FQMA -p mbox,forward,progs
   do_addr{Manipulate}:         -s qmailAddrsList_
                                -s qmailAddr_

   ** Manipulate an addr by editing the dotQmailFile


Account/Address Processing:
===========================
   do_acctAddrs{Manipulate}:    -s qmailAcctsList_
                                -s qmailAcct_

   ** Manipulate an account entry as locDeliveryAcct
      in ${qmailVarDir}/users/
      and manipulate addresses asscoiated with the account.


Account VirDom Manipulate:
==========================
   vis_virDom{Manipulate}:     -p acctName -p domainPart

   do_acctAddrsVirDom{Manipulate}:
                             -s qmailAcctsList_
                             -s qmailAcct_

   ** Manipulate a virtual domain


Address ControlFile Show:
==========================
   vis_addrCtlFileShow :        -p acctName -p localPart
                                -p FQMA 

   do_addrCtlFileShow :        -p acctName -s qmailAddr_

   ** Show the dotQmailFile for an address


Account Addresses FQMA Show:
============================
   vis_addrsFqmaShow:        -p acctName 

   do_acctAddrsFqmaShow:     -s qmailAcctsList_
                             -s qmailAcct_
                             -s qmailAddrList_

   ** Show all addresses corresponding to 
      an account in FQMA format.

_EOF_
}

noSubjectHook() {
  return 0
}


noArgsHook() {
  vis_examples
}


function vis_summary {
  
  typeset itemsList=""
  itemsList=`typeset +f | egrep '^item_qmailAcctsList_'`
 
  typeset thisItem=""
  for thisItem in  ${itemsList} ; do
    subject=${thisItem##item_} 
    do_summary
  done
}

function do_summary {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  case ${iv_itemId} in
    'qmailAcctsList')
       print -- "\n${G_myName}:L1 -- item_${subject}"
       print -- "     ${iv_qmailAcctsList[@]}"
       typeset thisOne=""
       for thisOne in  ${iv_qmailAcctsList[@]} ; do
	 item_qmailAcct_${thisOne}
	 print -- "          ${iv_qmailAcctName} -- ${iv_qmailAcctAddrsList[@]}"
	 typeset thisOne2=""
	 for thisOne2 in  ${iv_qmailAcctAddrsList[@]} ; do
	   item_qmailAddr_${thisOne2}
      
	   print -- "               ${iv_qmailAddr_itemName} -- ${iv_qmailAddr_mbox}"
	 done
       done
       ;;
    'qmailAddrsList')
       print -- "\n${G_myName}:L1 -- item_${subject}"
       print -- "     ${iv_qmailAddrsList[@]}"
       typeset thisOne=""
       for thisOne in  ${iv_qmailAddrsList[@]} ; do
	 item_qmailAddr_${thisOne}
	 
	 print -- "               ${iv_qmailAddr_itemName} -- ${iv_qmailAddr_mbox}"
       done
       ;;
    'qmailAcct')
       print -- "          ${iv_qmailAcctName} -- ${iv_qmailAcctAddrsList[@]}"
       typeset thisOne2=""
       for thisOne2 in  ${iv_qmailAcctAddrsList[@]} ; do
	 item_qmailAddr_${thisOne2}
	 print -- "               ${iv_qmailAddr_itemName} -- ${iv_qmailAddr_mbox}"
       done
       ;;
    'qmailAddr')
       print -- "                 ${iv_qmailAddr_itemName} -- ${iv_qmailAddr_mbox} -- ${iv_qmailAddr_mailDir} -- ${iv_qmailAddr_forwards}"
       ;;
    *)
       EH_problem "Unknown itemId: ${iv_itemId}"
       exit 1
       ;;
  esac

  return 0
}

#
# Account Processing:
# ===================
#    vis_acct{Manipulate}:        -p acctName
#    do_acct{Manipulate}:         -s qmailAcctsList_
#                                 -s qmailAcct_
#
#    ** Manipulate an account entry as locDeliveryAcct
#       in ${qmailVarDir}/users/
#

function vis_acctUpdate {
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  continueAfterThis

  opDoExit opAcctInfoGet ${acctName}
  opDoExit mmaQmailLocDeliveryAcctAdd ${acctName}
  
  return 0
}

function vis_acctVerify {
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoExit opAcctInfoGet ${acctName}
  opDoExit mmaQmailLocDeliveryAcctVerify ${acctName}
  
  return 0
}

function vis_acctDelete {
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoExit opAcctInfoGet ${acctName}
  opDoExit mmaQmailLocDeliveryAcctDelete ${acctName}
  
  return 0
}

function vis_acctDeliveryStatus {
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoExit opAcctInfoGet ${acctName}

  findResult=$( find ${opAcct_homeDir} -maxdepth 0 -perm -01000 )
  if [[ ${findResult} == ${opAcct_homeDir} ]] ; then
    ANT_raw "Sticky Bit Set, Delivery is On Hold"
    opDo ls -ld ${opAcct_homeDir}
  else
    ANT_raw "Sticky Bit NOT Set, Normal Delivery"
    opDo ls -ld ${opAcct_homeDir}
  fi
  
  return 0
}

function vis_acctDeliveryOnHold {
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoExit opAcctInfoGet ${acctName}

  opDo chmod +t ${opAcct_homeDir}
  opDo ls -ld ${opAcct_homeDir}
  
  return 0
}

function vis_acctDeliveryResume {
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoExit opAcctInfoGet ${acctName}

  opDo chmod -t ${opAcct_homeDir}
  opDo ls -ld ${opAcct_homeDir}
  
  return 0
}

function vis_acctAddrDeliveryOnHold {
  EH_assert [[ "${acctName}_" != "nil_" ]]
  EH_assert [[ "${localPart}_" != "nil_" ]]
  EH_assert [[ "${localPart}_" != "_" ]]
  EH_assert [[ "${acctName}_" != "_" ]]

  opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart}

  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  if [[ -f ${dotQmailFile} ]] ;  then
    opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}

    # NOTYET, return a temporary error for that addr
    genDotQmailOnHoldFile ${dotQmailFile}
  fi
}

function vis_acctAddrDeliveryResume {
  EH_assert [[ "${acctName}_" != "nil_" ]]
  EH_assert [[ "${localPart}_" != "nil_" ]]
  EH_assert [[ "${localPart}_" != "_" ]]
  EH_assert [[ "${acctName}_" != "_" ]]

  opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart}

  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  if [[ -f ${dotQmailFile} ]] ;  then
    opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}

    # NOTYET, return a temporary error for that addr
    # NOTYET
  fi
}

function vis_acctAddrDeliveryTestShow {
  EH_assert [[ "${acctName}_" != "nil_" ]]
  EH_assert [[ "${localPart}_" != "nil_" ]]
  EH_assert [[ "${localPart}_" != "_" ]]
  EH_assert [[ "${acctName}_" != "_" ]]

  # NOTYET, natural domain and virdom may work different
  # May need one for bynameNspQmail
  # 
  #opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart}
  opDoExit opAcctInfoGet ${acctName}

  mmaQmail_dotQmailFile=${opAcct_homeDir}/.qmail
  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  EH_assert [[ -f ${dotQmailFile}-${localPart} ]]

  opDo eval "qmail-local -n ${opAcct_name} ${opAcct_homeDir} ${opAcct_name} '-' '${localPart}' '' '' ${dotQmailFile}"
}


function do_acctUpdate {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  if [[ "${iv_itemId}_" == "qmailAcctsList_" ]] ; then 
    TM_trace 7 "${iv_qmailAcctsList[@]}"
    typeset thisOne=""
    typeset qmailAcctsList=${iv_qmailAcctsList[@]}
    for thisOne in  ${qmailAcctsList[@]} ; do
      print -- "Processing item_qmailAcct_${thisOne}"
      subject=qmailAcct_${thisOne}
      do_acctUpdate
    done
    return 0
  fi

  EH_assert [[  "${iv_itemId}_" == "qmailAcct_" ]]

  opDoExit opAcctInfoGet ${iv_qmailAcctName}
  opDoExit mmaQmailLocDeliveryAcctAdd ${iv_qmailAcctName}
}

#
# Address Processing:
# ===================
#    vis_addr{Manipulate}:        -p acctName -p localPart -p mbox,forward,progs
#                                 -p FQMA -p mbox,forward,progs
#    do_addr{Manipulate}:         -s qmailAddrsList_
#                                 -s qmailAddr_
#
#    ** Manipulate an addr by editing the dotQmailFile
#


function vis_addrUpdate {
  # Given either acctName an localPart
  # or FQMA, update corresponding CtlFile

  continueAfterThis

  if [[ "${FQMA}_" != "_" && "${FQMA}_" != "nil_" ]] ; then
    opDoExit mmaQmailFqmaAnalyze "${FQMA}"
  else
    EH_assert [[ "${acctName}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "_" ]]
    EH_assert [[ "${acctName}_" != "_" ]]

    opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart}
  fi

  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  if [[ -f ${dotQmailFile} ]] ;  then
    if [[ "${G_forceMode}_" == "force_" ]] ; then
      opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}

      genDotQmailFileMbox ${dotQmailFile}

    else
      ANV_raw "${dotQmailFile} exists -- Skipped."
    fi
  else
   genDotQmailFileMbox ${dotQmailFile}
  fi

  typeset acctQmailBaseDir=${opAcct_homeDir}

#   if [[ ! -d ${acctQmailBaseDir}/mail ]] ; then
#     FN_dirCreatePathIfNotThere ${acctQmailBaseDir}/mail
#   fi

#   opDoRet chmod 700 ${acctQmailBaseDir}/mail
#   opDoRet chown ${opAcct_name} ${acctQmailBaseDir}/mail
  
#   if [[ ! -d ${acctQmailBaseDir}/mail/lists ]] ; then
#     FN_dirCreatePathIfNotThere ${acctQmailBaseDir}/mail/lists
#   fi

#   opDoRet chmod 700 ${acctQmailBaseDir}/mail/lists
#   opDoRet chown ${opAcct_name} ${acctQmailBaseDir}/mail/lists
  
  opDoRet chmod 600 ${dotQmailFile}
  opDoRet chown ${opAcct_name} ${dotQmailFile}
    
  #opDoRet ls -l  ${dotQmailFile}
  #opDoRet cat  ${dotQmailFile}
}

# To support vis_ functions
function genDotQmailFileMbox {
  EH_assert [[ $# -eq 1 ]]

  typeset dotQmailFile=$1

  if [[ "${mbox}_" == "_" && "${maildir}_" == "_" ]] ; then
    EH_problem "${mbox}_ and ${maildir}_"
    return 1
  fi

  if [[ "${mbox}_" != "_" && "${maildir}_" != "_" ]] ; then
    EH_problem "${mbox}_ and ${maildir}_"
    return 1
  fi

  typeset i=""
  for i in "${mbox}" ;  do
    opDoRet eval "( echo \"./${i}\" > ${dotQmailFile} )"
  done

  typeset acctQmailBaseDir=${opAcct_homeDir}

#set -x
  typeset i=""
  for i in ${maildir} ;  do
    typeset dirsPart=`FN_dirsPart ${i}`
    typeset nonDirsPart=`FN_nonDirsPart ${i}`
    if [[ "${dirsPart}_" != "_" ]] ; then 
      if [[ ! -d ${acctQmailBaseDir}/${dirsPart} ]] ; then
	FN_dirCreatePathIfNotThere ${acctQmailBaseDir}/${dirsPart}
	opDoRet chmod 700 ${acctQmailBaseDir}/${dirsPart}
	opDoRet chown ${opAcct_name} ${acctQmailBaseDir}/${dirsPart}
      fi
    fi

    if [[ ! -d ${acctQmailBaseDir}/${i} ]] ; then
      opDoComplain ${qmailMaildirmakeProgram} ${acctQmailBaseDir}/${i}
      opDoRet chown -R ${opAcct_name} ${acctQmailBaseDir}/${i}
    fi

    opDoRet eval "( echo \"./${i}/\" > ${dotQmailFile} )"
  done
  
  for i in ${forwards} ; do
    opDoRet eval "( echo \"| forward ${i}\" >> ${dotQmailFile} )"
  done

  for i in "${progs[@]}" ; do
    if [[ "${i}_" == "_" ]] ; then
	break;
    fi
    opDoRet eval "( echo \"| ${i}\" >> ${dotQmailFile} )"
  done
}


# To support do_ functions
function genDotQmailFile {
  #set -x
  EH_assert [[ $# -eq 1 ]]

  typeset dotQmailFile=$1

#   if [[ "${iv_qmailAddr_mbox}_" == "_" && "${iv_qmailAddr_mailDir}_" == "_" ]] ; then
#     EH_problem "${iv_qmailAddr_mbox}_ and ${iv_qmailAddr_mailDir}_"
#     return 1
#   fi

  if [[ "${iv_qmailAddr_mbox}_" != "_" && "${iv_qmailAddr_mailDir}_" != "_" ]] ; then
    EH_problem "${iv_qmailAddr_mbox}_ and ${iv_qmailAddr_mailDir}_"
    return 1
  fi


  typeset i=""
  for i in ${iv_qmailAddr_mbox} ;  do
    opDoRet eval "( echo \"./${i}\" > ${dotQmailFile} )"
  done

  typeset acctQmailBaseDir=${opAcct_homeDir}

#set -x
  typeset i=""
  for i in ${iv_qmailAddr_mailDir} ;  do
    typeset dirsPart=`FN_dirsPart ${i}`
    typeset nonDirsPart=`FN_nonDirsPart ${i}`
    if [[ "${dirsPart}_" != "_" ]] ; then 
      if [[ ! -d ${acctQmailBaseDir}/${dirsPart} ]] ; then
	FN_dirCreatePathIfNotThere ${acctQmailBaseDir}/${dirsPart}
	opDoRet chmod 700 ${acctQmailBaseDir}/${dirsPart}
	opDoRet chown ${opAcct_name} ${acctQmailBaseDir}/${dirsPart}
      fi
    fi

    if [[ ! -d ${acctQmailBaseDir}/${i} ]] ; then
      opDoComplain ${qmailMaildirmakeProgram} ${acctQmailBaseDir}/${i}
      opDoRet chown -R ${opAcct_name} ${acctQmailBaseDir}/${i}
    fi

    opDoRet eval "( echo \"./${i}/\" > ${dotQmailFile} )"
  done

  #for i in ${iv_qmailAddr_archive} ; do
  #FN_dirCreatePathIfNotThere ${acctQmailBaseDir}/mailArchives
  #echo "${acctQmailBaseDir}/mailArchives/${i}" >> ${dotQmailFile}
  #done

  for i in ${iv_qmailAddr_forwards} ; do
    opDoRet eval "( echo \"| forward ${i}\" >> ${dotQmailFile} )"
  done
  
  for i in "${iv_qmailAddr_progs[@]}" ; do
    if [[ "${i}_" == "_" ]] ; then
	break;
    fi
    opDoRet eval "( echo \"| ${i}\" >> ${dotQmailFile} )"
  done

  typeset thisFunc=""
  #thisFunc=`typeset +f | egrep '^iv_qmailAddr_func$'`
  thisFunc=`typeset +f | egrep '^iv_qmailAddr_func'`  
  if [ "${thisFunc}_" != "_" ] ; then
    iv_qmailAddr_func
  fi
}

function do_addrUpdate {

  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  if [[ "${iv_itemId}_" == "qmailAddrsList_" ]] ; then 
    TM_trace 7 "${iv_qmailAddrsList[@]}"
    typeset thisOne=""
    for thisOne in  ${iv_qmailAddrsList[@]} ; do
      subject=qmailAddr_${thisOne}
      do_addrUpdate
    done
    return 0
  fi

  #EH_assert [[ "${iv_itemId}_" == "qmailAddr_" ]]

  if [ ! -z "${iv_qmailAcctName}" ] ; then
      acctName=${iv_qmailAcctName}
  fi

  EH_assert [[ "${acctName}_" != "_" ]]
  EH_assert [[ "${acctName}_" != "nil_" ]]

  opAcctInfoGet ${acctName}

 TM_trace 7 "${iv_qmailAddr_itemName} opAcct_homeDir=${opAcct_homeDir}"

 typeset dotQmailFile=""
 if [[ "${iv_qmailAddr_itemName}_" == "justDotQmail_" ]] ; then 
   dotQmailFile=${opAcct_homeDir}/.qmail
 else
   dotQmailFile=${opAcct_homeDir}/.qmail-${iv_qmailAddr_itemName}
 fi

 if [[ -f ${dotQmailFile} ]] ;  then
   if [[ "${G_forceMode}_" == "force_" ]] ; then
     opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}
   
     genDotQmailFile ${dotQmailFile}
   else
     ANV_raw "${dotQmailFile} exists -- Skipped."
   fi
 else
   genDotQmailFile ${dotQmailFile}
 fi

#  if [[ ! -d ${opAcct_homeDir}/mail ]] ; then
#    FN_dirCreatePathIfNotThere ${opAcct_homeDir}/mail
#  fi

#  opDoRet chmod 700 ${opAcct_homeDir}/mail
#  opDoRet chown ${opAcct_name}:${opAcct_gid} ${opAcct_homeDir}/mail
   
#  if [[ ! -d ${opAcct_homeDir}/mail/lists ]] ; then
#    FN_dirCreatePathIfNotThere ${opAcct_homeDir}/mail/lists
#  fi

#  opDoRet chmod 700 ${opAcct_homeDir}/mail/lists
#  opDoRet chown ${opAcct_name}:${opAcct_gid} ${opAcct_homeDir}/mail/lists
   
 opDoRet chmod 600 ${dotQmailFile}
 opDoRet chown ${opAcct_name} ${dotQmailFile}

 #return 1
   
 #opDoRet ls -l  ${dotQmailFile}
 #opDoRet cat  ${dotQmailFile}
}

function do_addrDelete {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

 EH_assert [[ "${iv_itemId}_" == "qmailAddr_" ]]
 EH_assert [[ "${acctName}_" != "_" ]]

 opAcctInfoGet ${acctName}

 TM_trace 7 "${iv_qmailAddr_itemName} opAcct_homeDir=${opAcct_homeDir}"

 typeset dotQmailFile=""
 if [[ "${iv_qmailAddr_itemName}_" == "justDotQmail_" ]] ; then 
   dotQmailFile=${opAcct_homeDir}/.qmail
 else
   dotQmailFile=${opAcct_homeDir}/.qmail-${iv_qmailAddr_itemName}
 fi

 if [[ -f ${dotQmailFile} ]] ;  then
   if [[ "${G_forceMode}_" == "force_" ]] ; then
     opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}
   else
     print "${dotQmailFile} exist.  Are you sure you want to delete? Run again using the -f."
     return 0
   fi
fi

}

#
# Account/Address Processing:
# ===========================
#    do_acctAddrs{Manipulate}:    -s qmailAcctsList_
#                                 -s qmailAcct_
#
#    ** Manipulate an account entry as locDeliveryAcct
#       in ${qmailVarDir}/users/
#       and manipulate addresses asscoiated with the account.
#


function do_acctAddrsUpdate {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  if [[ "${iv_itemId}_" == "qmailAcctsList_" ]] ; then 
    TM_trace 7 "${iv_qmailAcctsList[@]}"
    typeset thisOne=""
    typeset qmailAcctsList=${iv_qmailAcctsList[@]}
    TM_trace 7 "${iv_qmailAcctsList[@]} -- ${qmailAcctsList}"
    for thisOne in  ${qmailAcctsList[@]} ; do
      TM_trace 7 "Processing item_qmailAcct_${thisOne}"
      subject=qmailAcct_${thisOne}
      do_acctAddrsUpdate
    done
    return 0
  fi

  EH_assert [[  "${iv_itemId}_" == "qmailAcct_" ]]

  TM_trace 7 "${iv_qmailAcctName} ${iv_qmailAcctAddrsList[@]}"
  opDoExit opAcctInfoGet ${iv_qmailAcctName}
  opDoExit mmaQmailLocDeliveryAcctAdd ${iv_qmailAcctName}


  typeset thisOne2=""
  for thisOne2 in  ${iv_qmailAcctAddrsList[@]} ; do
    TM_trace 7 "Processing item_qmailAddr_${thisOne2}"

    acctName=${iv_qmailAcctName}
    subject=qmailAddr_${thisOne2}

    do_addrUpdate
  done
}

#
# Account VirDom Manipulate:
# ==========================
#    vis_virDom{Manipulate}:     -p acctName -p domainPart
#
#    do_acctAddrsVirDom{Manipulate}:
#                              -s qmailAcctsList_
#                              -s qmailAcct_
#
#    ** Manipulate a virtual domain
#

function vis_virDomVerify {
  EH_assert [[  "${domainPart}_" != "nil_" ]]
  EH_assert [[  "${domainPart}_" != "_" ]]
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoRet mmaQmailVirDomVerify ${domainPart} ${acctName}
  return 0
}

function vis_virDomUpdate {
  EH_assert [[  "${domainPart}_" != "nil_" ]]
  EH_assert [[  "${domainPart}_" != "_" ]]
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoRet mmaQmailVirDomUpdate ${domainPart} ${acctName}
  return 0
}

function vis_virDomDelete {
  EH_assert [[  "${domainPart}_" != "nil_" ]]
  EH_assert [[  "${domainPart}_" != "_" ]]
  EH_assert [[  "${acctName}_" != "nil_" ]]
  EH_assert [[  "${acctName}_" != "_" ]]

  opDoRet mmaQmailVirDomDelete ${domainPart} ${acctName}
  return 0
}

function do_acctAddrsVirDomUpdate {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  if [[ "${iv_itemId}_" == "qmailAcctsList_" ]] ; then 
    TM_trace 7 "${iv_qmailAcctsList[@]}"

    typeset thisOne=""
    typeset qmailAcctsList=${iv_qmailAcctsList[@]}
    TM_trace 7 "${iv_qmailAcctsList[@]} -- ${qmailAcctsList}"
    for thisOne in  ${qmailAcctsList[@]} ; do
	TM_trace 7 "Processing item_qmailAcct_${thisOne}"
	subject=qmailAcct_${thisOne}
	do_acctAddrsVirDom
    done
    return 0
  fi

  EH_assert [[  "${iv_itemId}_" == "qmailAcct_" ]]

  TM_trace 7 "${iv_qmailAcctName} ${iv_qmailAcctAddrsList[@]}"
  opDoExit opAcctInfoGet ${iv_qmailAcctName}

  mmaQmailLocDeliveryAcctAdd ${iv_qmailAcctName}
  mmaQmailVirDomEntryAdd ${domainPart} ${iv_qmailAcctName}
  mmaQmailRcpthostsEntryAdd ${domainPart}
}

#
# Address ControlFile Show:
# ==========================
#    vis_addrCtlFileShow :        -p acctName -p localPart
#                                 -p FQMA 
#
#    do_addrCtlFileShow :        -p acctName -s qmailAddr_
#
#    ** Show the dotQmailFile for an address
#


function vis_addrCtlFileShow {
  # Given either acctName an localPart
  # or FQMA, show corresponding CtlFile

  #set -x

  if [[ "${FQMA}_" != "_" && "${FQMA}_" != "nil_" ]] ; then
    opDoExit mmaQmailFqmaAnalyze "${FQMA}"
  else
    EH_assert [[ "${acctName}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "_" ]]
    EH_assert [[ "${acctName}_" != "_" ]]

    opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart} 2> /dev/null 1> /dev/null
  fi

  #opDoComplain ls -l  ${mmaQmail_dotQmailFile} 2> /dev/null
  opDo cat  ${mmaQmail_dotQmailFile}
}


function vis_addrCtlFileUpdate {
  # Given either acctName an localPart
  # or FQMA, show corresponding CtlFile

  #set -x

  if [[ "${FQMA}_" != "_" && "${FQMA}_" != "nil_" ]] ; then
    opDoExit mmaQmailFqmaAnalyze "${FQMA}"
  else
    EH_assert [[ "${acctName}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "_" ]]
    EH_assert [[ "${acctName}_" != "_" ]]

    opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart}
  fi

  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  if [[ -f ${dotQmailFile} ]] ;  then
    if [[ "${G_forceMode}_" == "force_" ]] ; then
      opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}
    else
      ANV_raw "${dotQmailFile} exists -- Skipped."
    fi
  fi

  cat - >  ${dotQmailFile}

  
  opDoRet chmod 600 ${dotQmailFile}
  opDoRet chown ${opAcct_name} ${dotQmailFile}

  opDo ls -l ${dotQmailFile}
}

#
# Account Addresses FQMA Show:
# ============================
#    vis_addrsFqmaShow:        -p acctName 
#
#    do_acctAddrsFqmaShow:     -s qmailAcctsList_
#                              -s qmailAcct_
#
#    ** Show all addresses as Fqma corresponding to 
#       an account
# 

function vis_addrsFqmaShow {
  #set -x
  # Given an acctName produce all FQMAs

  EH_assert [[ "${acctName}_" != "_" ]]
  EH_assert [[ "${acctName}_" != "nil_" ]]

  opDoExit opAcctInfoGet ${acctName}

  opDoExit  mmaQmailLocDeliveryAcctVerify ${acctName}

  opDoExit mmaQmailAccountAnalyze ${acctName}
  typeset domainType="${mmaQmail_domainType}"
  typeset domainPart="${mmaQmail_domainPart}"

  typeset dotQmailFiles=`(cd ${opAcct_homeDir};  echo .qmail*)`
  typeset thisLocalPart=""
  typeset thisOne=""
    
  if [[ "${domainType}_" == "mainDomain_" ]] ; then 
    thisOne=""
    for thisOne in  ${dotQmailFiles} ; do
      thisLocalPart=${thisOne##.qmail}
      print ${acctName}${thisLocalPart}@${domainPart}:${domainType}:${acctName}
    done

  elif [[ "${domainType}_" == "virDomain_" ]] ; then 
    thisOne=""
    for thisOne in  ${dotQmailFiles} ; do
      thisLocalPart=${thisOne##.qmail-}
      print ${thisLocalPart}@${domainPart}:${domainType}:${acctName}
    done

  else
    EH_problem "Bad domain type: ${domainType}"
  fi
}


function do_addrFqmaShow {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

 EH_assert [[ "${iv_itemId}_" == "qmailAddr_" ]]
 EH_assert [[ "${acctName}_" != "_" ]]

 opDoExit opAcctInfoGet ${acctName}

 if [[ "${domainType}_" == "mainDomain_" ]] ; then 
   if [[ "${acctName}_" == "alias_" ]] ; then 
     print ${iv_qmailAddr_itemName}@${domainPart} # -- ${acctName}
   fi

   if [[ "${iv_qmailAddr_itemName}_" == "justDotQmail_" ]] ; then 
     print ${acctName}@${domainPart} # -- ${acctName}
   fi
 elif [[ "${domainType}_" == "virDomain_" ]] ; then 
     print ${iv_qmailAddr_itemName}@${domainPart} # -- ${acctName}
 else
   EH_problem "Bad domain type: ${domainType}"
 fi
}


function do_acctAddrsFqmaShow {
  #set -x
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  if [[ "${iv_itemId}_" == "qmailAcctsList_" ]] ; then 
    TM_trace 7 "${iv_qmailAcctsList[@]}"

    typeset thisOne=""
    typeset qmailAcctsList=${iv_qmailAcctsList[@]}
    TM_trace 7 "${iv_qmailAcctsList[@]} -- ${qmailAcctsList}"
    for thisOne in  ${qmailAcctsList[@]} ; do
	TM_trace 7 "Processing item_qmailAcct_${thisOne}"
	subject=qmailAcct_${thisOne}
	do_acctAddrsFqmaShow
    done
    return 0
  fi

  case ${iv_itemId} in
    "qmailAcct")
       TM_trace 7 "${iv_qmailAcctName} ${iv_qmailAcctAddrsList[@]}"
       opDoExit opAcctInfoGet ${iv_qmailAcctName}

       typeset thisOne2=""
       for thisOne2 in  ${iv_qmailAcctAddrsList[@]} ; do
	 TM_trace 7 "Processing item_qmailAddr_${thisOne2}"

	 acctName=${iv_qmailAcctName}
	 subject=qmailAddr_${thisOne2}

	 do_addrFqmaShow
       done
       ;;
    "qmailAddrsList")
       opDoExit opAcctInfoGet ${acctName}

       typeset thisOne2=""
       for thisOne2 in  ${iv_qmailAddrsList[@]} ; do
	 TM_trace 7 "Processing item_qmailAddr_${thisOne2}"

	 subject=qmailAddr_${thisOne2}

	 do_addrFqmaShow
       done
       ;;
    *)
       EH_problem "Unknown ${iv_itemId}"
       return 1
       ;;
  esac

}


#
# SPAM CONTROL Facilities
#

function vis_addrSpamUpdate {
  # Given maildir
  # either acctName and localPart
  # or FQMA, update corresponding CtlFile
  # and other files for Spam Control
  #
  # For the particular mailCtlFile, SpamAssin
  # is set up, non spam goes to maildir

  # Example: ${G_myName} -f -p acctName=mohsen -p localPart=mohsen-public -p maildir=mmaMailDir/public -i addrSpamUpdate

  if [[ "${FQMA}_" != "_" && "${FQMA}_" != "nil_" ]] ; then
    opDoExit mmaQmailFqmaAnalyze "${FQMA}"
  else
    EH_assert [[ "${acctName}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "nil_" ]]
    EH_assert [[ "${localPart}_" != "_" ]]
    EH_assert [[ "${acctName}_" != "_" ]]

    opDoExit mmaQmailAccountAnalyze ${acctName} ${localPart}
  fi

    EH_assert [[ "${maildir}_" != "nil_" ]]
    EH_assert [[ "${maildir}_" != "_" ]]

  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  if [[ -f ${dotQmailFile} ]] ;  then
    if [[ "${G_forceMode}_" == "force_" ]] ; then
      opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}

      genDotQmailSpamControl ${dotQmailFile}

    else
      ANV_raw "${dotQmailFile} exists -- Skipped."
    fi
  else
   genDotQmailSpamControl ${dotQmailFile}
  fi

  typeset acctQmailBaseDir=${opAcct_homeDir}
  
  opDoRet chmod 600 ${dotQmailFile}
  opDoRet chown ${opAcct_name} ${dotQmailFile}
    
  #opDoRet ls -l  ${dotQmailFile}
  #opDoRet cat  ${dotQmailFile}
}



# To support vis_ functions
function genDotQmailSpamControl {
  EH_assert [[ $# -eq 1 ]]

  typeset dotQmailFile=$1

  # Additionaly in this function, we know
  # acctName, localPart, defaultMailRepository
  # and all parameters that can be derived from the 
  # above basic parameters 

  typeset spamMailRepository=${opAcct_homeDir}/mmaMailDir/spam

  # Make sure the "spam" mailRepository exists
  # Create it, if it does not exist

  if [[ ! -d ${spamMailRepository} ]] ; then
    opDoComplain ${qmailMaildirmakeProgram} ${spamMailRepository}
    opDoRet chown -R ${opAcct_name} ${spamMailRepository}
  fi

  typeset targetMailRepository=${opAcct_homeDir}/${maildir}

  # Make sure the specified maildir targetMailRepository exists
  # Create it, if it does not exist

  if [[ ! -d ${targetMailRepository} ]] ; then
    opDoComplain ${qmailMaildirmakeProgram} ${targetMailRepository}
    opDoRet chown -R ${opAcct_name} ${targetMailRepository}
  fi

  # Put in place the spamassassin  control file
  
  typeset spamassassinRcFile=${opAcct_homeDir}/.spamassassin
  # NOTYET, for now default spamassassin is good enough.

  # Put in place the maildrop control file

  typeset maildropRcFile=${opAcct_homeDir}/.mailfilter

  if [[ -f ${maildropRcFile} ]] ;  then
    if [[ "${G_forceMode}_" == "force_" ]] ; then
      opDoRet FN_fileDefunctMake ${maildropRcFile} ${maildropRcFile}.${dateTag}

      outputMaildropConfig > ${maildropRcFile}
      opDoComplain chown  ${opAcct_name} ${maildropRcFile}
      opDoComplain chmod 700 ${maildropRcFile}

    else
      ANV_raw "${maildropRcFile} exists -- Skipped."
    fi
  else
   outputMaildropConfig > ${maildropRcFile}
   opDoComplain chown  ${opAcct_name} ${maildropRcFile}
   opDoComplain chmod 700 ${maildropRcFile}
  fi


  typeset dotQmailFile=${mmaQmail_dotQmailFile}

  typeset spamassassinProgram=`which spamassassin`
  typeset maildropProgram=`which maildrop`


  if [[ -f ${dotQmailFile} ]] ;  then
    if [[ "${G_forceMode}_" == "force_" ]] ; then
      opDoRet FN_fileDefunctMake ${dotQmailFile} ${dotQmailFile}.${dateTag}

    opDoRet eval "( echo \"|${qmailPrelineProgram} ${spamassassinProgram} | ${maildropProgram}\" > ${dotQmailFile} )"
      opDoRet chmod 600 ${dotQmailFile}
      opDoRet chown ${opAcct_name} ${dotQmailFile}
    else
      ANV_raw "${dotQmailFile} exists -- Skipped."
    fi
  else
    opDoRet eval "( echo \"|${qmailPrelineProgram} ${spamassassinProgram} | ${maildropProgram}\" > ${dotQmailFile} )"
    opDoRet chmod 600 ${dotQmailFile}
    opDoRet chown ${opAcct_name} ${dotQmailFile}
  fi
}


function outputMaildropConfig {
  EH_assert [[ $# -eq 0 ]]

 cat  << _EOF_ 
# MACHINE GENERATED with ${G_myName} and ${m_myName} on ${dateTag}
# -- DO NOT HAND EDIT

#filter rules for maildrop
#make sure this file is without any group and world permissions

if ( /^X-Spam-Status: Yes/:h )
{
	to "${opAcct_homeDir}/mmaMailDir/spam"
	exit
}

to "${opAcct_homeDir}/${maildir}"

_EOF_
}

#
# NOTYET, Also see ~sa-20000/NSP/mailAddrItems.nsp
#

function maildropSpamMboxStdout {
  EH_assert [[ $# -eq 0 ]]

 cat  << _EOF_ 
# MACHINE GENERATED with ${G_myName} and ${m_myName} on ${dateTag}
# -- DO NOT HAND EDIT

#filter rules for maildrop
#make sure this file is without any group and world permissions

if ( /^X-Spam-Status: Yes/:h )
{
        to "${opAcct_homeDir}/mail/spam-${iv_qmailAddr_itemName}"
 	exit
}

to "${opAcct_homeDir}/mail/${iv_qmailAddr_itemName}"
_EOF_
}






