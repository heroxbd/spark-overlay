# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/svm-19.2.1.pom --download-uri https://repo.maven.apache.org/maven2/com/oracle/substratevm/svm/19.2.1/svm-19.2.1-sources.jar --slot 0 --keywords "~amd64" --ebuild svm-19.2.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SubstrateVM image builder components"
HOMEPAGE="https://github.com/oracle/graal/tree/master/substratevm"
SRC_URI="https://repo.maven.apache.org/maven2/com/oracle/substratevm/${PN}/${PV}/${P}-sources.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="com.oracle.substratevm:svm:19.2.1"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.oracle.substratevm:objectfile:19.2.1 -> !!!artifactId-not-found!!!
# com.oracle.substratevm:pointsto:19.2.1 -> !!!artifactId-not-found!!!
# org.graalvm.sdk:graal-sdk:19.2.1 -> !!!artifactId-not-found!!!
# org.graalvm.compiler:compiler:19.2.1 -> >=dev-java/graalvm-compiler-19.2.1
# org.graalvm.truffle:truffle-nfi:19.2.1 -> dev-java/truffle-nfi:19

CDEPEND="
	>=app-maven/objectfile-19.2.1
	>=app-maven/pointsto-19.2.1
	>=app-maven/graal-sdk-19.2.1
	>=dev-java/graalvm-compiler-19.2.1
	dev-libs/libsvm
	dev-java/truffle-nfi
"


DEPEND="
	>=virtual/jdk-1.8:*
	${CDEPEND}
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="truffle-nfi,objectfile,pointsto,graal-sdk,graalvm-compiler"