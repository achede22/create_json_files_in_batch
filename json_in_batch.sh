#!/bin/bash

## create 16 json files in batch
##
#      set -x
#      trap read debug

SERVICE=zappos   # zappos or 6pm
HOST='101'    #101 , 102, 103, 104 -- 201, 202, 203, 204
FILE=
STEP=1
PORT=



# Go to folder
mkdir -p ~/development/sensu-server-conf/linux-servers/api-servers
cd ~/development/sensu-server-conf/linux-servers/api-servers

#create folders
mkdir -p api{101,102,103,104,201,202,203,204}.zappos.net/zappos
mkdir -p api{101,102,103,104,201,202,203,204}.zappos.net/6pm

# the first while starts here
while [ $STEP -lt 3 ]
do



# step 1 -- service zappos for 101 , 102, 103, 104 -- 201, 202, 203, 204
# step 2 -- service   6pm  for 101 , 102, 103, 104 -- 201, 202, 203, 204
# step 3 -- end

  if [ "$STEP" -eq "1" ]
  then
    SERVICE=zappos
    PORT=8080

        elif [ "$STEP" -eq "2" ]
        then
    #      set -x
    #      trap read debug
        SERVICE=6pm
        PORT=8081 #### 6pm port can be 9002 or 8081 , check carefully

  fi


# CHANGE HERE
  FILE=$HOME/development/sensu-server-conf/linux-servers/api-servers/api$HOST.zappos.net/$SERVICE/Patron"${SERVICE}"TomcatPort"${PORT}"-api$HOST.json

#### user verification
  echo $(date)
  echo $FILE
  echo "STEP $STEP"
  echo "service $SERVICE"
  echo "host api$HOST"

#    read -p  "hit enter to continue"



####### ZAPPOS & 6pm - JVM Thread - SCRIPT VERSION  ..  #101 , 102, 103, 104 -- 201, 202, 203, 204
###### Both share the same PLAYBOOK

#create file
# touch api$HOST.zappos.net/$SERVICE/Patron$SERVICE-JVMThreadsTomcatPort8080-api$HOST.json

touch $FILE


#modify these parameters according to the requires JSON file.


####### ZAPPOS & 6pm - TOMCAT - SCRIPT VERSION  ..  #101 , 102, 103, 104 -- 201, 202, 203, 204
###### Both share the same PLAYBOOK

echo '

{
  "checks": {
    "Patron'${SERVICE}'TomcatPort'${PORT}'-api'${HOST}'": {
      "command": "/opt/sensu/plugins/check_http -H api'${HOST}'.zappos.net -w 3 -c 5 -t 4 -p '${PORT}' -u \"/Info?key=939f2f3a5845a03f3881c77ee01db97\"",
      "handler": "mailer",
      "interval": 60,
      "standalone": true,
      "source": "api'${HOST}'.zappos.net",
      "playbook": "https://confluence.zappos.net/display/L1/Z10047+-+Zapi+JVM+Threads+Count"
    }
  }
} ' > ${FILE}


# Verify JSON files
date >> json.verification.txt
echo "------------------------------- CHECKING HOST $HOST" >> json.verification.txt
jq . $FILE >> json.verification.txt
echo "" >> json.verification.txt



## incrase the HOST
  if [ "$HOST" -lt "104" ]; then
    HOST=$(( $HOST + 1 ))

     elif  [ "$HOST" -lt "199" ]; then
            HOST=201

          elif  [ "$HOST" -gt "199" ] && [ "$HOST" -lt "204" ] ; then
                  HOST=$(( $HOST + 1 ))

                #STEP increment
                else
                  STEP=$(( $STEP + 1 ))
                  HOST=101


  fi





# the first while finish here
done
# 16 json files
# cat json.verification.txt




################################################################################
################################################################################
