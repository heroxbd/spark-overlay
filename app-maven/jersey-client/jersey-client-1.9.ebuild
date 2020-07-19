# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jersey-client-1.9.pom --download-uri https://repo1.maven.org/maven2/com/sun/jersey/jersey-client/1.9/jersey-client-1.9-sources.jar --slot 0 --keywords "~amd64" --ebuild jersey-client-1.9.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jersey is the open source (under dual CDDL+GPL license) JAX-RS (JSR 311)
        production quality Reference Implementation for building
        RESTful Web services."
HOMEPAGE="https://jersey.java.net/jersey-client/"
SRC_URI="https://repo1.maven.org/maven2/com/sun/jersey/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/com/sun/jersey/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="com.sun.jersey:jersey-client:1.9"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.sun.jersey:jersey-core:1.9 -> >=app-maven/jersey-core-1.9:0

CDEPEND="
	>=app-maven/jersey-core-1.9:0
"

# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.osgi:osgi_R4_core:1.0 -> >=dev-java/osgi-core-4.0:4

DEPEND="
	>=virtual/jdk-1.6:*
	app-arch/unzip
	!binary? (
	${CDEPEND}
	>=dev-java/osgi-core-4.0:4
	)
"

RDEPEND="
	>=virtual/jre-1.6:*
${CDEPEND}"

S="${WORKDIR}"

JAVA_GENTOO_CLASSPATH="jersey-core"
JAVA_CLASSPATH_EXTRA="osgi-core-4"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}