#!/bin/bash
#!/bin/bash 

typeset RcsId="$Id: mmaQmailOldBinsPrep.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
    `dirname $0`/seedActions.sh -l $0 "$@"
    exit $?
fi


#
# PKG Base Variables
# 
mmaThisPkgName="qmail"
mmaThisPkgVersion="1.03"
#
# /opt/public/mmaSrc/qmailPlus/
mmaThisSrcBase=
# /opt/public/mmaPkgs/qmail-1.03/
mmaThisPkgBase=${mmaPkgBase}/qmail-1.03
mmaThisPkgBinBase=${mmaThisPkgBase}/${opRunOsType}/${opRunMachineArch}
mmaPkgCustomCritical="/var/qmail/bin/qmail-send"

mmaPkgDebianName="${mmaThisPkgName}"
mmaPkgDebianVersion="1.03-38"
# /opt/public/mmaPkgs/qmail-1.03/Linux/i686/qmail_1.03-38_i386.deb
mmaPkgDebianFile=${mmaThisPkgBase}/${opRunOsType}/${opRunMachineArch}/qmail_1.03-38_i386.deb

#
# PKG Base Variables
# 
# ###  QMAIL ###
# /opt/public/mmaSrc/qmailPlus
mmaQmailSrcBase=${mmaSrcBase}/qmailPlus
# /opt/public/mmaPkgs/qmail-1.03
mmaQmailPkgBase=${mmaPkgBase}/qmail-1.03
mmaQmailPkgBinBase=${mmaQmailPkgBase}/${opRunOsType}/${opRunMachineArch}
mmaQmailPkgBin_tar=${mmaQmailPkgBinBase}/varQmail-1-03.tar


# ###  EZMLM ###
# /opt/public/mmaSrc/ezmlm/ezmlm-0.53-mma
mmaEzmlmSrcBase=${mmaSrcBase}/ezmlm/ezmlm-0.53-mma
# /opt/public/mmaPkgs/ezmlm-0.53
mmaEzmlmPkgBase=${mmaPkgBase}/ezmlm-0.53
mmaEzmlmPkgBinBase=${mmaEzmlmPkgBase}/${opRunOsType}/${opRunMachineArch}/bin

#  mmaEzmlmCompBase defined in mmaQmailLib.sh 
#  below is for documentation purposes
#mmaEzmlmCompBase=${mmaBase}/ezmlm-0.53
#mmaEzmlmCompBinBase=${mmaBase}/multiArch/${opRunOsType}/${opRunMachineArch}/ezmlm-0.53/bin

# Component base
mmaEzmlmCompBase=/opt/public/mma/ezmlm
mmaEzmlmCompBinBase=${mmaEzmlmCompBase}/bin

mmaEzmlmCompRealBase=${mmaBase}/ezmlm-0.53
mmaEzmlmCompRealBinBase=${mmaBase}/multiArch/${opRunOsType}/${opRunMachineArch}/ezmlm-0.53/bin

# ###  EZMLM-ISSUB ###
# /opt/public/mmaSrc/ezmlm/ezmlm-issub-0.05
mmaEzmlmIssubSrcBase=${mmaSrcBase}/ezmlm/ezmlm-issub-0.05


# NOTYET, EZMLM build procedure should setup the links first then build
#


. ${opBinBase}/mmaLib.sh
. ${opBinBase}/mmaBinsPrepLib.sh
. ${mailBinBase}/mmaQmailLib.sh


