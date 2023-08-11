GCC_BIN=`xcrun --sdk iphoneos --find gcc`
#THEOS SDKs downloaded from Theos github - https://github.com/theos/sdks
SDK=$(THEOS)/sdks/iPhoneOS12.4.sdk
ARCH_FLAGS=-arch arm64

LDFLAGS	=\
	-F$(SDK)/System/Library/Frameworks/\
	-F$(SDK)/System/Library/PrivateFrameworks/\
	-framework UIKit\
	-framework CoreFoundation\
	-framework Foundation\
	-framework CoreGraphics\
	-framework Security\
	-lobjc\
	-lsqlite3\
	-bind_at_load

GCC_ARM = $(GCC_BIN) -Os -Wimplicit -isysroot $(SDK) $(ARCH_FLAGS)

default: main.o list
	@$(GCC_ARM) $(LDFLAGS) main.o -o keychain_dumper15

main.o: main.m
	$(GCC_ARM) -c main.m

clean:
	rm -f keychain_dumper15 *.o

list:
	security find-identity -pcodesigning
	@printf '\nTo codesign, please run: \n\tCER="<40 character hex string for certificate>" make codesign\n'

codesign:
	codesign -fs "$(CER)" --entitlements ent.xml keychain_dumper15
