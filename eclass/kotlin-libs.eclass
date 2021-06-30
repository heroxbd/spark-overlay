# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kotlin-libs.eclass
# @MAINTAINER:
# Yuan Liao <liaoyuan@gmail.com>
# @AUTHOR:
# Yuan Liao <liaoyuan@gmail.com>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: An eclass for building Kotlin library packages
# @DESCRIPTION:
# This eclass provides an abstraction of the Kotlin compiler to support
# building Kotlin library packages. It is based on java-pkg-simple.eclass and
# recognizes variables declared by that eclass when appropriate.

case "${EAPI:-0}" in
	6|7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS pkg_setup src_compile src_test src_install

# Allow use of EAPI 7 version manipulators in older EAPIs for both this eclass
# and consumer ebuilds
[[ "${EAPI:-0}" -eq 6 ]] && inherit eapi7-ver

# Kotlin Compiler options

# @ECLASS-VARIABLE: KOTLIN_LIBS_SRC_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain the Kotlin sources to
# compile for the ebuild. A string with directories separated by white space
# works as well. Default is unset, which will cause all source files inside
# ${S} to be compiled, and can be overriden from ebuild anywhere.

# @ECLASS-VARIABLE: KOTLIN_LIBS_MODULE_NAME
# @DESCRIPTION:
# The argument to kotlinc's -module-name option. Defaults to ${PN}, can be
# overriden from ebuild anywhere.
: ${KOTLIN_LIBS_MODULE_NAME:="${PN}"}

# @ECLASS-VARIABLE: KOTLIN_LIBS_COMMON_SOURCES_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contains the sources to pass
# to kotlinc's -Xcommon-sources option. Default is unset, can be overriden from
# ebuild anywhere.

# @ECLASS-VARIABLE: KOTLIN_LIBS_JAVA_SOURCE_ROOTS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of the arguments to kotlinc's -Xjava-source-roots option. This
# eclass will concatenate each element in the array into a single string, using
# a comma to separate each pair of adjacent elements, and pass the string as
# the option's value to kotlinc. Default is unset, can be overriden from ebuild
# anywhere.

# @ECLASS-VARIABLE: KOTLIN_LIBS_KOTLINC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of any extra arguments to kotlinc that will added after all other
# arguments set by the variables of this eclass and before the list of Kotlin
# source files. Default is unset, can be overriden from ebuild anywhere.

# @ECLASS-VARIABLE: KOTLIN_LIBS_CLASSPATH_EXTRA
# @DEFAULT_UNSET
# @DESCRIPTION:
# An extra comma- or space-separated list of Java packages that are needed only
# when sources are being compiled. Default is unset, can be overriden from
# ebuild anywhere.

# @ECLASS-VARIABLE: KOTLIN_LIBS_KOTLINC_JAVA_OPTS
# @DESCRIPTION:
# Any options for the JVM instances started by kotlinc. The default option
# allots enough memory to kotlinc to compile every Kotlin Standard Library
# component, and it can be overriden from ebuild anywhere.
: ${KOTLIN_LIBS_KOTLINC_JAVA_OPTS:="-Xmx768M"}

# Java compiler options for library components that have Java code

# @ECLASS-VARIABLE: KOTLIN_LIBS_JAVA_SRC_DIR
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of directories relative to ${S} which contain any Java sources to
# compile for the ebuild. A string with directories separated by white space
# works as well. Default is unset, in which case no additional Java sources
# will be compiled, and can be overriden from ebuild anywhere. A few Kotlin
# library components have additional Java sources that need to be compiled
# after the Kotlin sources, and this variable facilitates compilation of those
# Java sources.

# @ECLASS-VARIABLE: KOTLIN_LIBS_JAVA_WANT_SOURCE_TARGET
# @DESCRIPTION:
# The argument to javac's -source and -target options. Defaults to 1.6, which
# is what the upstream uses, and can be overriden from ebuild anywhere.
: ${KOTLIN_LIBS_JAVA_WANT_SOURCE_TARGET:="1.6"}

