#!/bin/bash
#!/bin/bash 

typeset RcsId="$Id: mmaQmailDoms.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
     seedSubjectAction.sh -l $0 $@
     exit $?
fi

G_humanUser=TRUE

. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh
. ${opBinBase}/mmaDnsLib.sh

# ../siteControl/nedaPlus/mmaQmailDomItems.site 
#ItemsFiles=${opSiteControlBase}/${opRunSiteName}/mmaQmailDomItems.site

setBasicItemsFiles mmaQmailDomItems


function vis_examples {
  typeset extraInfo="-v -n showRun"
  #typeset extraInfo=""
    typeset doLibExamples=`doLibExamplesOutput ${G_myName}`
 cat  << _EOF_ 
EXAMPLES:
${doLibExamples} 
INFORMATION ---
${G_myName} -s all -a summary
${G_myName} -s all -a walkObjects
${G_myName} -s qmailDomMain_mailIntra -a walkObjects
${G_myName} -s qmailDomVir_recordsMailIntra -a walkObjects
--- FULL ACTIONS  ---
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullVerify
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullUpdate
${G_myName} ${extraInfo} -s ${opRunHostName} -a fullDelete
--- DNS UPDATE ---
${G_myName} -s qmailDom_mailIntra -a dnsUpdate
--- Update All Accounts for mainDomain ---
${G_myName} -s qmailDomMain_mailIntra -a mainDomAcctsUpdate
${G_myName} -s qmailDomVir_recordsMailIntra -a mainDomAcctsUpdate
--- Virtual Domain Manipulation ---
${G_myName} -n showRun -s qmailDomVir_recordsMailIntra -a virDomUpdate
${G_myName} -s qmailDomMain_mailIntra -a virDomUpdate
--- Update All Addresses for Domain ---
${G_myName} -s qmailDomMain_mailIntra -a addrsUpdate
${G_myName} -s qmailDomVir_recordsMailIntra -a addrsUpdate
${G_myName} -s qmailDomMain_mailIntra -a moreAddrsUpdate
--- List All Addresses For Domain a FQMAs ---
${G_myName} -s qmailDomMain_mailIntra -a acctAddrsFqmaShow
${G_myName} -s qmailDomVir_recordsMailIntra -a acctAddrsFqmaShow
_EOF_
}


function vis_help {
  cat  << _EOF_
For a given acctName specified by acctName, generate
all specified addresses in the addrItemsFile.
_EOF_
}

noSubjectHook() {
  return 0
}


noArgsHook() {
  vis_examples
}



firstSubjectHook() {
  case ${action} in
    "summary")
       typeset -L25 f1=DomainFQDN
       typeset -L13 f2=ServerName
       typeset -L15 f3=DomainType
       typeset f4=VisibleClusters
       print "$f1$f2$f3$f4"
       echo "---------------------------------------------------------------------"
       ;;
    *)
       return
       ;;
  esac
}

lastSubjectHook() {
  case ${action} in
    "summary")
	 echo "---------------------------------------------------------------------"
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
  typeset -L25 v1=${iv_domFQDN}
  typeset -L13 v2=${iv_mmaServerRef}
  typeset -L15 v3=${iv_qmailDom_type}
  typeset v4=${iv_itemScopeVisibleClusters}
  print "${v1}${v2}${v3}${v4}"
}

function do_walkObjects {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  print -- "\n${G_myName}:L1 -- item_${subject}: ${iv_qmailDom_name} =${iv_qmailDom_type} ${iv_qmailDom_serverRef} ${iv_qmailDom_addrsRef}"


  case ${iv_qmailDom_type} in
    "mainDomain")
      typeset thisOne=""
      for thisOne in  ${iv_qmailDomMain_acctsRef[@]} ; do
	print -- "${G_myName}:L2 -- ${thisOne}"
	opDoRet mmaQmailAddrs.sh -s ${thisOne} -a summary
      done
       ;;
    "virDomain")
      typeset acctId=""
      acctId=`opAcctUsers.sh -p acctType=programUser -s ${iv_qmailDomVir_virDomAcctRef} -a prUid`
      typeset acctName=`opAcctUsers.sh -p acctType=programUser -s ${iv_qmailDomVir_virDomAcctRef} -a acctNamePr`
      typeset thisOne=""
      for thisOne in  ${iv_qmailDomVir_addrsListRef[@]} ; do
	print -- "${G_myName}:L2 -- ${thisOne} - acctName=${acctName} - acctId=${acctId}"
	opDoRet mmaQmailAddrs.sh -s ${thisOne} -a summary
      done
       ;;
    *)
       EH_problem "Unknown ${iv_qmailDom_type}"
       return 1
       ;;
  esac
}

