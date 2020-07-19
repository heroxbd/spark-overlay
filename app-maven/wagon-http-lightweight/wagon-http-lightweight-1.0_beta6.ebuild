# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/wagon-http-lightweight-1.0-beta-6.pom --download-uri https://repo1.maven.org/maven2/org/apache/maven/wagon/wagon-http-lightweight/1.0-beta-6/wagon-http-lightweight-1.0-beta-6-sources.jar --slot 0 --keywords "~amd64" --ebuild wagon-http-lightweight-1.0_beta6.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Wagon that gets and puts artifacts through http using standard Java library"
HOMEPAGE="http://maven.apache.org/wagon/wagon-providers/wagon-http-lightweight"
SRC_URI="https://repo1.maven.org/maven2/org/apache/maven/wagon/${PN}/1.0-beta-6/${PN}-1.0-beta-6-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/apache/maven/wagon/${PN}/1.0-beta-6/${PN}-1.0-beta-6.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.apache.maven.wagon:wagon-http-lightweight:1.0-beta-6"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${PN}-1.0-beta-6.pom
# org.apache.maven.wagon:wagon-http-shared:1.0-beta-6 -> >=app-maven/wagon-http-shared-1.0_beta6:0
# org.apache.maven.wagon:wagon-provider-api:1.0-beta-6 -> >=app-maven/wagon-provider-api-1.0_beta6:0

CDEPEND="
	>=app-maven/wagon-http-shared-1.0_beta6:0
	>=app-maven/wagon-provider-api-1.0_beta6:0
"


DEPEND="
	>=virtual/jdk-1.4:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	)
"

RDEPEND="
	>=virtual/jre-1.4:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="wagon-http-shared,wagon-provider-api"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}