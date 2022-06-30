#!/bin/bash
#!/bin/bash

echo "OBSOLETED BY: /libre/ByStar/InitialTemplates/activeDocs/bxServices/mailManage/roadmap/fullUsagePanel-en.org"

exit 1

typeset RcsId="$Id: mmaQmailRoadmap.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
    seedActions.sh -l $0 $@
    exit $?
fi


function vis_examples {
  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
--- Information
${G_myName} -i modelAndTerminology
${G_myName} -i todos
${G_myName} -i help
${G_myName} -i qmailLists
${G_myName} -i howTos
${G_myName} -i pointersAndReferences
${G_myName} -i printDocs
${G_myName} -i printPackage
${G_myName} -i printItems
_EOF_
}


function noArgsHook {
  vis_examples
}

function vis_todos {
 cat  << _EOF_

  QMAIL TODOs
  ===========

Short Term:
----------


- mmaQmailLists.sh
    - The entire file should be split into two.
        1) Manipulates the mailing list.
	2) Makes the list web accesible.

     - mmaQmailRecorders.sh links the list to
       an archiver/processor/webBuilder.

     - mmaQmailWebLists.sh runs mhOnArc ...

- Items files cleanups.

- In hostItems.site add:

   -- Max incoming message size.
   -- Submit Accept
   -- Submit Reject (tcprules)

Long Term:
---------

 - Switching mbox formats to maildir -- and imap coordinate
 - Log file manipulators
 - svc start/stop scripts
 - Mail rejection manipulation
 - Archiver posting restrictions
 - spam assasin integration
_EOF_
}

function vis_qmailLists {
  # Perhaps after done should go in the help of mmaQmailLists.sh
  # - ascii picture goes here
  # - Items file field by field description.
  # - Text file generations

 cat  << _EOF_

    +------------------------+
    |   Jetspeed E-Groups    |
    +------------------------+


          +---------------+  +---------------+
          | mmaQmailLists |  | bynameNspMail |
          +---------------+  +---------------+
 +----------+
 | MHonArch |
 +----------+
 +--------------+
 |    EZMLM     |
 +--------------+

                  +----------------------+
                  |      Address         |
                  +----------------------+
                  +-------------+ +----------------+
                  | mainDomains | | VirtualDomains |
                  +-------------+ +----------------+
                  +----------------------------+
                  |           mmaQmailLib      |
                  +----------------------------+
                  +------------------------------------+
                  |           QMAIL                    |
                  +------------------------------------+

_EOF_
}


function vis_modelAndTerminology {
 cat  << _EOF_

   Terminology and Model:
   ======================

 - FQMA:          Full Qualified Mail Address -- localPart@domainPart

 - localPart:     Stuff to the left of @ sign

 - domainPart:    Domain to the right of @ sign

 - qmailAddr:     A tupple of (localPart) and qmailCtlFile

 - qmailCtlFile:  A .qmail or .qmail-xxx file

 - qmailAccount:  A system account recorded in the users/include

 - locDeliveryAcct: same as qmailAccount

 - qmailDomainType:  One of virDomain or mainDomain

 - mailSorter:   As part of delivery in qmailCtlFile, 
                 select appropriate mailRepository.

 - mailRepository:  A respository of incoming delivered mail.
                    One of mbox or maildir format.

 - mbox:          A file specification in a qmailCtlFile.
                  Multiple localPart and qmailAddr may
                  share the same mbox

 - maildir:       A file specification in a qmailCtlFile.
                  Multiple localPart and qmailAddr may
                  share the same mbox

 - progs:         A pipe specification in a qmailCtlFile.

 - forwards:      A pipe specification in a qmailCtlFile.


Objects Overview:
-----------------

item_qmailHost_{HostName}: Config Parameters for the mail server host.

                           Server Type is on of:
                           (submitClientSmtp|submitServerSmtp|fullServer)

                           Objects below apply to fullServer.

item_qmailDom_{domainName}: Information about a domain.
                            Both mainDomain and virDomain object types.
                            Includes pointers back to item_qmailHost and
                            forward to item_qmailAcctsList.

item_qmailAcctsList_{domainName}:  List of item_qmailAcct for domainName

item_qmailAcct:  Tupple of
                 1) systemAcct
                 2) List of item_qmailAddr

