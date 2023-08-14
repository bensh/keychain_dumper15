# Keychain Dumper

## Usage

Forked copy of ptoomey3/Keychain-Dumper, lighter weight, less options to allow for flexability and scripting. Working for iOS15

New flags:

    -l: Lists all entitlement groups 
    -f: Dumps Keychain items for provided group name via stdin
    -f [group_name]: Dumps Keychain items for inline group name
    
*** Installation remains the same, and signing with entitlements.

Tested on:   
- iPhone X 15.6

By default keychain_dumper only dumps "Generic" and "Internet" passwords.  This is generally what you are interested in, as most application passwords are stored as "Generic" or "Internet" passwords.  However, you can also pass optional flags to dump additional information from the Keychain.  If you run keychain_dumper with the `-h` option you will get the following usage string:

    Usage: keychain_dumper [-e]|[-h]|[-aslf]
    <no flags>: Dump Password Keychain Items (Generic Password, Internet Passwords)
    -a: Dump All Keychain Items (Generic Passwords, Internet Passwords, Identities, Certificates, and Keys)
    -e: Dump Entitlements
    -s: Dump Selected Entitlement Group
    -l: List All Entitlement Groups
    -f: Dump by Group Name using input prompt
    -f [group name]: Dump Filtered Group

By default passing no option flags is equivalent to running keychain_dumper with the `-gn` flags set.  The other flags largely allow you to dump additional information related to certificates that are installed on the device.

### Entitlements
If you don't want to use the wildcard entitlment file that is provided (or you are running more modern versions of iOS that don't support a wildcafrd entitlement), you can also sign specific entitlements into the binary.  Using the unsigned Keychain Dumper you can get a list of entitelments that exist on your specific iOS device by using the `-e` flag.  For example, you can run Keychain Dumper as follows:

    ./keychain_dumper -e > /var/tmp/ent.xml

The resulting file can be used in place of the included entitlements.xml file.

    ldid -S/var/tmp/ent.xml /var/jb/usr/bin/keychain_dumper15

If you are running more modern versions of iOS, there is a limit of 36 group names that can be assinged to the binary via the entitlements file. In this case, you can use the script updateEntitlements.sh, or create the ent.xml file as above, and manually remove lines from the file using vi/vim/nano etc.

Lines that can be removed (on iOS15.6):
- "com.apple.bluetooth"  
- "com.apple.cfnetwork"  
- "com.apple.cloudd"
- "com.apple.continuity.encryption"
- "com.apple.continuity.unlock"
- "com.apple.icloud.searchpartyd"
- "com.apple.ind"
- "com.apple.mobilesafari"
- "com.apple.apsd"
- "com.apple.sharing.appleidauthentication"
- "com.apple.Spotlight"
- "com.apple.TextInput"
- "com.apple.PassbookUIService"
- "com.apple.ProtectedCloudStorage"
- "com.apple.assistant"
- "com.apple.networkserviceproxy"
- "group.com.apple.notes"
- "com.apple.rapport"
- "com.apple.sbd"
- "com.apple.security.sos"
- "com.apple.siri.osprey"
- "com.apple.telephonyutilities.callservicesd"
- "ichat"
- "wifianalyticsd"    

## Building

### Create a Self-Signed Certificate

Open up the Keychain Access app located in /Applications/Utilties/Keychain Access

From the application menu open Keychain Access -> Certificate Assistant -> Create a Certificate

Enter a name for the certificate, and make note of it, as you will need it later when you sign `keychain_dumper`.  Make sure the Identity Type is “Self Signed Root” and the Certificate Type is “Code Signing”.  You don’t need to check the “Let me override defaults” unless you want to change other properties on the certificate (name, email, etc).

### Build It

You should be able to compile the project using the included makefile.

    make

If all goes well you should have a binary `keychain_dumper` placed in the same directory as all of the other project files.

### Sign It

First we need to find the certificate to use for signing.

    make list

Find the 40 character hex string corresponding to the certificate you generated above. You can then sign `keychain_dumper`.

    CER=<40 character hex string for certificate> make codesign