# @ECLASS-VARIABLE: KOTLIN_LIBS_JAVAC_ARGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# An array of any extra arguments to javac that will added after all other
# arguments set by the variables of this eclass and before the list of Java
# source files. Default is unset, can be overriden from ebuild anywhere.

# Helpful options when upgrading to a new feature release

_KOTLIN_LIBS_FEATURE_RELEASE_FROM_PV="$(ver_cut 1-2)"

# @ECLASS-VARIABLE: KOTLIN_LIBS_KOTLINC_MIN_VER
# @PRE_INHERIT
# @DESCRIPTION:
# The minimum version of Kotlin compiler required to build this library.
# Defaults to $(ver_cut 1-2), can be overriden from ebuild BEFORE inheriting
# this eclass.
: ${KOTLIN_LIBS_KOTLINC_MIN_VER:="${_KOTLIN_LIBS_FEATURE_RELEASE_FROM_PV}"}

# @ECLASS-VARIABLE: KOTLIN_LIBS_WANT_TARGET
# @DESCRIPTION:
# The argument to kotlinc's -api-version and -language-version options.
# Defaults to $(ver_cut 1-2), can be overriden from ebuild anywhere. It is the
# ebuild itself's responsibility to make sure the target version is supported
# by the Kotlin compiler version specified by KOTLIN_LIBS_KOTLINC_MIN_VER if
# that variable is overriden.
: ${KOTLIN_LIBS_WANT_TARGET:="${_KOTLIN_LIBS_FEATURE_RELEASE_FROM_PV}"}

# ebuild variables

# @ECLASS-VARIABLE: KOTLIN_LIBS_BINJAR_SRC_URI
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# The SRC_URI of the binary JAR file to be installed if the 'binary' USE flag
# is enabled. Default is unset, can be overriden from ebuild BEFORE inheriting
# this eclass. Once a value is set, this eclass will add 'binary' and 'test'
# USE flags to it and automatically set 'JAVA_TESTING_FRAMEWORKS+=" pkgdiff"'
# to use the binary JAR for testing.

# @ECLASS-VARIABLE: KOTLIN_LIBS_SRCJAR_SRC_URI
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# The SRC_URI of the source JAR file to be installed if the 'binary' and
# 'source' USE flags are both enabled. Default is unset, can be overriden from
# ebuild BEFORE inheriting this eclass. If KOTLIN_LIBS_BINJAR_SRC_URI is set
# but this variable is unset, this eclass will set
# 'REQUIRED_USE="binary? ( !source )"' for the ebuild.

# @ECLASS-VARIABLE: KOTLIN_LIBS_SRCJAR_FILENAME
# @DEFAULT_UNSET
# @DESCRIPTION:
# The name of the source JAR file to be installed if the 'binary' and 'source'
# USE flags are both enabled. Must be overriden from ebuild somewhere when
# KOTLIN_LIBS_BINJAR_SRC_URI is set.

JAVA_PKG_IUSE="source"
JAVA_TESTING_FRAMEWORKS=""
_KOTLIN_LIBS_REQUIRED_USE=""

if [[ -n "${KOTLIN_LIBS_BINJAR_SRC_URI}" ]]; then
	# The binary JAR can be used for pkgdiff tests when the package is built
	# from source; pkgdiff tests are unnecessary with USE="binary"
	JAVA_PKG_IUSE+=" binary test"
	JAVA_TESTING_FRAMEWORKS="pkgdiff"
	if [[ -z "${KOTLIN_LIBS_SRCJAR_SRC_URI}" ]]; then
		# No source JAR is available for the binary JAR, disable the USE flag
		_KOTLIN_LIBS_REQUIRED_USE="binary? ( !source !test )"
	else
		_KOTLIN_LIBS_REQUIRED_USE="binary? ( !test )"
	fi
fi

inherit java-pkg-2 java-pkg-simple

: ${DESCRIPTION:="Kotlin library component ${PN}"}
: ${HOMEPAGE:="https://kotlinlang.org"}
: ${LICENSE:="Apache-2.0 BSD MIT NPL-1.1"}
: ${SLOT:="$(ver_cut 1-2)"}

