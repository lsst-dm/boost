# EupsPkg config file. Sourced by 'eupspkg'

config()
{
	detect_compiler

	# warn about non-clang builds on Macs
	if [[ "$(uname)" == "Darwin" && "$COMPILER_TYPE" != clang ]]; then
		warn "boost needs clang on OS X (you're compiling it with $COMPILER_TYPE. hope you know what you're doing."
	fi

	if [[ "$COMPILER_TYPE" == clang ]]; then
		WITH_TOOLSET="--with-toolset=clang"
	fi

        # Disable unicode regex support to make the binary more portable
	./bootstrap.sh --without-libraries=mpi --without-icu --prefix="$PREFIX" $WITH_TOOLSET
}

build()
{
	detect_compiler
	echo "Building boost with cxxflags=$CXX_CXX11_FLAG"

	./b2 -j $NJOBS cxxflags=$CXX_CXX11_FLAG
}

install()
{
	clean_old_install

	./b2 -j $NJOBS install

	install_ups

        if [[ $OSTYPE == darwin* ]]; then
            install_name_tool -change libpython2.7.dylib @rpath/libpython2.7.dylib "$PREFIX"/lib/libboost_python.dylib
        fi

}