item_qmailAddr:
                 - addrName  (localPart)
                 - type ((alias|virDom)=tldAddr, person, prog)
                 - mbox
                 - forward
                 - ...

item_distList:
                 - name
                 - postingRestrictions
                 - archiving
                 - ...

byname/NSP/mailAddr:
                 - byname mail boxes


mmaQmail Object Processors and Containers:
------------------------------------------

    mmaQmailHosts.sh

    mmaQmailDoms.sh

    mmaQmailAddrs.sh

    mmaQmailLists.sh

    bynameNspMail.sh


qmailHost Objects:
------------------

   qmailSetup can be any combination of:
         localInjectAgent  submitServerSmtp inNetSmtp localDeliveryAgent outNetSmtp


   The above plus config params can be combined to 
   bring about desired capabilities. Including common server types.

   All of what is below implies inclusion of qmail-queue, qmail-send,

     localInjectAgent:   Includes:  qmail-inject

                         Does not accept smtp connections.
                         Does not do local-delivery.

     submitServerSmtp:   Includes:  qmail-smtpd

                         No other feature.
                         Could be on port 53 not port 25.
                         Usually  restricted with tcpserver.

     inNetSmtp:          Includes:  qmail-smtpd
          
                         No other feature.
                         Always on port 25. 
                         Accepts from all for known routing 
                         or local delivery.

     localDeliveryAgent: Includes:  qmail-lspawn qmail-local
                       

     outNetSmtp:         Includes:  qmail-rspawn  qmail-remote



Common Server Types:
--------------------

     nullClient:        localInjectAgent + outNetSmtp

     submitServer:      submitServerSmtp + outNetSmtp

     mailRouter:        inNetSmtp + outNetSmtp

     fullServer:        localInjectAgent + outNetSmtp + inNetSmtp + submitServerSmtp
    
_EOF_
}


function vis_help {
 cat  << _EOF_
NAME
     ${G_myName}

SYNOPSIS
     Derived from seedActions.sh, use the -u.
     ${G_myName} -u

DESCRIPTION
     mmaQmail (MailMeAnywhere QMAIL) is a set of consistent
     policies built on the QMAIL as a CAPABILITY and on
     (OSMT) Open Services Management Tools.

     mmaQmail Commands, each contain a set of related functions
     which allow you to accomplish specific tasks. Specifically:

  mmaQmailRoadmap.sh              -- This File. General Orientation and Information

  mmaQmailLib.sh           -- To be included in all mmaQmail scripts.
                              General configuration parameters and
                              general useful functions go here

  mmaQmailBinsPrep.sh      -- Prepare binary files for qmail/ezmlm
                           -- for relevant pltforms and versions

  mmaQmailBinsInstall.sh   -- Install mmaQmail binaries on opRunHostName

  mmaQmailHosts.sh         -- For subject host, configure qmail

  mmaQmailAdmin.sh         -- Start, stop and addNewAccounts

  mmaQmailUserConfig.sh    -- Setup Per user environment parameters.

  mmaQmailAddrs.sh         -- mmaQmailAddrItems specify addresses (e.g. postmaster)
                           -- to be genarted as .qmail- files.

qmailDom
-----------

  mmaQmailDoms.sh           -- mmaQmailVirDomItems.site specifies visible virtual domains.
                            -- Verify and ensure creation of accounts
                            -- for virtual domains (e.g. esro.org and lists.esro.org)
                            -- add the virtual domains to qmail host configurations.


qmail Mailing Lists
-------------------

  mmaQmailLists.sh          -- mmaQmailListItems specify information needed to create
                            -- and activate needed mailing lists.
                            -- Archiving, web exposure (mhonarc) are all done
                            -- here.

ByName Support
--------------

  bynameNspMail.sh          -- Generate and maintain addresses

  bynameNspMailList.sh      -- Track and control mailing list generation


USAGE
     See specific mmaQmailXxxx  commands.


EXIT STATUS
         opClusterName   The cluster name

FILES
      mmaQmail*
      ${systemName}
      ${devlOsType}

_EOF_
}

