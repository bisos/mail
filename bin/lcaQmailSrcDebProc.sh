#!/bin/bash

####+BEGIN: bx:bash:top-of-file :vc "cvs" :partof "generic" :copyleft "none"
### Args: :control "enabled|disabled|hide|release|fVar"  :vc "cvs|git|nil" :partof "bystar|nil" :copyleft "halaal+minimal|halaal+brief|nil"
typeset RcsId="$Id: dblock-iim-bash.el,v 1.4 2017-02-08 06:42:32 lsipusr Exp $"
# *CopyLeft*

####+END:

# {{{ Authors:
# Authors: Mohsen BANAN, http://mohsen.banan.1.byname.net/contact
# }}} 

####+BEGIN: bx:bsip:bash:seed-spec :types "seedActions.bash"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedActions.bash]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailSrcDebProc.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedActions.bash -l $0 "$@" 
    exit $?
fi
####+END:

# {{{ Help/Info


function vis_describe {  cat  << _EOF_
Obsoletes ./lcaQmailDebPkgBinsPrep.sh.

1) Obtain a Debian Source Package
2) Possibly, Obtain and Apply Patches 
3) Build the source package
4) Publish the package using lcaQmailDebPkgRePub.sh

_EOF_
}

# }}}

# {{{ Prefaces

. ${opBinBase}/opAcctLib.sh
. ${opBinBase}/opDoAtAsLib.sh
. ${opBinBase}/lpParams.libSh

. ${opBinBase}/lpReRunAs.libSh 

# PRE parameters

function G_postParamHook {
     return 0
}

# }}}

# {{{ Examples

function vis_examples {
  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo=""

  visLibExamplesOutput ${G_myName} 
  cat  << _EOF_
----- EXAMPLES -------
${G_myName} ${extraInfo} -i fullRemove
--- PREPARE FOR SRC/PKG/COMP ---
${G_myName} ${extraInfo} -i prepare
${G_myName} ${extraInfo} -i mmaQmailUsersAndGroupsAdd
${G_myName} ${extraInfo} -i mmaQmailUsersAndGroupsDel
--- Obtain Source Deb Packages ---
lcaQmailPatchesPkgRePub.sh -h -v -n showRun -i pkgRePubBxVerify
lcaQmailSrcDebPkgRePub.sh -h -v -n showRun -i pkgRePubBxVerify
lcaQmailPatchesPkgRePub.sh -h -v -n showRun -i pkgRePubBxObtain
lcaQmailSrcDebPkgRePub.sh -h -v -n showRun -i pkgRePubBxObtain
--
${G_myName} ${extraInfo} -i srcObtain
${G_myName} ${extraInfo} -i srcPatchObtain
--- GENERATE DEB BINARIES FROM SOURCES ---
${G_myName} ${extraInfo} -i srcObtainAndInstall
${G_myName} ${extraInfo} -i srcPatchObtain
${G_myName} ${extraInfo} -i srcBuildAndBinPkg

--- FULL OPERATIONS ---
${G_myName} ${extraInfo} -i fullUpdate
${G_myName} ${extraInfo} -i fullClean
_EOF_
}


noArgsHook() {
  vis_examples
}

# }}}

. ${mailBinBase}/mmaQmailLib.sh

### SOURCE BUILD SECTION

#
# BEGIN PKG Base Variables
# 
srcPkgName="qmail-src"
srcBuildScript=build-qmail
srcBuildScriptTmpDir=/tmp/qmail
#
#
# END PKG Base Variables
#


function vis_srcBuildAndBinPkg {
  srcBuildScriptFullPath=$( which ${srcBuildScript})

  EH_assert [[ "${srcBuildScriptFullPath}_" != "_" ]]

  if [ -x ${srcBuildScriptFullPath} ] ; then
      if [ -d ${srcBuildScriptTmpDir} ] ; then
	  opDo /bin/rm -r -f ${srcBuildScriptTmpDir}
      fi
      opDo ${srcBuildScriptFullPath}
  else
      EH_problem "${srcBuildScriptFullPath} missing/not-executable"
  fi
}


function vis_srcToPkgFullUpdate {
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
}


#
# srcObtainAndInstall
#

function vis_srcPatchObtain {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]
    opDo lcaQmailPatchesPkgRePub.sh -h -v -n showRun -i pkgRePubBxObtain
}

vis_srcObtain() {
  EH_assert [[ $# -eq 0 ]]

  opDo mmaQmailUsersAndGroupsDel 

  opDo lcaQmailPkgRePub.sh -h -v -n showRun -i pkgRePubBxObtain
}

function vis_srcObtainAndInstall {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

    opDo vis_srcObtain

    opDo vis_srcDebPkgInstall
}

function vis_srcDebPkgInstall {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

    # These are prerequisite
    opDo apt-get -y install build-essential debhelper fakeroot sudo patch wget

    opDo dpkg -i $( lcaQmailSrcDebPkgRePub.sh -h -v -n showRun -i pkgRePubLocalPath )
}


srcObtainAndInstall_commonDebian () {
   echo "NOTUSED"
   exit 1

   echo "commonDebian Running"

   debPkgPrep

    # qmail-src wants/needs to create its own user accounts 
    # that happens on a pre-install.
    # if the src is there, it won't happen.
    # This makes it re-run proof (idempotent
   opDo dpkg --remove ${srcPkgName}

   opDo apt-get -y install ${srcPkgName}
 
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
