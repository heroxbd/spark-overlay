# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/hazelcast-code-generator-1.6.0.pom --download-uri https://repo1.maven.org/maven2/com/hazelcast/hazelcast-code-generator/1.6.0/hazelcast-code-generator-1.6.0-sources.jar --slot 0 --keywords "~amd64" --ebuild hazelcast-code-generator-1.6.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Client Protocol of Hazelcast In-Memory DataGrid"
HOMEPAGE="http://www.hazelcast.com/hazelcast-code-generator/"
SRC_URI="https://repo1.maven.org/maven2/com/hazelcast/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/com/hazelcast/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="com.hazelcast:hazelcast-code-generator:1.6.0"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.freemarker:freemarker:2.3.23 -> >=app-maven/freemarker-2.3.23:0

CDEPEND="
	>=app-maven/freemarker-2.3.23:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.google.code.findbugs:annotations:3.0.0 -> >=dev-java/findbugs-annotations-3.0.12:3
# javax.cache:cache-api:1.0.0 -> >=app-maven/cache-api-1.0.0:0

DEPEND="
	>=virtual/jdk-1.6:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	>=app-maven/cache-api-1.0.0:0
	>=dev-java/findbugs-annotations-3.0.12:3
	)
"

RDEPEND="
	>=virtual/jre-1.6:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="freemarker"
JAVA_CLASSPATH_EXTRA="findbugs-annotations-3,cache-api"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}
