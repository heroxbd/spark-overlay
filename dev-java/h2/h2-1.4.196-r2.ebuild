# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test binary"
MAVEN_ID="com.h2database:h2:1.4.196"
JAVA_TESTING_FRAMEWORKS="pkgdiff"

inherit java-pkg-2 java-pkg-simple java-pkg-maven

DESCRIPTION="H2 Database Engine"
HOMEPAGE="https://www.h2database.com"
SRC_URI="
	https://repo1.maven.org/maven2/com/${PN}database/${PN}/${PV}/${P}-sources.jar
	https://repo1.maven.org/maven2/com/${PN}database/${PN}/${PV}/${P}.jar -> ${P}-bin.jar
"
LICENSE="|| ( MPL-1.1 EPL-1.0 )"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	dev-java/lucene:3.6
	dev-java/slf4j-api:0
	dev-java/jts-core:0
	dev-java/osgi-core:4
	dev-java/osgi-service-jdbc:0
	java-virtuals/servlet-api:4.0
"

BDEPEND="
	app-arch/unzip
"

DEPEND="
	>=virtual/jdk-1.8:*
	!binary? (
		${CP_DEPEND}
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}"

JAVA_SRC_DIR="src/main/java"
JAVA_BINJAR_FILENAME="${P}-bin.jar"