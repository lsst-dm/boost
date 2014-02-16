# EupsPkg config file. Sourced by 'eupspkg'

# Because boost is tarballed as './boost_X_Y_Z/...', instead of 'boost_X_Y_Z'
TAP_TAR_OPTIONS="--strip-components 2"

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

	./bootstrap.sh --without-libraries=mpi --prefix="$PREFIX" $WITH_TOOLSET
}

build()
{
	./b2 -j $NJOBS
}

install()
{
	clean_old_install

	./b2 -j $NJOBS install

	install_ups
}