_KOTLIN_LIBS_DEFAULT_SRC_URI="
	https://github.com/JetBrains/kotlin/archive/refs/tags/v${PV}.tar.gz -> kotlin-${PV}.tar.gz
"
if has binary ${JAVA_PKG_IUSE}; then
	: ${SRC_URI:=""}
	SRC_URI+="
	!binary? (
		${_KOTLIN_LIBS_DEFAULT_SRC_URI}
		test? ( ${KOTLIN_LIBS_BINJAR_SRC_URI} )
	)
	binary? (
		${KOTLIN_LIBS_BINJAR_SRC_URI}
		source? ( ${KOTLIN_LIBS_SRCJAR_SRC_URI} )
	)
	"
else
	: ${SRC_URI:="${_KOTLIN_LIBS_DEFAULT_SRC_URI}"}
fi

REQUIRED_USE="
	${_KOTLIN_LIBS_REQUIRED_USE}
	${REQUIRED_USE}
"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

_KOTLIN_LIBS_KOTLINC_DEPEND="
	>=dev-lang/kotlin-bin-${KOTLIN_LIBS_KOTLINC_MIN_VER}:0
"
if has binary ${JAVA_PKG_IUSE}; then
	# Depend on the compiler only when building from source
	DEPEND+=" !binary? ( ${_KOTLIN_LIBS_KOTLINC_DEPEND} )"
else
	# No option to use pre-built binary; always depend on the compiler
	DEPEND+=" ${_KOTLIN_LIBS_KOTLINC_DEPEND}"
fi

# @FUNCTION: kotlin-libs_pkg_setup
# @DESCRIPTION:
# Sets up the environment according to settings like enabled USE flags that can
# only be checked within a function.
kotlin-libs_pkg_setup() {
	if ! has binary ${JAVA_PKG_IUSE} || ! use binary; then
		S="${WORKDIR}/kotlin-${PV}"
	fi
}

# @FUNCTION: kotlin-libs_kotlinc
# @USAGE: <kotlinc_arguments>
# @DESCRIPTION:
# Invokes the Kotlin compiler with arguments specified by the above internal
# variables, followed by <kotlinc_arguments>.
kotlin-libs_kotlinc() {
	debug-print-function ${FUNCNAME} "$@"

	local compiler_executable
	compiler_executable="kotlinc"

	# Prepare arguments whose values should be separated by comma
	local OLD_IFS="${IFS}"
	if [[ -n "${KOTLIN_LIBS_COMMON_SOURCES_DIR}" ]]; then
		local common_sources_files=(
			$(find "${KOTLIN_LIBS_COMMON_SOURCES_DIR[@]}" -name "*.kt")
		)
		IFS=','
		local common_sources="-Xcommon-sources=${common_sources_files[*]}"
	fi
	IFS=','
	local java_source_roots="${KOTLIN_LIBS_JAVA_SOURCE_ROOTS:+-Xjava-source-roots=${KOTLIN_LIBS_JAVA_SOURCE_ROOTS[*]}}"
	IFS="${OLD_IFS}"

	local compiler_command_args=(
		"${compiler_executable}"
		"${KOTLIN_LIBS_WANT_TARGET:+-api-version ${KOTLIN_LIBS_WANT_TARGET}}"
		"${KOTLIN_LIBS_WANT_TARGET:+-language-version ${KOTLIN_LIBS_WANT_TARGET}}"
		"${KOTLIN_LIBS_MODULE_NAME:+-module-name ${KOTLIN_LIBS_MODULE_NAME}}"
		"${common_sources}"
		"${java_source_roots}"
		"${KOTLIN_LIBS_KOTLINC_ARGS[@]}"
		"$@"
	)
	local compiler_command="${compiler_command_args[@]}"

	if [[ -n ${JAVA_PKG_DEBUG} ]]; then
		einfo "Verbose logging for \"${FUNCNAME}\" function"
		einfo "JAVA_OPTS: ${KOTLIN_LIBS_KOTLINC_JAVA_OPTS}"
		einfo "Compiler arguments:"
		einfo "${compiler_command}"
	fi

	ebegin "Compiling"
	JAVA_OPTS="${KOTLIN_LIBS_KOTLINC_JAVA_OPTS}" ${compiler_command} || \
		die "${FUNCNAME} failed"
}

