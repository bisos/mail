#!/bin/bash

IcmBriefDescription="MODULE BinsPrep based on apt based seedSubjectBinsPrepDist.sh"

ORIGIN="
* Revision And Libre-Halaal CopyLeft -- Part of [[http://www.by-star.net][ByStar]] -- Best Used With [[http://www.by-star.net/PLPC/180004][Blee]] or [[http://www.gnu.org/software/emacs/][Emacs]]
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


####+BEGIN: bx:bsip:bash:seed-spec :types "seedSubjectBinsPrepDist.sh"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedSubjectBinsPrepDist.sh]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailBinsPrep.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedSubjectBinsPrepDist.sh -l $0 "$@" 
    exit $?
fi
####+END:


####+BEGIN: bx:bsip:bash:seed-spec :types "seedSubjectBinsPrepDist.sh"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedSubjectBinsPrepDist.sh]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailBinsPrep.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedSubjectBinsPrepDist.sh -l $0 "$@" 
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
*      ################  CONTENTS-LIST ###############
*      ======[[elisp:(org-cycle)][Fold]]====== *[Current-Info:]* Module Description, Notes (Tasks/Todo Lists, etc.)
_CommentEnd_
function vis_moduleDescription {
  cat  << _EOF_
**      ====[[elisp:(org-cycle)][Fold]]==== /Module Desrciption/
apt-get of qmail will fail unless 
hostname -f produces a real looking FQDN.
_EOF_
}

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== *[Related-Xrefs:]* <<Xref-Here->>  -- External Documents 
Xref-Here-
**      ====[[elisp:(org-cycle)][Fold]]==== [[file:/libre/ByStar/InitialTemplates/activeDocs/bxServices/servicesManage/bxMailMta/fullUsagePanel-en.org::Xref-BxMailTransfer-SA][Panel Roadmap Documentation]]
_CommentEnd_

_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Components List
_CommentEnd_

#  [[elisp:(lsip-local-run-command "apt-cache search qmail | egrep '^qmail'")][apt-cache search qmail | egrep '^qmail']]

#qmail - a secure, reliable, efficient, simple message transfer agent
#qmail-run - sets up qmail as mail-transfer-agent
#qmail-tools - collection of tools for qmail
#qmail-uids-gids - user ids and group ids for qmail


function pkgsList_DEFAULT_DEFAULT {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }

    #  [[elisp:(lsip-local-run-command "apt-cache search something | egrep '^something'")][apt-cache search something | egrep '^something']]

    itemOrderedList=( 
	"qmail"
	"qmail_run"
	"qmail_tools" 
    )

    itemOptionalOrderedList=()
    itemLaterOrderedList=()
}

distFamilyGenerationHookRun pkgsList


_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Module Specific Additions -- examplesHook
_CommentEnd_


function examplesHookPost {
  cat  << _EOF_
----- POST HOOK ADDITIONS -------
${G_myName} -i moduleDescription
${G_myName} -i prepareAndCleanUp
${G_myName} -f -i prepareAndCleanUp
_EOF_
}


function vis_prepareAndCleanUp {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
Started using this in Ubuntu 13.10.
_EOF_
    }
    EH_assert [[ $# -eq 0 ]]

    if vis_reRunAsRoot ${G_thisFunc} $@ ; then lpReturn ${globalReRunRetVal}; fi;

    if [[ "${G_forceMode}" != "force" ]] ; then
	if  mmaCompDebian_isInstalled qmail ; then
	    ANT_raw "Qmail Is Already Installed -- Skipped -- use G_forceMode to force re-install"
	    lpReturn 101
	else
	    ANT_raw "Qmail Was Not Installed -- Will Install It."
	fi
    fi

    opDo lcaQmailHosts.sh -v -n showRun -s ${opRunHostName} -a servicesStop all

    opDo lcaQmailAdmin.sh -i showProcs

    opDoAfterPause echo "Kill Any Remaining Processes -- Before Continuing"

    opDo apt-get  -y purge qmail-run
    opDo apt-get  -y purge qmail-uids-gids
    opDo apt-get  -y purge qmail

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

    opDo rm /etc/service/qmail-smtpd
    opDo rm /etc/service/qmail-send

    lpReturn
}


####+BEGIN: bx:dblock:lsip:binsprep:apt :module "qmail-run"
_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  [[elisp:(blee:ppmm:org-mode-toggle)][Nat]] [[elisp:(beginning-of-buffer)][Top]] [[elisp:(delete-other-windows)][(1)]] || Apt-Pkg       :: qmail-run [[elisp:(org-cycle)][| ]]
_CommentEnd_
item_qmail_run () { distFamilyGenerationHookRun binsPrep_qmail_run; }

binsPrep_qmail_run_DEFAULT_DEFAULT () { binsPrepAptPkgNameSet "qmail-run"; }

####+END:


####+BEGIN: bx:dblock:lsip:binsprep:apt :module "qmail-tools"
_CommentBegin_
*  [[elisp:(org-cycle)][| ]]  [[elisp:(blee:ppmm:org-mode-toggle)][Nat]] [[elisp:(beginning-of-buffer)][Top]] [[elisp:(delete-other-windows)][(1)]] || Apt-Pkg       :: qmail-tools [[elisp:(org-cycle)][| ]]
_CommentEnd_
item_qmail_tools () { distFamilyGenerationHookRun binsPrep_qmail_tools; }

binsPrep_qmail_tools_DEFAULT_DEFAULT () { binsPrepAptPkgNameSet "qmail-tools"; }

####+END:


_CommentBegin_
*      ======[[elisp:(org-cycle)][Fold]]====== Custom-Pkg: qmail
_CommentEnd_


item_qmail () {
  distFamilyGenerationHookRun binsPrep_qmail
}

#binsPrep_qmail_DEFAULT_DEFAULT () { binsPrepAptPkgNameSet "qmail"; }
binsPrep_qmail_DEFAULT_DEFAULT () {
    mmaThisPkgName="qmail"
    mmaPkgDebianName="${mmaThisPkgName}"
    mmaPkgDebianMethod="apt" 
    binsPrep_installPreHook="qmail_installPre"
    binsPrep_installPostHook="qmail_installPost"
}

binsPrep_qmail_DEBIAN_11 () {
    mmaThisPkgName="qmailDeb10"
    mmaPkgDebianName="${mmaThisPkgName}"
    mmaPkgDebianMethod="custom"  #  or "apt" no need for customInstallScript but with binsPrep_installPostHook

    function customInstallScript {
        #lpDo sudo dpkg --purge --force-all zoom
        inBaseDirDo /tmp wget http://ftp.us.debian.org/debian/pool/main/n/netqmail/qmail_1.06-6.2~deb10u1_amd64.deb
        
        opDo sudo apt-get install -y /tmp/qmail_1.06-6.2~deb10u1_amd64.deb
    }
    binsPrep_installPreHook="qmail_installPre"
    binsPrep_installPostHook="qmail_installPost"
}


function qmail_installPre {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
_EOF_
    }
    opDo vis_prepareAndCleanUp
}

function qmail_installPost {
    G_funcEntry
    function describeF {  G_funcEntryShow; cat  << _EOF_
qmail_installPost -- Completed.
_EOF_
    }
    opDo describeF
}


_CommentBegin_
*      ================ /[dblock] -- End-Of-File Controls/
_CommentEnd_
#+STARTUP: showall
#local variables:
#major-mode: sh-mode
#fill-column: 90
# end:
####+END:
