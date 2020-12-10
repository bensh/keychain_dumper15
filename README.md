# Keychain Dumper

## Usage

Forked copy of ptoomey3/Keychain-Dumper, with extra options to allow for flexability and scripting.

    -l: Lists all entitlement groups 
    -f: Dumps Keychain items for provided group name
    
*** All other options remain the same, including installation, and signing with entitlements.
    Tested on:
        iPhone 6 12.4.3
        iPhone 7 Plus 11.2.5

By default keychain_dumper only dumps "Generic" and "Internet" passwords.  This is generally what you are interested in, as most application passwords are stored as "Generic" or "Internet" passwords.  However, you can also pass optional flags to dump additional information from the Keychain.  If you run keychain_dumper with the `-h` option you will get the following usage string:

    Usage: keychain_dumper [-e]|[-h]|[-agnick]
    <no flags>: Dump Password Keychain Items (Generic Password, Internet Passwords)
    -s: Dump All Keychain Items of a selected entitlement group
    -a: Dump All Keychain Items (Generic Passwords, Internet Passwords, Identities, Certificates, and Keys)
    -e: Dump Entitlements
    -g: Dump Generic Passwords
    -n: Dump Internet Passwords
    -i: Dump Identities
    -c: Dump Certificates
    -k: Dump Keys

By default passing no option flags is equivalent to running keychain_dumper with the `-gn` flags set.  The other flags largely allow you to dump additional information related to certificates that are installed on the device.

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

You should now be able to follow the directions specified in the Usage section above.  If you don't want to use the wildcard entitlment file that is provided (or you are runnig more modern versions of iOS that don't support a wildcafrd entitlement), you can also sign specific entitlements into the binary.  Using the unsigned Keychain Dumper you can get a list of entitelments that exist on your specific iOS device by using the `-e` flag.  For example, you can run Keychain Dumper as follows:

    ./keychain_dumper -e > /var/tmp/entitlements.xml

The resulting file can be used in place of the included entitlements.xml file.

