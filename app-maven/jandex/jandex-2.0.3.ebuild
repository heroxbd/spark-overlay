# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jandex-2.0.3.Final.pom --download-uri https://repo1.maven.org/maven2/org/jboss/jandex/2.0.3.Final/jandex-2.0.3.Final-sources.jar --slot 0 --keywords "~amd64" --ebuild jandex-2.0.3.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Parent POM for JBoss projects. Provides default project build configuration."
HOMEPAGE="http://www.jboss.org/jandex"
SRC_URI="https://repo1.maven.org/maven2/org/jboss/${PN}/${PV}.Final/${P}.Final-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/jboss/${PN}/${PV}.Final/${P}.Final.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.jboss:jandex:2.0.3.Final"


# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.Final.pom
# org.apache.ant:ant:1.8.1 -> >=dev-java/ant-core-1.10.7:0

DEPEND="
	>=virtual/jdk-1.6:*
	app-arch/unzip
	!binary? (
	>=dev-java/ant-core-1.10.7:0
	)
"

RDEPEND="
	>=virtual/jre-1.6:*
"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="ant-core"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}
