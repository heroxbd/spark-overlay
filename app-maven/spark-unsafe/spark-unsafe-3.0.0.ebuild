# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/spark-unsafe_2.12-3.0.0-preview2.pom --download-uri https://repo1.maven.org/maven2/org/apache/spark/spark-unsafe_2.12/3.0.0-preview2/spark-unsafe_2.12-3.0.0-preview2-sources.jar --slot 2.12 --keywords "~amd64" --ebuild spark-unsafe-3.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The Apache Software Foundation provides support for the Apache community of open-source software projects.
    The Apache projects are characterized by a collaborative, consensus based development process, an open and
    pragmatic software license, and a desire to create high quality software that leads the way in its field.
    We consider ourselves not simply a group of projects sharing a server, but rather a community of developers
    and users."
HOMEPAGE="http://spark.apache.org/"
SRC_URI="https://repo1.maven.org/maven2/org/apache/spark/${PN}_2.12/${PV}-preview2/${PN}_2.12-${PV}-preview2-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/apache/spark/${PN}_2.12/${PV}-preview2/${PN}_2.12-${PV}-preview2.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="2.12"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.spark:spark-unsafe_2.12:3.0.0-preview2"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${PN}_2.12-${PV}-preview2.pom
# com.google.code.findbugs:jsr305:3.0.0 -> >=dev-java/jsr305-3.0.1:0
# com.twitter:chill_2.12:0.9.3 -> >=app-maven/chill-0.9.3:2.12
# org.apache.spark:spark-tags_2.12:3.0.0-preview2 -> >=app-maven/spark-tags-3.0.0:2.12
# org.spark-project.spark:unused:1.0.0 -> >=app-maven/unused-1.0.0:0

CDEPEND="
	>=app-maven/chill-0.9.3:2.12
	>=app-maven/spark-tags-3.0.0:2.12
	>=app-maven/unused-1.0.0:0
	>=dev-java/jsr305-3.0.1:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${PN}_2.12-${PV}-preview2.pom
# com.google.guava:guava:14.0.1 -> >=dev-java/guava-29.0:0
# org.slf4j:slf4j-api:1.7.16 -> >=dev-java/slf4j-api-1.7.28:0

DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	>=dev-java/guava-29.0:0
	>=dev-java/slf4j-api-1.7.28:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="jsr305,chill-2.12,spark-tags-2.12,unused"
JAVA_CLASSPATH_EXTRA="guava,slf4j-api"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}