function vis_examples {

  typeset extraInfo="-h -v -n showRun"
  #typeset extraInfo="-h"

  typeset visLibExamples=`visLibExamplesOutput ${G_myName} ${extraInfo}`
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
OLD MODEL ---
GENERATE BINARIES ---
${G_myName} ${extraInfo} -i mmaQmailBinKitMake
${G_myName} ${extraInfo} -i mmaQmailBuildAndInstall
${G_myName} ${extraInfo} -i ezmlmBuildAndInstall
INSTALL BINARIES ---
${G_myName} ${extraInfo} -i qmailBinsInstall
${G_myName} ${extraInfo} -i qmailSendmailInstall
${G_myName} ${extraInfo} -i qmailInitInstall
${G_myName} ${extraInfo} -i qmailFullInstall
--- NEW ---
--- PREPARE FOR SRC/PKG/COMP ---
${G_myName} ${extraInfo} -i prepare
${G_myName} ${extraInfo} -i mmaQmailUsersAndGroupsAdd
${G_myName} ${extraInfo} -i mmaQmailUsersAndGroupsDel
--- OBTAIN SRC/PKG ---
${G_myName} ${extraInfo} -i obtain
${G_myName} ${extraInfo} -i srcUnpack
${G_myName} ${extraInfo} -i unpack
${G_myName} ${extraInfo} -i unpackEzmlm
--- GENERATE BINARIES FROM SOURCES ---
${G_myName} ${extraInfo} -i build
${G_myName} ${extraInfo} -i srcBuild
${G_myName} ${extraInfo} -i srcClean
${G_myName} ${extraInfo} -i clean
${G_myName} ${extraInfo} -i srcBuildAndInstall
--- GENERATE PACKAGE ---
${G_myName} ${extraInfo} -i pkgMake
${G_myName} ${extraInfo} -i ezmlmPkgMake
--- COMPONENT MANIPULATORS  ---
${G_myName} ${extraInfo} -i compVerify
${G_myName} ${extraInfo} -i compUpdate
${G_myName} ${extraInfo} -i compDelete
${G_myName} ${extraInfo} -i ezmlmPkgInstall
${G_myName} ${extraInfo} -i ezmlmCompPrep
${G_myName} ${extraInfo} -i initInstall
${G_myName} ${extraInfo} -i pkgRemove
${G_myName} ${extraInfo} -i pkgVerify
--- COMPONENT ACTIVATION ---
${G_myName} ${extraInfo} -i compInitInstall
--- FULL SERVICE ---
${G_myName} ${extraInfo} -i fullVerify
${G_myName} ${extraInfo} -i fullUpdate
${G_myName} ${extraInfo} -i buildAndInstall
${G_myName} ${extraInfo} -i fullInstall
--- INFORMATION ---
${G_myName} ${extraInfo} -i compInfo
${G_myName} ${extraInfo} -i pkgInfo
${G_myName} ${extraInfo} -i info
_EOF_
}


function vis_help {
  cat  << _EOF_

BinsPrep for the following packages are supported:
  qmail-1.03, EZMLM-0.53, dotForward and fastForward.

  - qmail-1.03:  Architecture specific binary kits are
                 made to be installed in the standard
                 /var/qmail directory.

  - ezmlm:       Destined for multi-binary installation
                 binary packages are built to be installed
		 in /opt/public/mma/ezmlm

  - dotForward:  NOTYET

  - fastForward: NOTYET
_EOF_
}


function noArgsHook {
    vis_examples
}

# System/Component
function vis_compInfo {
  mmaCompDebian_info ${mmaPkgDebianName}
}

# Pkg
function vis_pkgInfo {
  mmaPkgDebian_info ${mmaPkgDebianFile}
}


function vis_obtain {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    ANV_raw "${mmaThisPkgName} is a Src pkg"
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    ANV_raw "${mmaThisPkgName} is a Linux pkg"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi

  cat  << _EOF_

NOTYET, do this as new revs are included.

Run: ${G_myName} -i unpack to unpack these packages
and this is a one time activity.

The mailing list for accouncements for this package 
is xxx.
_EOF_
}


function vis_srcUnpack {
  EH_problem "NOTYET"
  return 0
}

function vis_unpack {
  vis_unpackEzmlm
}

