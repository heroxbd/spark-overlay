# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/ant-launcher-1.8.4.pom --download-uri https://repo1.maven.org/maven2/org/apache/ant/ant-launcher/1.8.4/ant-launcher-1.8.4-sources.jar --slot 0 --keywords "~amd64" --ebuild ant-launcher-1.8.4-r1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source test binary"

inherit java-pkg-2 java-pkg-simple java-pkg-maven

DESCRIPTION="master POM"
HOMEPAGE="http://ant.apache.org/ant-launcher/"
SRC_URI="https://repo1.maven.org/maven2/org/apache/ant/${PN}/${PV}/${P}-sources.jar -> ${P}-sources.jar
	https://repo1.maven.org/maven2/org/apache/ant/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.ant:ant-launcher:1.8.4"



DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}"

JAVA_SRC_DIR="src/main"
JAVA_BINJAR_FILENAME="${P}-bin.jar"

