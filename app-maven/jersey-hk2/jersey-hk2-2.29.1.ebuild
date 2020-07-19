# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jersey-hk2-2.29.1.pom --download-uri https://repo1.maven.org/maven2/org/glassfish/jersey/inject/jersey-hk2/2.29.1/jersey-hk2-2.29.1-sources.jar --slot 0 --keywords "~amd64" --ebuild jersey-hk2-2.29.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="HK2 InjectionManager implementation"
HOMEPAGE="https://projects.eclipse.org/projects/ee4j.jersey/project/jersey-hk2"
SRC_URI="https://repo1.maven.org/maven2/org/glassfish/jersey/inject/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/glassfish/jersey/inject/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.glassfish.jersey.inject:jersey-hk2:2.29.1"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.glassfish.hk2:hk2-locator:2.6.1 -> >=app-maven/hk2-locator-2.6.1:0
# org.glassfish.jersey.core:jersey-common:2.29.1 -> >=app-maven/jersey-common-2.29.1:0

CDEPEND="
	>=app-maven/hk2-locator-2.6.1:0
	>=app-maven/jersey-common-2.29.1:0
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

JAVA_GENTOO_CLASSPATH="hk2-locator,jersey-common"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}