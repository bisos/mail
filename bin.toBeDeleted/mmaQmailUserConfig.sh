#!/bin/bash
#!/bin/bash 

typeset RcsId="$Id: mmaQmailUserConfig.sh,v 1.1.1.1 2016-06-08 23:49:51 lsipusr Exp $"

if [ "${loadFiles}X" == "X" ] ; then
    seedActions.sh -l $0 $@
    exit $?
fi

. ${opBinBase}/mmaLib.sh
. ${mailBinBase}/mmaQmailLib.sh

vis_examples() {
  typeset visLibExamples=`visLibExamplesOutput ${G_myName}`
 cat  << _EOF_
EXAMPLES:
${visLibExamples}
MAIL ENVIRONEMNT VARIABLES ---
${G_myName} -i mailTest
${G_myName} -i submitDefaultCshEnvSet
${G_myName} -i submitParamsSet
${G_myName} -i submitParamsShow
TEST MSG ORIGINATION ---
${G_myName} -i mailTest
_EOF_
}

vis_help () {
  cat  << _EOF_
MB: 2008: Of not much use.
Setup User specific environment variables for qmail.
To see examples run:
${G_myName} -i examples
_EOF_
}

noArgsHook() {
    vis_examples
}


vis_submitDefaultCshEnvSet() {

# Also relevant are QMAILIDHOST
# 

#setenv  QMAILHOST mohsen.banan.1.byname.net; setenv  QMAILUSER machine-bounces
 cat  << _EOF_
setenv  QMAILHOST mohsen.banan.1.byname.net; setenv  QMAILUSER admin
_EOF_
   
}

vis_submitParamsSet() {

cat  << _EOF_
QMAILHOST=mohsen.banan.1.byname.net; QMAILUSER=machine-notices; export QMAILHOST; export QMAILUSER
_EOF_
}

vis_submitParamsShow() {

# Also relevant are QMAILIDHOST
# 
env | egrep 'QMAILUSER=|QMAILHOST='
   
}

vis_mailTest() {

QMAILHOST=mohsen.banan.1.byname.net; QMAILUSER=admin; export QMAILHOST; export QMAILUSER

  #toAddress="badbad78@yahoo.com"
  toAddress="mohsen@neda.com"
  fromAddress="office@mohsen.banan.1.byname.net"

  subjectField="Test Message, Ignore"


  cat > /tmp/${G_progName}.$$ << _EOF_ 
From: ${fromAddress} 
To: ${toAddress} 
Subject: ${subjectField}

IGNORE.

_EOF_

    #cat /tmp/${G_progName}.$$ | /usr/ucb/mail -t

    #cat /tmp/${G_progName}.$$ | ${qmailInject} -n -f ${fromAddress} 
    #cat /tmp/${G_progName}.$$ | ${qmailInject} -f ${fromAddress} 
cat /tmp/${G_progName}.$$ | ${qmailInject} 

    LOG_message "Test Mail Sent To ${toAddress}"

    #/bin/rm /tmp/${G_progName}.$$ 
}
