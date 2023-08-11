#
# Dockerfile for PASOE demo image
#

FROM store/progresssoftware/pasoe:12.7.0 

#
# Add Java
#

USER root 
ADD OpenJDK17U-jdk_x64_linux_hotspot_17.0.4.1_1.tar.gz /usr 
RUN mv /usr/jdk-17.0.4.1+1 /usr/java 
RUN chmod 777 /usr/java/bin/java
RUN chmod 777 /usr/java/bin
RUN chmod 777 /usr/java

# Deploy entry point script
COPY start.sh /psc/wrk
RUN mv /psc/wrk/start.sh /psc/wrk/start.txt
RUN sed 's/\r//' /psc/wrk/start.txt > /psc/wrk/start.sh 
RUN chmod +x /psc/wrk/start.sh 

#
# Creating PASOE
#
USER pscadmin 
ENV Pasoe /psc/wrk/HelloWorldPasoe 
ENV AppRoot $Pasoe/openedge 
RUN export DLC=/psc/dlc JAVA_HOME=/usr/java &&\
    $DLC/servers/pasoe/bin/tcman.sh create -p 8820 -P 8821 -s 8822 $Pasoe

# Deploy app
COPY Application.pl $AppRoot    

RUN export DLC=/psc/dlc JAVA_HOME=/usr/java &&\
     $Pasoe/bin/oeprop.sh '+AppServer.Agent.HelloWorldPasoe.PROPATH=$AppRoot/Application.pl,${DLC}/tty/netlib/OpenEdge.Net.pl,${DLC}/tty/OpenEdge.Core.pl,${DLC}/tty'

RUN export DLC=/psc/dlc JAVA_HOME=/usr/java &&\
    $Pasoe/bin/oeprop.sh '+HelloWorldPasoe.ROOT.WEB.adapterEnabled=1'  &&\
    $Pasoe/bin/oeprop.sh '+HelloWorldPasoe.ROOT.WEB.defaultHandler=OpenEdge.Web.CompatibilityHandler'  &&\
    $Pasoe/bin/oeprop.sh '+HelloWorldPasoe.ROOT.WEB.handler1=WebHandlers.HelloWorldWebHandler:/HelloWorld'


ENTRYPOINT ["/psc/wrk/start.sh"]
EXPOSE 8820
EXPOSE 8821
EXPOSE 8822






