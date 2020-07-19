# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/zookeeper-3.4.6.pom --download-uri https://repo1.maven.org/maven2/org/apache/zookeeper/zookeeper/3.4.6/zookeeper-3.4.6-sources.jar --slot 0 --keywords "~amd64" --ebuild zookeeper-3.4.6.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://repo1.maven.org/maven2/org/apache/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/apache/${PN}/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.zookeeper:zookeeper:3.4.6"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# commons-collections:commons-collections:3.1 -> >=dev-java/commons-collections-3.2.1:0
# commons-lang:commons-lang:2.4 -> >=dev-java/commons-lang-2.6:2.1
# io.netty:netty:3.7.0.Final -> >=app-maven/netty-3.7.0:0
# jdiff:jdiff:1.0.9 -> >=app-maven/jdiff-1.0.9:0
# jline:jline:0.9.94 -> >=dev-java/jline-2.12.1:2
# log4j:log4j:1.2.16 -> >=dev-java/log4j-1.2.17:0
# org.apache.maven:maven-ant-tasks:2.1.3 -> >=app-maven/maven-ant-tasks-2.1.3:0
# org.apache.maven.wagon:wagon-http:2.4 -> >=app-maven/wagon-http-2.4:0
# org.apache.rat:apache-rat-tasks:0.6 -> >=app-maven/apache-rat-tasks-0.6:0
# org.slf4j:slf4j-api:1.6.1 -> >=dev-java/slf4j-api-1.7.7:0
# org.slf4j:slf4j-log4j12:1.6.1 -> >=dev-java/slf4j-log4j12-1.7.7:0
# org.vafer:jdeb:0.8 -> >=app-maven/jdeb-0.8:0
# xerces:xerces:1.4.4 -> >=dev-java/xerces-2.12.0:2

CDEPEND="
	>=app-maven/apache-rat-tasks-0.6:0
	>=app-maven/jdeb-0.8:0
	>=app-maven/jdiff-1.0.9:0
	>=app-maven/maven-ant-tasks-2.1.3:0
	>=app-maven/netty-3.7.0:0
	>=app-maven/wagon-http-2.4:0
	>=dev-java/commons-collections-3.2.1:0
	>=dev-java/commons-lang-2.6:2.1
	>=dev-java/jline-2.12.1:2
	>=dev-java/log4j-1.2.17:0
	>=dev-java/slf4j-api-1.7.7:0
	>=dev-java/slf4j-log4j12-1.7.7:0
	>=dev-java/xerces-2.12.0:2
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

JAVA_GENTOO_CLASSPATH="commons-collections,commons-lang-2.1,netty,jdiff,jline-2,log4j,maven-ant-tasks,wagon-http,apache-rat-tasks,slf4j-api,slf4j-log4j12,jdeb,xerces-2"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}