# @FUNCTION: kotlin-libs_src_compile
# @DESCRIPTION:
# Compiles the source files in ${KOTLIN_LIBS_SRC_DIR} using compiler arguments
# specified by other variables of this eclass, with classpath calculated from
# ${JAVA_GENTOO_CLASSPATH}, and packages the resulting classes to a single JAR
# ${JAVA_JAR_FILENAME}. If the file target/META-INF/MANIFEST.MF exists, it will
# be used as the manifest of the created JAR. If the 'binary' USE flag is
# enabled, nothing will be compiled and the binary JAR ${JAVA_BINJAR_FILENAME}
# will be used directly.
kotlin-libs_src_compile() {
	local target="target"

	java-pkg_gen-cp JAVA_GENTOO_CLASSPATH

	if has binary ${JAVA_PKG_IUSE} && use binary; then
		for dependency in ${JAVA_GENTOO_CLASSPATH//,/ }; do
			java-pkg_record-jar_ "${dependency}"
		done

		cp "${DISTDIR}/${JAVA_BINJAR_FILENAME}" "${JAVA_JAR_FILENAME}" \
			|| die "Could not copy the binary JAR file to ${S}"
		return 0
	fi

	# Create the target directory
	mkdir -p "${target}" || die "Could not create target directory"

	# Compute classpath
	local classpath=""
	java-pkg-simple_getclasspath

	java-pkg-simple_prepend_resources "${target}" "${JAVA_RESOURCE_DIRS[@]}"

	# Compile Kotlin source files
	local kotlin_sources="kotlin_sources.lst"
	find "${KOTLIN_LIBS_SRC_DIR[@]}" -name "*.kt" > "${kotlin_sources}"
	kotlin-libs_kotlinc -d "${target}" ${classpath:+-classpath ${classpath}} \
		"@${kotlin_sources}"
	# Compile any Java source files after the Kotlin sources because for Kotlin
	# libraries, the Java sources require the Kotlin classes as dependencies
	if [[ -n "${KOTLIN_LIBS_JAVA_SRC_DIR[@]}" ]]; then
		local java_sources="java_sources.lst"
		local java_classpath="${classpath:+${classpath}:}${target}"
		find "${KOTLIN_LIBS_JAVA_SRC_DIR[@]}" -name "*.java" > "${java_sources}"
		ebegin "Compiling Java sources"
		$(java-pkg_get-javac) -d "${target}" -classpath ${java_classpath} \
			-source "${KOTLIN_LIBS_JAVA_WANT_SOURCE_TARGET}" \
			-target "${KOTLIN_LIBS_JAVA_WANT_SOURCE_TARGET}" \
			-encoding "${JAVA_ENCODING}" \
			"${KOTLIN_LIBS_JAVAC_ARGS[@]}" \
			"@${java_sources}" || die "Failed to compile Java sources"
	fi

	# Package compiled class files into a JAR
	local jar_args
	if [[ -e "${target}/META-INF/MANIFEST.MF" ]]; then
		jar_args="cfm ${JAVA_JAR_FILENAME} ${target}/META-INF/MANIFEST.MF"
	elif [[ -n "${JAVA_MAIN_CLASS}" ]]; then
		jar_args="cfe ${JAVA_JAR_FILENAME} ${JAVA_MAIN_CLASS}"
	else
		jar_args="cf ${JAVA_JAR_FILENAME}"
	fi
	jar ${jar_args} -C "${target}" . || die "jar failed"
}

# @FUNCTION: kotlin-libs_src_test
# @DESCRIPTION:
# If the package is being built from source but a binary JAR is still
# available, compares it with the JAR just built.
kotlin-libs_src_test() {
	if ! has test ${JAVA_PKG_IUSE}; then
		return
	elif ! use test; then
		return
	elif [[ -z "${JAVA_TESTING_FRAMEWORKS}" ]]; then
		return
	fi

	for framework in ${JAVA_TESTING_FRAMEWORKS}; do
		case ${framework} in
			pkgdiff)
				java-pkg-simple_test_with_pkgdiff_;;
		esac
	done
}

