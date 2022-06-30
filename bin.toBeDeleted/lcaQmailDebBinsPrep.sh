#!/bin/bash

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

####+BEGIN: bx:bsip:bash:seed-spec :types "seedSubjectBinsPrepDist.sh"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedSubjectBinsPrepDist.sh]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailDebBinsPrep.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedSubjectBinsPrepDist.sh -l $0 "$@" 
    exit $?
fi
####+END:

# {{{ NOTES/Status:

function vis_describe {  cat  << _EOF_
Obsoletes ./lcaQmailDebPkgBinsPrep.sh.

_EOF_
}

# }}}

# {{{ Components List

. ${mailBinBase}/mmaQmailLib.sh


itemOrderedList=( 
    "qmail"
)

# }}}

item_qmail() { distFamilyGenerationHookRun binsPrep_qmail; }


binsPrep_qmail_DEFAULT_DEFAULT () {
  mmaThisPkgName="qmail"
  mmaPkgDebianName="${mmaThisPkgName}"
  mmaPkgDebianMethod="dpkg"
  mmaPkgDebianFile="/var/osmt/distPkgs/all/qmail-1.03-49.2"
  binsPrep_installPreHook="qmail_installPre"
  binsPrep_installPostHook="qmail_installPost"
  binsPrep_pkgObtainCmd="vis_buildFromSources"   # NOTYET, this should be obtain based on srcPkg.
}

qmail_installPre () {
  distFamilyGenerationHookRun qmail_installPre
}

qmail_installPre_commonDebian () {
    doNothing
}


qmail_installPre_commonUbuntu () {  
    opDo vis_fullRemove
    FN_FileCreateIfNotThere /etc/inetd.conf
    FN_fileSymlinkSafeMake /usr/bin/env /bin/env
    opDo apt-get -y install procmail  

    opDo dpkg --ignore-depends=mail-transport-agent --purge postfix
}


qmail_installPre_DEFAULT_DEFAULT () {
      EH_problem "No Handler Found for ${opRunDistFamily}/${opRunDistGeneration}"
}


qmail_installPre_DEBIAN_7 () { 
    qmail_installPre_commonDebian;

    opDo apt-get -y install procmail 
    opDo apt-get -y install po-debconf

    opDo dpkg --purge fgetty
    opDo dpkg --ignore-depends=mail-transport-agent --purge exim4
    opDo dpkg --ignore-depends=mail-transport-agent --purge exim4-daemon-light

    FN_fileSymlinkSafeMake /usr/bin/env /bin/env
}

qmail_installPre_UBUNTU_2004 () { qmail_installPre_commonUbuntu; }
qmail_installPre_UBUNTU_1804 () { qmail_installPre_commonUbuntu; }
qmail_installPre_UBUNTU_1604 () { qmail_installPre_commonUbuntu; }
qmail_installPre_UBUNTU_1404 () { qmail_installPre_commonUbuntu; }
qmail_installPre_UBUNTU_1310 () { qmail_installPre_commonUbuntu; }


qmail_installPost () {
  distFamilyGenerationHookRun qmail_installPost
}

qmail_installPost_commonDebian () {
  opDo /etc/init.d/qmail stop
  opDo binsPrepSvcNotInitDotD /etc/init.d/qmail
  # /bin/env used by GUNS
  FN_fileSymlinkSafeMake /usr/bin/env /bin/env
}


qmail_installPost_commonUbuntu () {  
    qmail_installPost_commonDebian
}


qmail_installPost_DEFAULT_DEFAULT () {
      EH_problem "No Handler Found for ${opRunDistFamily}/${opRunDistGeneration}"
}

qmail_installPost_DEBIAN_SARGE () { qmail_installPost_commonDebian; }


function examplesHookPost {
    extraInfo="-h -v -n showRun"
  cat  << _EOF_
----- POST HOOK EXAMPLES -------
--- FULL REMOVE  ---
${G_myName} ${extraInfo} -i fullRemove
--- COMPONENT ACTIVATION ---
${G_myName} ${extraInfo} -i compInitInstall
${G_myName} ${extraInfo} -i runFunc binsPrepSvcNotInitDotD /etc/init.d/qmail 
--- INSTALL BINARIES ---
${G_myName} ${extraInfo} -i qmailBinsInstall
${G_myName} ${extraInfo} -i qmailSendmailInstall
${G_myName} ${extraInfo} -i qmailInitInstall
${G_myName} ${extraInfo} -i qmailFullInstall
--- PREPARE FOR SRC/PKG/COMP ---
${G_myName} ${extraInfo} -i prepare
${G_myName} ${extraInfo} -i mmaQmailUsersAndGroupsAdd
${G_myName} ${extraInfo} -i mmaQmailUsersAndGroupsDel
_EOF_
}


