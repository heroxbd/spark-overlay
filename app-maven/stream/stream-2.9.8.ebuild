# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/stream-2.9.8.pom --download-uri https://repo1.maven.org/maven2/com/clearspring/analytics/stream/2.9.8/stream-2.9.8-sources.jar --slot 0 --keywords "~amd64" --ebuild stream-2.9.8.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A library for summarizing data in streams for which it is infeasible to store all events"
HOMEPAGE="https://github.com/addthis/stream-lib"
SRC_URI="https://repo1.maven.org/maven2/com/clearspring/analytics/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/com/clearspring/analytics/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="com.clearspring.analytics:stream:2.9.8"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# colt:colt:1.2.0 -> >=dev-java/colt-1.2.0:0
# com.google.guava:guava:23.3-jre -> >=dev-java/guava-29.0:0
# com.googlecode.charts4j:charts4j:1.3 -> >=app-maven/charts4j-1.3:0
# commons-codec:commons-codec:1.11 -> >=dev-java/commons-codec-1.11:0
# it.unimi.dsi:fastutil:8.1.1 -> >=dev-java/fastutil-8.1.1:0
# org.apache.mahout:mahout-math:0.13.0 -> >=app-maven/mahout-math-0.13.0:0
# org.slf4j:slf4j-api:1.7.10 -> >=dev-java/slf4j-api-1.7.28:0

CDEPEND="
	>=app-maven/charts4j-1.3:0
	>=app-maven/mahout-math-0.13.0:0
	>=dev-java/colt-1.2.0:0
	>=dev-java/commons-codec-1.11:0
	>=dev-java/fastutil-8.1.1:0
	>=dev-java/guava-29.0:0
	>=dev-java/slf4j-api-1.7.28:0
"


DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="colt,guava,charts4j,commons-codec,fastutil,mahout-math,slf4j-api"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}