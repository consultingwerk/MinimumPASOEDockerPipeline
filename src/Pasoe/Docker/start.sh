#!/bin/bash
#
# start script
#
PasoeName=HelloWorldPasoe
Dlc=/psc/dlc
Pasoe=/psc/wrk/${PasoeName}
PasoeLogs=${Pasoe}/logs
PasoeBin=${Pasoe}/bin
PasoeAgentLog=${PasoeLogs}/${PasoeName}.agent.`date +%Y-%m-%d`.log
TimeOut=60

if [ -r "${PasoeLogs}/*" ] ; then
  echo "# Cleaning logs in : ${PasoeLogs}"
  rm ${PasoeLogs}/*
fi

# Start the appserver

${PasoeBin}/tcman.sh start -v
echo "#########################################################"
echo "#                                                       #"
echo "# Starting Docker Container                             #"
echo "#                                                       #"
echo "#########################################################"
echo "# Waiting until the Catalina starts                     #"
echo "#########################################################"
i=0
until [ -f "${PasoeLogs}/catalina.out" ]
do
     sleep 1
     printf "."
     ((i=i+1))
     if [ ${i} -ge ${TimeOut} ] ; then
       echo "#########################################################"
       echo "# Error: Catalina was not able to start                 #"
       echo "#########################################################"
       cat ${PasoeLogs}/*
       ls -ltr ${PasoeLogs}/*
       bash
       exit 1
     fi
done
# Give the Catalina some time to log something useful
sleep 3
cat ${PasoeLogs}/catalina.out

echo "#########################################################"
echo "# Waiting until the Pasoe agent starts                  #"
echo "#########################################################"
echo "Searching for file: ${PasoeAgentLog}"

i=0
until [ -f "${PasoeAgentLog}" ] ; do
     sleep 1
     printf "."
     ((i=i+1))
     if [ ${i} -ge ${TimeOut} ] ; then
       echo "#########################################################"
       echo "# Error: the Pasoe agent was not able to start          #"
       echo "#########################################################"
       cat ${PasoeLogs}/*
       ls -ltr ${PasoeLogs}/*
       bash
       exit 1
     fi
done

printf "\n"

if [ "x$1" != "xmenu" ] ; then
  first=true
else
  first=false
fi

until [ "${Answer}" = "x" ] ; do
   Answer="?"

   if [ x${first} = xtrue ] ; then
     Answer=c
     first=false
   else
     echo "\n#########################################################"
     echo "# p     - Escape to proenv                                #"
     echo "# x     - Stop the Docker container                       #"
     echo "# c     - Continue                                        #"
     echo "# l     - List Pasoe logs directory                       #"
     echo "# b     - List agent logfile from the beginning           #"
     echo "# a     - List all logfiles in /logs                      #"
     read -rsn1 Answer
   fi

   case "${Answer}" in
      "p") ${Dlc}/bin/proenv ;;
      "c") tail -f ${PasoeAgentLog} ;;
      "l") ls -ltr ${PasoeLogs} ;;
      "b") cat ${PasoeAgentLog} ;;
      "l") cat ${PasoeLogs}/* ;;
      "x") exit 0 ;;
   esac
done