function vis_fullRemove {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

    FN_dirDefunctMake /var/qmail /var/qmail.defuncOn${dateTag}
    opDo dpkg --force-depends --purge exim4 exim4-base exim4-config exim4-daemon-light

    opDo dpkg --ignore-depends=mail-transport-agent --purge postfix
    opDo dpkg --ignore-depends=mail-transport-agent --purge procmail

    opDo dpkg --ignore-depends=mail-transport-agent --purge qmail-run
    opDo dpkg --ignore-depends=mail-transport-agent --purge qmail
    opDo dpkg --force-depends --purge qmail

    opDo FN_dirSafeKeep /var/spool/qmail

    opDo dpkg --ignore-depends=mail-transport-agent --purge courier-imap
    opDo dpkg --ignore-depends=mail-transport-agent --purge maildrop

    opDo dpkg --force-depends --purge qmail-uids-gids

    opDo apt-get -y -f install

    opDo apt-get -y autoremove
}

function vis_fullUpdateBAD {

  opDoComplain vis_mmaQmailUsersAndGroupsDel

  continueAfterThis

  opDoComplain qmailPreBuild

  continueAfterThis

  #opDo vis_fullNewSrc

  FN_dirDefunctMake /var/qmail /var/qmail.defuncOn${dateTag}

  opDo dpkg --ignore-depends=mail-transport-agent --purge qmail

  opDo dpkg --ignore-depends=mail-transport-agent --purge exim

  opDo dpkg --ignore-depends=mail-transport-agent --purge postfix

  #opDo dpkg --ignore-depends=mail-transport-agent --purge exim-daemon-light

  opDo dpkg -i ${mmaPkgDebianFile}

  #FN_fileDefunctMake /etc/init.d/qmail  /etc/init.d/notused.qmail.${dateTag}
  binsPrepSvcNotInitDotD /etc/init.d/qmail
}

function vis_justSvc {
  #FN_fileDefunctMake /etc/init.d/qmail  /etc/init.d/notused.qmail.${dateTag}
  binsPrepSvcNotInitDotD /etc/init.d/qmail
}

function vis_mmaQmailUsersAndGroupsAdd {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;
    mmaQmailUsersAndGroupsAdd
}


function vis_mmaQmailUsersAndGroupsDel {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

    opDo mmaQmailUsersAndGroupsDel

    opDo vis_prepareAndCleanUp
}


function vis_prepareAndCleanUp {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Started using this in Ubuntu 13.10.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn 1; fi;

    opDo  userdel alias
    opDo  userdel qmaild
    opDo  userdel qmaill
    opDo  userdel qmailp
    opDo  userdel qmailq
    opDo  userdel qmailr
    opDo  userdel qmails

    opDo  groupdel qmail
    opDo  groupdel nofiles

    opDo  FN_dirSafeKeep /var/lib/qmail
    opDo  FN_dirSafeKeep /etc/qmail

    opDo rm -r -f /var/lib/qmail
    opDo rm -r -f /etc/qmail


    lpReturn
}



function qmailPreBuild {
  opDoComplain mmaQmailAdmin.sh -i killProcs
  opDoComplain FN_dirDefunctMake ${qmailVarDir} ${qmailVarDir}.${dateTag}
  #opDoComplain FN_dirCreateIfNotThere ${qmailVarDir}
  opDoComplain mmaQmailUsersAndGroupsAdd
}


vis_qmailSendmailInstall() {

  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /usr/lib/sendmail
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /bin/mailq

  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /usr/lib/sendmail
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /usr/sbin/sendmail
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /bin/mailq

  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}

vis_qmailInitInstall() {

  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /usr/lib/sendmail
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /bin/mailq

    FN_fileSafeKeep  /etc/init.d/mma-qmail
    FN_fileCopy ${mmaQmailPkgBase}/${opRunOsType}/mma-qmail.etcInitd  /etc/init.d/mma-qmail
    FN_fileSymlinkSafeMake /etc/init.d/mma-qmail  /etc/rc2.d/S88mma-qmail

  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /usr/lib/sendmail
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /usr/sbin/sendmail
    FN_fileSymlinkSafeMake ${qmailVarDir}/bin/sendmail /bin/mailq

    FN_fileSafeKeep  /etc/init.d/mma-qmail
    FN_fileCopy ${mmaQmailPkgBase}/${opRunOsType}/mma-qmail.etcInitd  /etc/init.d/mma-qmail

    FN_fileSymlinkSafeMake /etc/init.d/mma-qmail  /etc/rc2.d/S88mma-qmail

  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi

  vis_mmaQmailSyslogSetup
}

vis_qmailFullInstall() {
  G_abortIfNotSupportedOs
  G_abortIfNotRunningAsRoot
  vis_mmaQmailUsersAndGroupsAdd
  vis_qmailBinsInstall
  vis_qmailInitInstall
  #vis_mmaQmailSyslogSetup
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