function do_fullVerify {
  EH_problem "NOTYET"
}


function do_fullUpdate {
  subjectValidatePrepare

  do_virDomUpdate
  do_addrsUpdate

  #do_dnsUpdate
}


function do_fullDelete {
  subjectValidatePrepare

  EH_problem "NOTYET"
}


function do_dnsUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  #
  # Ignore if not running on an origContentServer
  # NOTYET, improve with opDoAtAs
  #
  opDoExit mmaDnsServerHosts.sh -i hostIsOrigContentServer


  #opDoExit opNetCfg_paramsGet ${opRunClusterName} ${iv_qmailDom_serverRef}
  # ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}

  #opDoRet mmaDnsEntryMxUpdate ${iv_qmailDom_FQDN} ${opNetCfg_ipAddr}
  opDoRet mmaDnsEntryMxUpdate ${iv_qmailDom_FQDN} ${iv_qmailDom_serverRef}
  #opDoRet dnsqr mx ${iv_qmailDom_FQDN}


    opDoComplain mmaDnsServerHosts.sh -v -n showRun -i contentCombineData
    
    if [[ "${G_checkMode}_" != "fast_" ]] ; then
      ANT_raw "G_checkMode=${G_checkMode} -- zonesExport Being Done"
      opDoComplain mmaDnsServerHosts.sh -i zonesExport ${opRunDomainName}
    else
      ANT_raw "G_checkMode=${G_checkMode} -- zonesExport Skipped"
    fi

}


function do_dnsDelete {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  #
  # Ignore if not running on an origContentServer
  # NOTYET, improve with opDoAtAs
  #
  opDoExit mmaDnsServerHosts.sh -i hostIsOrigContentServer


  # NOTYET, ignore subject if not within this cluster

  opDoExit opNetCfg_paramsGet ${opRunClusterName} ${iv_qmailDom_serverRef}
  # ${opNetCfg_ipAddr} ${opNetCfg_netmask} ${opNetCfg_networkAddr} ${opNetCfg_defaultRoute}

  opDoRet mmaDnsEntryMxDelete ${iv_qmailDom_FQDN} ${opNetCfg_ipAddr}
  #opDoRet dnsqr mx ${iv_qmailDom_FQDN}
}

function do_mainDomAcctsUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  typeset thisOne=""

  case ${iv_qmailDom_type} in
    "mainDomain")
      for thisOne in  ${iv_qmailDomMain_acctsRef[@]} ; do
        opDoRet mmaQmailAddrs.sh -s ${thisOne} -a acctUpdate
      done  
       ;;
    "virDomain")
	EH_problem "${subject}: Not a Main Domain - skipped"
	return 1
       ;;
    *)
       EH_problem "Unknown ${iv_qmailDom_type}"
       return 1
       ;;
  esac
}


