# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: kotlin-compiler.eclass
# @MAINTAINER:
# Yuan Liao <liaoyuan@gmail.com>
# @AUTHOR:
# Yuan Liao <liaoyuan@gmail.com>
# @SUPPORTED_EAPIS: 6 7 8
# @BLURB: An eclass for Kotlin compiler packages
# @DESCRIPTION:
# This eclass should be inherited by every Kotlin compiler package that is
# intended to be recognized by app-eselect/eselect-kotlin, the Kotlin eselect
# module.

case "${EAPI:-0}" in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS pkg_postinst pkg_postrm

# Allow use of EAPI 7 version manipulators in older EAPIs for both this eclass
# and consumer ebuilds
[[ "${EAPI:-0}" -eq 6 ]] && inherit eapi7-ver

# @ECLASS-VARIABLE: KOTLIN_COMPILER_HOME
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# The installation target path for the Kotlin compiler. Default is unset, must
# be overridden from ebuild before the kotlin-compiler_install_pkg_desc
# function is called.

# @ECLASS-VARIABLE: KOTLIN_COMPILER_VER
# @DESCRIPTION:
# The Kotlin feature release version (e.g. 1.4, 1.5) this Kotlin compiler is
# for. Defaults to ${SLOT}, can be overridden from ebuild before the
# kotlin-compiler_install_pkg_desc function is called.
: ${KOTLIN_COMPILER_VER:="${SLOT}"}

RDEPEND="
	app-eselect/eselect-kotlin
"

# @FUNCTION: kotlin-compiler_install_pkg_desc
# @DESCRIPTION:
# Installs the Kotlin compiler package description file for this package to the
# path for all description files defined by the Kotlin eselect module. Must be
# called by the ebuild during the src_install phase if the Kotlin compiler
# installed by this package is to be registered in the Kotlin eselect module.
# Note that this function calls 'insinto'.
kotlin-compiler_install_pkg_desc() {
	# If KOTLIN_COMPILER_HOME is not set, symbolic links to ${EPREFIX}/ will
	# be created by the Kotlin eselect module. This not only breaks normal
	# functionalities but also introduces risks of removing the entire system
	# in the same way as the infamous 'rm -rf /'. Therefore, fail fast here to
	# prevent more serious issues.
	if [[ -z "${KOTLIN_COMPILER_HOME}" ]]; then
		eerror "The ebuild for this package inherits kotlin-compiler.eclass"
		eerror "without setting the required KOTLIN_COMPILER_HOME variable."
		eerror "Please inform the package's maintainers of this error. Thanks!"
		eerror
		die "KOTLIN_COMPILER_HOME is not set in the ebuild"
	fi

	# The package description file's name should be the last component of the
	# path defined by KOTLIN_COMPILER_HOME
	local pkg_desc="${KOTLIN_COMPILER_HOME##*/}"
	insinto "/usr/share/eselect-kotlin/pkgs/${KOTLIN_COMPILER_VER}"
	newins - "${pkg_desc}" <<- _EOF_
		GENTOO_KOTLIN_HOME="${EPREFIX}/${KOTLIN_COMPILER_HOME}"
		_EOF_
}

# @FUNCTION: kotlin-compiler_pkg_postinst
# @DESCRIPTION:
# Performs tasks that need to be done after a new Kotlin compiler is installed.
kotlin-compiler_pkg_postinst() {
	eselect kotlin update
}

# @FUNCTION: kotlin-compiler_pkg_postrm
# @DESCRIPTION:
# Performs tasks that need to be done after a Kotlin compiler is removed.
kotlin-compiler_pkg_postrm() {
	eselect kotlin cleanup
	eselect kotlin update
}
