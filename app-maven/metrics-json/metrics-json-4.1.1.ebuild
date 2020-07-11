# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/metrics-json-4.1.1.pom --download-uri https://repo1.maven.org/maven2/io/dropwizard/metrics/metrics-json/4.1.1/metrics-json-4.1.1-sources.jar --slot 0 --keywords "~amd64" --ebuild metrics-json-4.1.1.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A set of Jackson modules which provide serializers for most Metrics classes."
HOMEPAGE="http://metrics.dropwizard.io/metrics-json"
SRC_URI="https://repo1.maven.org/maven2/io/dropwizard/metrics/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/io/dropwizard/metrics/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="io.dropwizard.metrics:metrics-json:4.1.1"

# Common dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# com.fasterxml.jackson.core:jackson-databind:2.9.9.3 -> >=app-maven/jackson-databind-2.10.0:0
# io.dropwizard.metrics:metrics-core:4.1.1 -> >=app-maven/metrics-core-4.1.1:0
# io.dropwizard.metrics:metrics-healthchecks:4.1.1 -> >=app-maven/metrics-healthchecks-4.1.1:0
# org.slf4j:slf4j-api:1.7.28 -> >=dev-java/slf4j-api-1.7.28:0

CDEPEND="
	>=app-maven/jackson-databind-2.10.0:0
	>=app-maven/metrics-core-4.1.1:0
	>=app-maven/metrics-healthchecks-4.1.1:0
	>=dev-java/slf4j-api-1.7.28:0
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

JAVA_GENTOO_CLASSPATH="jackson-databind,metrics-core,metrics-healthchecks,slf4j-api"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}
