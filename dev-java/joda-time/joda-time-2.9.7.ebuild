# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/joda-time-2.9.7.pom --download-uri https://repo.maven.apache.org/maven2/joda-time/joda-time/2.9.7/joda-time-2.9.7-sources.jar --slot 0 --keywords "~amd64" --ebuild joda-time-2.9.7.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Date and time library to replace JDK date handling"
HOMEPAGE="http://www.joda.org/joda-time/"
SRC_URI="https://repo.maven.apache.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="joda-time:joda-time:2.9.7"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.joda:joda-convert:1.2 -> >=dev-java/joda-convert-1.3.1:0

CDEPEND="
	>=dev-java/joda-convert-1.3.1:0
"


DEPEND="
	>=virtual/jdk-1.5:*
	${CDEPEND}
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.5:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="joda-convert"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
}