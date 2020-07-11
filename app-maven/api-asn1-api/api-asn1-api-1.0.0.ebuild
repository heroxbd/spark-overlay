# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/api-asn1-api-1.0.0-M20.pom --download-uri https://repo1.maven.org/maven2/org/apache/directory/api/api-asn1-api/1.0.0-M20/api-asn1-api-1.0.0-M20-sources.jar --slot 0 --keywords "~amd64" --ebuild api-asn1-api-1.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="ASN.1 API"
HOMEPAGE="http://directory.apache.org/api-parent/api-asn1-parent/api-asn1-api/"
SRC_URI="https://repo1.maven.org/maven2/org/apache/directory/api/${PN}/${PV}-M20/${P}-M20-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/apache/directory/api/${PN}/${PV}-M20/${P}-M20.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.directory.api:api-asn1-api:1.0.0-M20"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}-M20.pom
# org.apache.directory.api:api-i18n:1.0.0-M20 -> >=app-maven/api-i18n-1.0.0:0
# org.slf4j:slf4j-api:1.7.5 -> >=dev-java/slf4j-api-1.7.7:0

CDEPEND="
	>=app-maven/api-i18n-1.0.0:0
	>=dev-java/slf4j-api-1.7.7:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}-M20.pom
# findbugs:annotations:1.0.0 -> >=dev-java/findbugs-annotations-3.0.12:3

DEPEND="
	>=virtual/jdk-1.6:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	>=dev-java/findbugs-annotations-3.0.12:3
	)
"

RDEPEND="
	>=virtual/jre-1.6:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="api-i18n,slf4j-api"
JAVA_CLASSPATH_EXTRA="findbugs-annotations-3"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}
