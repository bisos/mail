#!/bin/bash
#!/bin/bash 

typeset RcsId="$Id: lcaQmailAnalogDebPkg.sh,v 1.3 2020-02-03 01:28:40 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
  `dirname $0`/seedActions.sh -l $0 "$@"
  exit $?
fi

function vis_help {
  cat  << _EOF_
This script is not to be run as part of the 
genesis process. It produces the binary pkg that 
is used in the genesis process.

Scope of this script is:
   - Obtain a source package
   - Build the source package
   - Generate a debian Binary package
   - Possibly remove the sources and source package
   - Publish the Binary package

Outside of the scope of this script is:
   - Obtaining the binary package
   - Installing the binary package
_EOF_
}


. ${opBinBase}/distHook.libSh

. ${opBinBase}/mmaLib.sh
. ${opBinBase}/mmaBinsPrepLib.sh

binPublishToServer="www.bybinary.org"
binObtainFromServer="www.bybinary.org"

#
# BEGIN PKG Base Variables
# 
srcPkgName="qmailanalog-installer"
srcBuildScript=build-qmailanalog
srcBuildScriptTmpDir=/tmp/qmailanalog
#
#
# END PKG Base Variables
#

function vis_examples {
  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
  typeset extraInfo="-h -v -n showRun"
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
--- OBTAIN SRC/PKG ---
${G_myName} ${extraInfo} -i srcObtainAndInstall
${G_myName} ${extraInfo} -i srcPatchObtain
distPkgPublish.sh -h -v -n showRun -i srcPkgRePublish ${srcPkgName}
--- GENERATE BINARIES FROM SOURCES ---
${G_myName} ${extraInfo} -i srcBuildAndBinPkg
--- Binary Pkg MANIPULATORS  ---
${G_myName} ${extraInfo} -i binPkgName
${G_myName} ${extraInfo} -i binPkgFullPath
${G_myName} ${extraInfo} -i binPkgInfo
${G_myName} ${extraInfo} -i binPkgPublish
${G_myName} ${extraInfo} -i binPkgVerify
${G_myName} ${extraInfo} -i binPkgObtain
--- FULL SERVICE ---
${G_myName} ${extraInfo} -i fullUpdate
_EOF_
}



function noArgsHook {
    vis_examples
}


function debPkgPrep {
    opDo mkdir -p ${opVarBase}/distPkgs/all
    opDo mkdir -p ${opVarBase}/distPkgs/${cononDistArch}
}


function vis_srcBuildAndBinPkg {
  srcBuildScriptFullPath=$( which ${srcBuildScript})

  EH_assert [[ "${srcBuildScriptFullPath}_" != "_" ]]

  opDo vis_srcPatchObtain

  if [ -x ${srcBuildScriptFullPath} ] ; then
      if [ -d ${srcBuildScriptTmpDir} ] ; then
	  opDo /bin/rm -r -f ${srcBuildScriptTmpDir}
      fi
      opDo ${srcBuildScriptFullPath}
  else
      EH_problem "${srcBuildScriptFullPath} missing/not-executable"
  fi
}


function vis_fullUpdate {
  vis_binPkgVerify > /dev/null 2>&1 ;   retVal=$?
  if [[ ${retVal} -eq 0 ]] ; then
      ANT_raw "${G_myName} $0: There seems to be in place a good:"
      ANT_raw "http://${binObtainFromServer}/republish/${cononDistFamily}/${cononDistGeneration}/${cononDistArch}/${thisPkgName}"
      ANT_raw "Are you sure you want to run this?"
      continueAfterThis
  fi 

  ANT_raw "${G_myName} $0 -- About to get the source package and install src pkg" 
  continueAfterThis
  vis_srcObtainAndInstall

  ANT_raw "Will next build from sources but will not install the binaries" 
  continueAfterThis
  vis_srcBuildAndBinPkg

  ANT_raw "Will next Publish the binaries" 
  continueAfterThis
  vis_binPkgPublish
  vis_binPkgVerify
}

vis_srcPatchObtain () {
   echo "commonDebian Running"

   debPkgPrep
   
   PatchUrl="http://www.korsten.org/misc/qmailanalog-sort.patch"
   PatchFile="qmailanalog-sort.patch"

   opDoExit cd ${opVarBase}/distPkgs/all

   opDo wget ${PatchUrl}

   opDo ls -l ${opVarBase}/distPkgs/all/${PatchFile}

   opDo mkdir -p /usr/src/qmailanalog-installer/patches

   opDo cp ${opVarBase}/distPkgs/all/${PatchFile} /usr/src/qmailanalog-installer/patches/
}


#
# srcObtainAndInstall
#

