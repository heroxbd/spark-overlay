# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jakarta.validation-api-2.0.2.pom --download-uri https://repo1.maven.org/maven2/jakarta/validation/jakarta.validation-api/2.0.2/jakarta.validation-api-2.0.2-sources.jar --slot 0 --keywords "~amd64" --ebuild jakarta-validation-api-2.0.2.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Jakarta Bean Validation API"
HOMEPAGE="https://beanvalidation.org"
SRC_URI="https://repo1.maven.org/maven2/jakarta/validation/jakarta.validation-api/${PV}/jakarta.validation-api-${PV}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/jakarta/validation/jakarta.validation-api/${PV}/jakarta.validation-api-${PV}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="jakarta.validation:jakarta.validation-api:2.0.2"



DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}"

JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}