function do_virDomUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  continueAfterThis

  # Notyet, figure if this is a virtual domain

  if [[ "${iv_qmailDom_type}_" == "mainDomain_" ]] ; then 
    EH_problem "mainDomain ${subject} skipped"
    return 1

  elif [[ "${iv_qmailDom_type}_" == "virDomain_" ]] ; then 

    if [[ "${iv_qmailDomVir_virDomAcctRef}_" != "_" ]] ; then
	opDoComplain opAcctUsers.sh -p acctType=programUser -s ${iv_qmailDomVir_virDomAcctRef} -a verifyAndFix
	acctId=`opAcctUsers.sh -p acctType=programUser -s ${iv_qmailDomVir_virDomAcctRef} -a prUid`
        print -- "Virtual Domain: ${iv_qmailDom_FQDN} -- AcctId: ${acctId}" 
	opDoExit mmaQmailVirDomUpdate ${iv_qmailDom_FQDN} ${acctId}
    else
      EH_problem "Blank iv_qmailDomVir_virDomAcctRef"
    fi
  else
    EH_problem "Bad domain type: ${domainType}"
  fi
}

function do_addrsUpdate {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  typeset thisOne=""

  case ${iv_qmailDom_type} in
    "mainDomain")
       for thisOne in  ${iv_qmailDomMain_acctsRef[@]} ; do
	 opDoRet mmaQmailAddrs.sh -s ${thisOne} -a acctAddrsUpdate
       done 
       ;;
    "virDomain")
      acctName=`opAcctUsers.sh -p acctType=programUser -s ${iv_qmailDomVir_virDomAcctRef} -a prUid`
      for thisOne in  ${iv_qmailDomVir_addrsListRef[@]} ; do
	 opDoRet  mmaQmailAddrs.sh  -p acctName=${acctName} -s ${thisOne} -a addrUpdate
      done
       ;;
    *)
       EH_problem "Unknown ${iv_qmailDom_type}"
       return 1
       ;;
  esac
}

function do_moreAddrsUpdate {
  subjectValidatePrepare

  typeset thisOne=""

  for thisOne in  ${iv_qmailDom_moreAddrsContainers[@]} ; do
    if [[ -f ${opSiteControlBase}/${opRunSiteName}/${thisOne} ]] ; then 
      opDoComplain mmaQmailAddrs.sh -p addrItemsFile="${opSiteControlBase}/${opRunSiteName}/${thisOne}" -s  ${iv_qmailDom_moreAcctAddrsRef} -a acctAddrsUpdate
    else
      EH_problem "${opSiteControlBase}/${opRunSiteName}/${thisOne} -- Not Found. Skipped"
    fi
  done

  #for thisOne in  ${iv_qmailDom_moreAddrsRefs[@]} ; do
    # opDoComplain mmaQmailAddrs.sh -p addrItemsFile="${byname_acct_NSPdir}/mailAddrItems.nsp" -p acctName="${byname_acct_acctTypePrefix}-${byname_acct_uid}" -s all -a addrUpdate
  #done

  case ${iv_qmailDom_type} in
    "mainDomain")
		  # So we can check against 
		  # validity of aliases
		  doNothing
       ;;
    "virDomain")
		 doNothing
       ;;
    *)
       EH_problem "Unknown ${iv_qmailDom_type}"
       return 1
       ;;
  esac
}




function do_acctAddrsFqmaShow {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}

  typeset thisOne=""

  case ${iv_qmailDom_type} in
    "mainDomain")
       for thisOne in  ${iv_qmailDomMain_acctsRef[@]} ; do
	 opDoRet  mmaQmailAddrs.sh -p domainPart=${iv_qmailDom_FQDN} -p domainType=${iv_qmailDom_type} -s ${thisOne} -a acctAddrsFqmaShow
       done 
       ;;
    "virDomain")
      acctName=`opAcctUsers.sh -p acctType=programUser -s ${iv_qmailDomVir_virDomAcctRef} -a prUid`
      for thisOne in  ${iv_qmailDomVir_addrsListRef[@]} ; do
	 opDoRet  mmaQmailAddrs.sh -p domainPart=${iv_qmailDom_FQDN} -p domainType=${iv_qmailDom_type} -p acctName=${acctName} -s ${thisOne} -a acctAddrsFqmaShow
      done
       ;;
    *)
       EH_problem "Unknown ${iv_qmailDom_type}"
       return 1
       ;;
  esac
}




function do_schemaVerify {
  targetSubject=item_${subject}
  subjectValidVerify
  ${targetSubject}
  print "NOTYET"
  return 1
}

