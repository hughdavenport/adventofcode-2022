#!/bin/sh

FILE="$1"
rm build/$FILE.cpp
jakt -S "$FILE.jakt"
# Jakt doesn't give a good return code because of my modifications
#if [ $? != 0 ] {
if [ ! -f build/$FILE.cpp ] {
	echo "Failed compilation of $FILE.jakt"
	exit 1
}
pushd build
	g++ -Wno-literal-suffix -Wno-unused-local-typedefs -Wno-unused-function -Wno-unused-variable -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-unused-result -Wno-implicit-fallthrough -Wno-trigraphs -Wno-parentheses-equality -Wno-unqualified-std-cast-call -Wno-user-defined-literals -Wno-return-type -Wno-deprecated-declarations -Wno-unknown-warning-option -Wno-unused-command-line-argument -fdiagnostics-color=always -Wno-unknown-attributes -fno-exceptions -std=gnu++20 -I/home/anon/Source/jakt/runtime/ "$FILE.cpp" -c -MD -MT "$FILE.cpp.o" -MF "$FILE.cpp.d" -o "$FILE.cpp.o"
	if [ $? != 0 ] {
		echo "Failed compilation of $FILE.cpp"
		popd
		exit 1
	}
	g++ -Wno-literal-suffix -Wno-unused-local-typedefs -Wno-unused-function -Wno-unused-variable -Wno-unused-parameter -Wno-unused-but-set-variable -Wno-unused-result -Wno-implicit-fallthrough -Wno-trigraphs -Wno-parentheses-equality -Wno-unqualified-std-cast-call -Wno-user-defined-literals -Wno-return-type -Wno-deprecated-declarations -Wno-unknown-warning-option -Wno-unused-command-line-argument -fdiagnostics-color=always -Wno-unknown-attributes -fno-exceptions -std=gnu++20 -I/home/anon/Source/jakt/runtime/ "helpers.cpp" -c -MD -MT "helpers.cpp.o" -MF "helpers.cpp.d" -o "helpers.cpp.o"
	if [ $? != 0 ] {
		echo "Failed compilation of helpers.cpp"
		popd
		exit 1
	}
	g++ "$FILE.cpp.o" helpers.cpp.o jakt__*.o -o $FILE -Wl,--hash-style=gnu,-z,relro,-z,now,-z,noexecstack,-z,separate-code,-z,max-page-size=0x1000 -L/home/anon/Source/jakt/build/lib/ -ljakt_main -ljakt_runtime
	if [ $? != 0 ] {
		echo "Failed linking of $FILE"
		popd
		exit 1
	}
	echo "Built $FILE"
popd
