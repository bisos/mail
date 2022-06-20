#!/bin/bash
#!/bin/bash 

typeset RcsId="$Id: lcaQmailAnalogBinsPrep.sh,v 1.3 2020-02-03 01:28:40 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
     seedSubjectBinsPrepDist.sh  -l $0 "$@"
     exit $?
fi

itemOrderedList=( "qmailanalog" )


item_qmailanalog() {

  distFamilyGenerationHookRun binsPrep_qmailanalog
}

binsPrep_qmailanalog_commonDebian () {
    binsPrep_qmailanalog_commonUbuntu
}

binsPrep_qmailanalog_commonUbuntu () {
  mmaThisPkgName="qmailanalog"
  mmaPkgDebianName="${mmaThisPkgName}"
  mmaPkgDebianMethod="dpkg"
  # /var/osmt/distPkgs/i386
  mmaPkgDebianFile=$( lcaQmailAnalogDebPkg.sh -i binPkgFullPath )
  binsPrep_installPreHook=""
  binsPrep_installPostHook=""
  binsPrep_pkgObtainCmd="lcaQmailAnalogDebPkg.sh -i binPkgObtain"
}



binsPrep_qmailanalog_DEFAULT_DEFAULT () {
      EH_problem "No Handler Found for ${opRunDistFamily}/${opRunDistGeneration}"
}


binsPrep_qmailanalog_DEBIAN_SARGE () { binsPrep_qmailanalog_commonDebian; }

binsPrep_qmailanalog_DEBIAN_ETCH () { binsPrep_qmailanalog_commonDebian; }

binsPrep_qmailanalog_DEBIAN_LENNY () { binsPrep_qmailanalog_commonDebian; }

binsPrep_qmailanalog_DEBIAN_SQUEEZE () { binsPrep_qmailanalog_commonDebian; }

binsPrep_qmailanalog_DEBIAN_7 () { binsPrep_qmailanalog_commonDebian; }

binsPrep_qmailanalog_UBUNTU_2004 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1804 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1604 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1404 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1310 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1210 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1204 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1110 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1104 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1010 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_1004 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_910 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_904 () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_INTREPID () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_HARDY () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_GUTSY () { binsPrep_qmailanalog_commonUbuntu; }

binsPrep_qmailanalog_UBUNTU_FEISTY () { binsPrep_qmailanalog_commonUbuntu; }


function examplesHookPost {
  cat  << _EOF_
----- POST HOOK EXAMPLES -------
_EOF_
}

