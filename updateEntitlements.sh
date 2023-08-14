#!/bin/bash
#Original keychain_dumper by Patrick Toomey
#Scrpt by @ReverseThatApp and @vocaeq

#Script built for palera1n/sileo/iOS 15 rootless jailbreaks
if [ ! "sqlite3" ]; then
  echo "sqlite3 does not exist" \
       "Install via sileo/cydia and run the script again"
  exit 1
fi

#KEYCHAIN_DUMPER_FOLDER=/usr/bin
#KEYCHAIN DUMPER FOLDER for palera1n jailbreak ios 15
KEYCHAIN_DUMPER_FOLDER=/var/jb/usr/bin
if [ ! -d "$KEYCHAIN_DUMPER_FOLDER" ] ; then
  mkdir "$KEYCHAIN_DUMPER_FOLDER" ;
fi


if [ ! -f "$KEYCHAIN_DUMPER_FOLDER/keychain_dumper15" ]; then
  echo "The file \"$KEYCHAIN_DUMPER_FOLDER/keychain_dumper15\" does not exist. " \
       "Move the binary into the folder \"$KEYCHAIN_DUMPER_FOLDER/\" and run the script again."
  exit 1
fi

# set -e ;

ENTITLEMENT_PATH=$KEYCHAIN_DUMPER_FOLDER/ent.xml

dbKeychainArray=()
declare -a invalidKeychainArray=(
        "com.apple.bluetooth"
        "com.apple.cfnetwork"
        "com.apple.cloudd"
        "com.apple.continuity.encryption"
        "com.apple.continuity.unlock"
        "com.apple.icloud.searchpartyd"
        "com.apple.ind"
        "com.apple.mobilesafari"
        "com.apple.rapport"
        "com.apple.sbd"
        "com.apple.security.sos"
        "com.apple.siri.osprey"
        "com.apple.telephonyutilities.callservicesd"
        "ichat"
        "wifianalyticsd"
        "com.apple.apsd"
        "com.apple.sharing.appleidauthentication"
        "com.apple.Spotlight"
        "com.apple.TextInput"
        "com.apple.PassbookUIService"
        "com.apple.ProtectedCloudStorage"
        "com.apple.assistant"
        "com.apple.networkserviceproxy"
        "group.com.apple.notes"
      )

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $ENTITLEMENT_PATH
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> $ENTITLEMENT_PATH
echo "<plist version=\"1.0\">" >> $ENTITLEMENT_PATH
echo "  <dict>" >> $ENTITLEMENT_PATH
echo "    <key>keychain-access-groups</key>" >> $ENTITLEMENT_PATH
echo "    <array>" >> $ENTITLEMENT_PATH

sqlite3 /var/Keychains/keychain-2.db "SELECT DISTINCT agrp FROM genp" > ./allgroups.txt
sqlite3 /var/Keychains/keychain-2.db "SELECT DISTINCT agrp FROM cert" >> ./allgroups.txt
sqlite3 /var/Keychains/keychain-2.db "SELECT DISTINCT agrp FROM inet" >> ./allgroups.txt
sqlite3 /var/Keychains/keychain-2.db "SELECT DISTINCT agrp FROM keys" >> ./allgroups.txt

while IFS= read -r line; do
  dbKeychainArray+=("$line")
    if [[ ! " ${invalidKeychainArray[@]} " =~ " ${line} " ]]; then
      echo "      <string>${line}</string>">> $ENTITLEMENT_PATH
  #else
    #echo "Skipping ${line}"
  fi
done < ./allgroups.txt

# cat ./allgroups.txt | sed 's/.*/\ \ \ \ \ \ \ \ \<string\>&\<\/string\>/' >> $ENTITLEMENT_PATH
rm ./allgroups.txt

echo "    </array>">> $ENTITLEMENT_PATH
echo "    <key>platform-application</key> <true/>">> $ENTITLEMENT_PATH
echo "    <key>com.apple.private.security.no-container</key>  <true/>">> $ENTITLEMENT_PATH
echo "  </dict>">> $ENTITLEMENT_PATH
echo "</plist>">> $ENTITLEMENT_PATH


count=$(grep -c '<string>.*</string>' "$ENTITLEMENT_PATH")
if [ $count -gt 36 ]; then
 echo "[WARN] You have:$count in your entitlement file. Please delete some and run again"
 exit 1
else
 echo "[INFO] You have:$count lines in your entitlement file. Updating ent's"
 cd $KEYCHAIN_DUMPER_FOLDER
 ldid -Sent.xml keychain_dumper15
echo "[INFO] Entitlements updated"
fi