function vis_unpackEzmlm {
  EH_assert [[ -d ${mmaEzmlmIssubSrcBase} ]]
  EH_assert [[ -d ${mmaEzmlmSrcBase} ]]

  opDoExit cp ${mmaEzmlmIssubSrcBase}/* ${mmaEzmlmSrcBase}
  opDoExit cd ${mmaEzmlmSrcBase}

  opDoExit eval patch '<' iss.patch
}


function vis_srcClean {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    EH_problem "NOTYET"
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    ANV_raw "${thisPkgName} is a Linux pkg"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}


function vis_srcBuild {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    EH_problem "NOTYET"
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    ANV_raw "${thisPkgName} is a Linux pkg"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}


function vis_srcBuildAndInstall {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    EH_problem "NOTYET"
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    ANV_raw "${mmaThisPkgName} is a Linux pkg"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}

function vis_pkgMake {
  print -- ""
  return 0
}

function vis_compVerify {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    mmaCompCustom_verify ${mmaThisPkgName} ${mmaThisPkgVersion} ${mmaPkgCustomCritical}  || return $?
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    mmaCompDebian_verify "${mmaPkgDebianName}" "${mmaPkgDebianVersion}"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}


function vis_compUpdate {
    continueAfterThis
  if [[ "${opRunOsType}_" == "SunOS_" ]] ; then
    if [[ "${G_forceMode}_" == "force_" ]] ; then
      vis_qmailBinsInstall
    elif mmaCompCustom_shouldBeInstalled ${mmaThisPkgName} ${mmaThisPkgVersion} "${mmaPkgCustomCritical}"   ; then
      vis_qmailBinsInstall
    fi
  elif [[ "${opRunOsType}_" == "Linux_" ]] ; then
    vis_qmailBinsInstall
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}


function vis_compDelete {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    EH_problem "NOTYET"
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    mmaCompDebian_delete "${mmaPkgDebianName}" "${mmaPkgDebianVersion}"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}


function vis_compInitInstall {
  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    vis_qmailInitInstall
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    ANV_raw "compInitInstall: ${mmaThisPkgName} is Linux pre-initialized"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}


function vis_fullVerify {
  vis_compVerify
}

function vis_fullUpdate {
  opDo vis_compUpdate
  opDo vis_ezmlmCompPrep

  #vis_compUpdate
  # Run it too. On all hosts.
  #vis_compInitInstall
}

vis_mmaQmailUsersAndGroupsAdd() {
  mmaQmailUsersAndGroupsAdd
}

vis_mmaQmailUsersAndGroupsDel() {
  mmaQmailUsersAndGroupsDel
}


function qmailPreBuild {
  opDoComplain mmaQmailAdmin.sh -i killProcs
  opDoComplain FN_dirDefunctMake ${qmailVarDir} ${qmailVarDir}.${dateTag}
  opDoComplain FN_dirCreateIfNotThere ${qmailVarDir}
  opDoComplain mmaQmailUsersAndGroupsAdd
}


# Verify We are running Solaris or Linux
function vis_mmaQmailBuildAndInstall {
  qmailPreBuild
  opDoExit     cd  ${mmaQmailSrcBase}/qmail/qmail-1.03
  opDoComplain pwd
  opDoComplain make clean
  opDoComplain make setup check
}

vis_mmaQmailBinKitMake() {
  #set -x
  cd ${qmailVarDir}
  mkdir -p ${mmaQmailPkgBinBase}
  tar cf ${mmaQmailPkgBin_tar} .
  ls -l ${mmaQmailPkgBin_tar}
}

function vis_mmaQmailBinKitInstall {
  if [[ -d  ${qmailVarDir} ]] ; then
    FN_dirSafeKeep ${qmailVarDir}
  else
    FN_dirCreateIfNotThere ${qmailVarDir}
  fi
  cd ${qmailVarDir}
  tar xf ${mmaQmailPkgBin_tar}
  echo "MMA Qmail Binaries Have Been Installed"
}


MMA_qmail_dot_forward_buildAndInstall() {
  cd  ${qmailSrcBaseDir}/dot-forward/dot-forward-0.71
  pwd

  make clean
  make setup check
}


MMA_qmail_fastforward_buildAndInstall() {
  # qmailSrcBaseDir= /opt/public/src/Sol-2/networking/qmail-package/fastforward/fastforward-0.51/

  cd  ${qmailSrcBaseDir}/fastforward/fastforward-0.51
  pwd

  make clean
  make setup check
}


function vis_ezmlmPkgInstall {
 cat  << _EOF_
ezmlmPkgMake installs binary and man pages in
${mmaBase}. ezmlmPkgInstall is a no-op.
_EOF_
}

function vis_ezmlmCompPrep {
    continueAfterThis

  #
  # Setup Component Bases
  # 
  opDoComplain FN_dirCreatePathIfNotThere ${mmaEzmlmCompRealBase}
  opDoComplain FN_dirCreatePathIfNotThere ${mmaEzmlmCompRealBinBase}

  # /here update takes place here
  opDoComplain mmaMultiArchSymLinks ${mmaEzmlmCompRealBase}/bin ${mmaEzmlmCompRealBinBase}

  opDoComplain FN_fileSymlinkUpdate ${mmaEzmlmCompRealBase} ${mmaEzmlmCompBase} 
}

function vis_ezmlmPkgMake {

  #
  # Setup Component Bases
  # 
  FN_dirCreatePathIfNotThere ${mmaEzmlmCompRealBase}
  FN_dirCreatePathIfNotThere ${mmaEzmlmCompRealBinBase}

  mmaMultiArchSymLinks ${mmaEzmlmCompRealBase}/bin ${mmaEzmlmCompRealBinBase}

  FN_fileSymlinkUpdate ${mmaEzmlmCompRealBase} ${mmaEzmlmCompBase} 

  #
  # Now build and instruct address of component base in the binaries
  #

  opDoExit cd ${mmaEzmlmSrcBase}
  EH_assert [[ `pwd` == ${mmaEzmlmSrcBase} ]]
  pwd

  FN_fileDefunctMake ${mmaEzmlmSrcBase}/conf-bin ${mmaEzmlmSrcBase}/notused.conf-bin.${dateTag}
  FN_dirCreatePathIfNotThere ${mmaEzmlmPkgBinBase}
  cat  << _EOF_ > ${mmaEzmlmSrcBase}/conf-bin
${mmaEzmlmCompBase}/bin

Programs will be installed in this directory.
_EOF_

  FN_fileDefunctMake ${mmaEzmlmSrcBase}/conf-man ${mmaEzmlmSrcBase}/notused.conf-man.${dateTag}
  FN_dirCreatePathIfNotThere ${mmaEzmlmPkgBase}/man
  cat  << _EOF_ > conf-man
${mmaEzmlmCompBase}/man

Man pages will be installed in subdirectories of this directory. An
unformatted man page foo.1 will go into .../man1/foo.1; a formatted man
page foo.0 will go into .../cat1/foo.0.
_EOF_

  /bin/rm *.o *.a *.0 *=0
  make
  make man
  make setup
}


function vis_fullBuild
{
  #######
  echo "Setting Up Binaries For qmail-1.03"
  MMA_qmail_buildAndInstall

  #######
  echo "Setting Up Binaries For dot-forward-0.71"
  MMA_qmail_dot_forward_buildAndInstall

  #######
  echo "Setting Up Binaries For fastforward-0.51"
  MMA_qmail_fastforward_buildAndInstall

  #######
  echo "Setting Up Binaries For ezmlm/ezmlm-0.53"
  #MMA_qmail_ezmlm_buildAndInstall
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
  vis_mmaQmailSyslogSetup
}

function vis_qmailBinsInstall {
  continueAfterThis

  G_abortIfNotRunningAsRoot
  mmaQmailAdmin.sh -i killProcs
  FN_dirDefunctMake ${qmailVarDir} ${qmailVarDir}.${dateTag}
  mmaQmailUsersAndGroupsAdd
  continueAfterThis

  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    vis_mmaQmailBinKitInstall
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    # NOTYET, best to take exim out and put a fake
    # mail-transport. Needs more work.

    rightHere "About To Remove exim"
    opDo mmaCompDebian_delete exim

    continueAfterThis

    # Move /var/qmail out of the way if needed.

    mmaCompDebianDpkg_update "${mmaPkgDebianName}" "${mmaPkgDebianVersion}" "${mmaPkgDebianFile}"

    continueAfterThis

    # Now Deactivate that debian qmail package
    if [[ -d  ${qmailVarDir} ]] ; then
      FN_dirSafeKeep ${qmailVarDir}
    fi
    bootRcDisable "/etc/rc0.d/K20qmail /etc/rc1.d/K20qmail /etc/rc2.d/S20qmail /etc/rc3.d/S20qmail /etc/rc4.d/S20qmail /etc/rc5.d/S20qmail /etc/rc6.d/K20qmail"

    # Reinstall our version of qmail, the debian package install
    # just lets other packages know that we have
    # qmail as mail-transport

    vis_mmaQmailBinKitInstall
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
  fi
}

vis_mmaQmailSyslogSetup() {
  G_abortIfNotRunningAsRoot

  if [ "${opRunOsType}_" == "SunOS_" ] ; then
    mailLogFile=/var/adm/maillog
    mailLogLine="mail.debug;mail.alert;mail.info"
  elif [ "${opRunOsType}_" == "Linux_" ] ; then
    mailLogFile=/var/log/mail.log
    mailLogLine="mail.log"
  else
    EH_problem "Unsupported OS: ${opRunOsType}"
    return 1
  fi

  if test ! -f ${mailLogFile} ; then
    echo "Creating ${mailLogFile}"
    touch ${mailLogFile}
  fi

  if FN_lineIsInFile "${mailLogLine}" /etc/syslog.conf  ; then
    echo "Syslog was qmail log ready"
  else
    # NOTYET, locate a good
    syslogSetupPrompt
  fi

  echo "Restarting syslog service"
  /etc/init.d/syslog stop
  /etc/init.d/syslog start
}

vis_syslogSetupPrompt() {

  echo "Add the following line to your /etc/syslog.conf"
  echo "--------"
  echo "mail.debug;mail.alert;mail.info			/var/adm/maillog"
  echo "--------"

  echo "Then restart syslog by:"
  echo "/etc/init.d/syslog stop"
  echo "followed by:"
  echo "/etc/init.d/syslog start"
  echo ""
  echo "Now you are ready to log"
}