# @FUNCTION: kotlin-libs_dosrc
# @USAGE: <path/to/sources> [...]
# @DESCRIPTION:
# Installs a Zip archive containing the specified sources for a package.
kotlin-libs_dosrc() {
	debug-print-function ${FUNCNAME} "$@"

	java-pkg_check-phase install

	[[ "$#" -lt 1 ]] && die "At least one argument needed for ${FUNCNAME}"

	if [[ "${DEPEND}" != *app-arch/zip* ]]; then
		local msg="${FUNCNAME} called without app-arch/zip in DEPEND"
		java-pkg_announce-qa-violation "${msg}"
	fi

	java-pkg_init_paths_

	local zip_name="${PN}-src.zip"
	local zip_path="${T}/${zip_name}"
	local path
	for path in "$@"; do
		local dir_parent=$(dirname "${path}")
		local dir_name=$(basename "${path}")
		pushd "${dir_parent}" > /dev/null || \
			die "Failed to enter directory ${dir_parent}"
		zip -q -r "${zip_path}" "${dir_name}"
		local result=$?
		# 12 means zip has nothing to do
		if [[ "${result}" != 12 && "${result}" != 0 ]]; then
			die "Failed to add ${dir_name} to Zip archive"
		fi
		popd > /dev/null || die "Failed to exit directory ${dir_parent}"
	done

	insinto "${JAVA_PKG_SOURCESPATH}"
	doins "${zip_path}"

	if [[ -n "${JAVA_PKG_DEBUG}" ]]; then
		einfo "Verbose logging for \"${FUNCNAME}\" function"
		einfo "Zip filename created: ${zip_name}"
		einfo "Zip file destination: ${JAVA_PKG_SOURCESPATH}"
		einfo "Paths zipped: $@"
		einfo "Complete command:"
		einfo "${FUNCNAME} $@"
	fi

	JAVA_SOURCES="${JAVA_PKG_SOURCESPATH}/${zip_name}"
	java-pkg_do_write_
}

# @FUNCTION: kotlin-libs_src_install
# @DESCRIPTION:
# Installs the JAR specified by ${JAVA_JAR_FILENAME}, and a launcher as well if
# ${JAVA_MAIN_CLASS} is set. If the 'source' USE flag is enabled, a Zip archive
# containing the source will also be installed.
kotlin-libs_src_install() {
	local sources
	if [[ -s "java_sources.lst" ]]; then
		sources="sources.lst"
		cat kotlin_sources.lst java_sources.lst > "${sources}" || \
			die "Failed to create combined Kotlin and Java source list"
	else
		sources="kotlin_sources.lst"
	fi

	java-pkg_dojar "${JAVA_JAR_FILENAME}"

	if [[ -n "${JAVA_MAIN_CLASS}" ]]; then
		java-pkg_dolauncher "${JAVA_LAUNCHER_FILENAME}" \
			--main "${JAVA_MAIN_CLASS}"
	fi

	if has source ${JAVA_PKG_IUSE} && use source; then
		if has binary ${JAVA_PKG_IUSE} && use binary; then
			# Install pre-built source JAR for binary installation
			insinto "${JAVA_PKG_SOURCESPATH}"
			doins "${KOTLIN_LIBS_SRCJAR_FILENAME}"
		else
			local srcdirs=""
			local kt_java_src_dir=(
				"${KOTLIN_LIBS_SRC_DIR[@]}"
				"${KOTLIN_LIBS_JAVA_SRC_DIR[@]}"
			)
			if [[ -n "${kt_java_src_dir[@]}" ]]; then
				local parent child
				for parent in "${kt_java_src_dir[@]}"; do
					srcdirs="${srcdirs} ${parent}"
				done
			else
				# Take all directories actually containing any sources
				srcdirs="$(cut -d/ -f1 ${sources} | sort -u)"
			fi
			kotlin-libs_dosrc ${srcdirs}
		fi
	fi
}