function vis_howTos {
 cat  << _EOF_

    A-1) How Do I install Qmail on my system?
       Follow the steps below.

       0) Setup Open Services Platform Environment.
          In /opt/public/osmt/bin/
          source opEnvSet.csh -- . opEnvSet.ksh

       1) Disable the existing sendmail functionality
          mmaSendmailActions.sh -i sendmailDefunct

       2) Install Qmail Binaries.
          mmaQmailBinsInstall.sh -i qmailFullInstall


    A) How Do I setup a null client from scratch?
       Follow (A-1), and then:


       3) Specify basic null client paramters (smarthost, domain, ...)
         In ../siteControl/nedaPlus/mmaQmailListItems.main
         add an entry for your host. Then:

         mmaQmailHosts.sh -s ${opRunHostName} -a configure

       4) Verify and Monitor installation

         mmaQmailAdmin.sh -i fullReport

       5) Sendout a test message.

         mmaQmailUserConfig.sh -i mailTest

       6) Allow users to customize their desired parameters.

         mmaQmailUserConfig.sh

    B: How do I create a new binary kit for a new rev of Linux/SunOs?

       mmaQmailBinsPrep.sh -i mmaQmailBuildAndInstall
       mmaQmailBinsPrep.sh -i mmaQmailBinKitMake

    C: How Do I Setup an Domain Mail Server?

    C: How Do I Setup a mailing list?

_EOF_
}


function vis_pointersAndReferences {
 cat  << _EOF_

Life With Qmail: http://www.lifewithqmail.org/
http://debian.iuculano.it/
http://wiki.debian.iuculano.it/
http://www.profv.de/qmail-debian-patches/
http://www.qmail.org
http://rocketscience.lukasfeiler.com/bigqmail.patch
http://jclement.ca/docs/debian_qmail/debian_qmail/
http://forum.qmailrocks.org/showthread.php?t=5670
August 2007
http://mail.michscimfd.com/dspam/
http://www.qmailrocks.com/install_db.htm
http://mail-toaster.org/
http://www.shupp.org/toaster/?page=toc
2008
RealRcpt
http://code.dogmap.org./qmail/
SMTP Auth
http://www.fehcom.de/qmail/smtpauth.html#PATCHES
2008 -- SSL TLS with ucspi
http://www.suspectclass.com/~sgifford/ucspi-tls/ucspi-tls-qmail-howto.html
2008 DJBWAY
http://thedjbway.org/mess822/ofmipd.html
http://thedjbway.org/ssl.html
_EOF_
}

function vis_printDocs {
  #nroff -t 
  # NOTYET, man -k and full processing of 
  # all of /var/qmail/man/ 
  return 
}

function vis_printPackage {
  typeset filesToPrint=""
  typeset filesList="\
 mmaQmailRoadmap.sh\
 mmaQmailLib.sh\
 mmaQmailBinsPrep.sh\
 mmaQmailHosts.sh\
 mmaQmailNewHosts.sh\
 mmaQmailDoms.sh\
 mmaQmailAddrs.sh\
 mmaQmailInject.sh\
 mmaQmailLists.sh\
 mmaQmailUserConfig.sh\
 bynameNspMail.sh\
 bynameNspMailLists.sh\
"

  typeset thisOne=""
  for thisOne in ${filesList} ; do
    #filesToPrint="${filesToPrint} ${opBinBase}/${opRunSiteName}/${thisOne}"
    filesToPrint="${filesToPrint} ${thisOne}"
  done

  opDoComplain a2ps -s 2 ${filesToPrint}
}

function vis_printItems {
  typeset filesToPrint=""
  typeset filesList="\
 mmaQmailNewHostItems.site\
 mmaQmailNewHostItems.site\
 mmaQmailListItems.special\
 mmaQmailAddrItemsMore.ssis-inc.com\
 mmaQmailAddrItems.site\
 mmaQmailAddrItems.secLvlDomBasic\
 mmaQmailDomItems.site\
"
# ../siteControl/ssis/mmaQmail

  typeset thisOne=""
  for thisOne in ${filesList} ; do
    #filesToPrint="${filesToPrint} ${opSiteControlBase}/${opRunSiteName}/${thisOne}"
    filesToPrint="${filesToPrint} ${opSiteControlBase}/ssis/${thisOne}"
  done

  opDoComplain a2ps -s 2 ${filesToPrint}
}
