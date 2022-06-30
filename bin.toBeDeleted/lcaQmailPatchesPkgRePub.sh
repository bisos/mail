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

####+BEGIN: bx:bsip:bash:seed-spec :types "seedPkgRePub.sh"
SEED="
*  /[dblock]/ /Seed/ :: [[file:/bisos/core/bsip/bin/seedPkgRePub.sh]] | 
"
FILE="
*  /This File/ :: /bisos/core/mail/bin/lcaQmailPatchesPkgRePub.sh 
"
if [ "${loadFiles}" == "" ] ; then
    /bisos/core/bsip/bin/seedPkgRePub.sh -l $0 "$@" 
    exit $?
fi
####+END:

# {{{ NOTES/Status:

function vis_describe {  cat  << _EOF_

_EOF_
}

# }}}


function examplesHookPostNot {
  cat  << _EOF_
----- POST HOOK ADDITIONS -------
${G_myName} -i pkgRePubObtainInstructions
_EOF_
}


function vis_pkgRePubObtainInstructions {
  cat  << _EOF_
Go There and Do That.
_EOF_
}


#
# pkgRePubParameters
#

vis_pkgRePubParameters() {
  EH_assert [[ $# -eq 0 ]]
  distFamilyGenerationHookRun pkgRePubParameters
}

pkgRePubParameters_UBUNTU_2004 () { pkgRePubParameters_commonUbuntu; }
pkgRePubParameters_UBUNTU_1804 () { pkgRePubParameters_commonUbuntu; }
pkgRePubParameters_UBUNTU_1604 () { pkgRePubParameters_commonUbuntu; }
pkgRePubParameters_UBUNTU_1404 () { pkgRePubParameters_commonUbuntu; }
pkgRePubParameters_UBUNTU_1310 () { pkgRePubParameters_commonUbuntu; }

pkgRePubParameters_commonUbuntu () {
    # 
    pkgRePubName="qmail-1.03.isp.patch"
    # 
    pkgRePubSrcStableUrl="http://jeremy.kister.net/code/qmail-1.03.isp.patch"
    #
    pkgRePubArchType=all    # all or i386
    #
    pkgRePubDistDests=("localDist")    # or ("localDist" "currentDist")
}

pkgRePubParameters_DEBIAN_7 () { pkgRePubParameters_commonDebian; }

pkgRePubParameters_commonDebian () {
    opDo pkgRePubParameters_commonUbuntu;
}

pkgRePubParameters_DEFAULT_DEFAULT () {
      EH_problem "No Handler Found for ${opRunDistFamily}/${opRunDistGeneration}"
}

vis_pkgRePubParameters


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