vis_srcObtainAndInstall() {
  EH_assert [[ $# -eq 0 ]]

  distFamilyGenerationHookRun srcObtainAndInstall
}

srcObtainAndInstall_UBUNTU_2004 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1804 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1604 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1404 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1310 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1210 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1204 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1110 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1104 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1010 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_1004 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_910 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_904 () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_INTREPID () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_HARDY () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_GUTSY () { srcObtainAndInstall_commonUbuntu; }

srcObtainAndInstall_UBUNTU_FEISTY () { srcObtainAndInstall_commonUbuntu; }


srcObtainAndInstall_commonUbuntu () {
   echo "commonDebian Running"

   debPkgPrep

   opDoExit cd ${opVarBase}/distPkgs/all
}

srcObtainAndInstall_DEBIAN_SARGE () { srcObtainAndInstall_commonDebian; }

srcObtainAndInstall_DEBIAN_ETCH () { srcObtainAndInstall_commonDebian; }

srcObtainAndInstall_DEBIAN_LENNY () { srcObtainAndInstall_commonDebian; }

srcObtainAndInstall_DEBIAN_SQUEEZE () { srcObtainAndInstall_commonDebian; }

srcObtainAndInstall_DEBIAN_7 () { srcObtainAndInstall_commonDebian; }


srcObtainAndInstall_commonDebian () {
   echo "commonDebian Running"

   debPkgPrep

    # qmail-src wants/needs to create its own user accounts 
    # that happens on a pre-install.
    # if the src is there, it won't happen.
    # This makes it re-run proof (idempotent
   opDo dpkg --remove ${srcPkgName}

   opDo apt-get -y install ${srcPkgName}
}


srcObtainAndInstall_DEFAULT_DEFAULT () {
      EH_problem "No Handler Found for ${opRunDistFamily}/${opRunDistGeneration}"
}

#
# binPkgName
#

vis_binPkgFullPath () {
   EH_assert [[ $# -eq 0 ]]
 
   thisPkgName=$( vis_binPkgName )
   echo ${opVarBase}/distPkgs/${cononDistArch}/${thisPkgName}
}

vis_binPkgName() {
  EH_assert [[ $# -eq 0 ]]

  distFamilyGenerationHookRun binPkgName
}


binPkgName_UBUNTU_910 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1004 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1010 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1104 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1110 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1204 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1210 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1310 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1404 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1604 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_1804 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_2004 () { echo "qmailanalog_0.70-1_i386.deb"; }

binPkgName_UBUNTU_904 () {
    echo "qmailanalog_0.70-1_i386.deb"
}

binPkgName_UBUNTU_INTREPID () {
    echo "qmailanalog_0.70-1_i386.deb"
}

binPkgName_UBUNTU_HARDY () {
    echo "qmailanalog_0.70-1_i386.deb"
}

binPkgName_UBUNTU_GUTSY () {
    echo "qmailanalog_0.70-1_i386.deb"
}

binPkgName_UBUNTU_FEISTY () {
    echo "qmailanalog_0.70-1_i386.deb"
}


binPkgName_commonUbuntu () {
    EH_problem "Unknown ${opRunDistFamily}/${opRunDistGeneration}"
}


binPkgName_DEBIAN_SARGE () {
    echo "qmailanalog_0.70-1_i386.deb"
}

binPkgName_DEBIAN_ETCH () {
    echo "qmailanalog_0.70-1_i386.deb"
}

binPkgName_DEBIAN_LENNY () {
    echo "qmailanalog_0.70-1_i386.deb"
}


binPkgName_commonDebian () {
    EH_problem "Unknown ${opRunDistFamily}/${opRunDistGeneration}"
}


binPkgName_DEFAULT_DEFAULT () {
    EH_problem "No Handler Found for ${opRunDistFamily}/${opRunDistGeneration}"
}


#
# BinPkg
#

vis_binPkgInfo () {
    thisPkgName=$( vis_binPkgName )
    
    echo scp ${srcBuildScriptTmpDir}/${thisPkgName} http://${opRunDistFamily}/${opRunDistGeneration}

}


vis_binPkgPublish () {
    thisPkgName=$( vis_binPkgName )
    
  opDo distPkgPublish.sh -p publishServer=${binPublishToServer} -p relativeUrl="/republish/${cononDistFamily}/${cononDistGeneration}/${cononDistArch}/${thisPkgName}" -i pkgPublish ${srcBuildScriptTmpDir}/${thisPkgName}

}

vis_binPkgVerify () {
    thisPkgName=$( vis_binPkgName )
    
    opDo wget --spider http://${binObtainFromServer}/republish/${cononDistFamily}/${cononDistGeneration}/${cononDistArch}/${thisPkgName}

    retVal=$?

    if [[ ${retVal} -ne 0 ]] ; then
	EH_problem "Missing http://${binObtainFromServer}/republish/${cononDistFamily}/${cononDistGeneration}/${cononDistArch}/${thisPkgName}"
else
	ANT_raw "In Place: http://${binObtainFromServer}/republish/${cononDistFamily}/${cononDistGeneration}/${cononDistArch}/${thisPkgName}"
    fi 
    
    return ${retVal}
}


vis_binPkgObtain () {
    debPkgPrep
    thisPkgName=$( vis_binPkgName )
    
    opDoExit cd ${opVarBase}/distPkgs/${cononDistArch}
    opDo wget http://${binObtainFromServer}/republish/${cononDistFamily}/${cononDistGeneration}/${cononDistArch}/${thisPkgName}

    opDo ls -l ${thisPkgName}
}
