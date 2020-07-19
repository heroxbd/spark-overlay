# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jboss-interceptors-api_1.1_spec-1.0.0.Beta1.pom --download-uri https://repo1.maven.org/maven2/org/jboss/spec/javax/interceptor/jboss-interceptors-api_1.1_spec/1.0.0.Beta1/jboss-interceptors-api_1.1_spec-1.0.0.Beta1-sources.jar --slot 1.1_spec --keywords "~amd64" --ebuild jboss-interceptors-api-1.0.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The JavaEE Interceptors 1.1 API classes from JSR 318."
HOMEPAGE="http://jboss-interceptors-api_1.1_spec/"
SRC_URI="https://repo1.maven.org/maven2/org/jboss/spec/javax/interceptor/${PN}_1.1_spec/${PV}.Beta1/${PN}_1.1_spec-${PV}.Beta1-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/jboss/spec/javax/interceptor/${PN}_1.1_spec/${PV}.Beta1/${PN}_1.1_spec-${PV}.Beta1.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="1.1_spec"
KEYWORDS="~amd64"
MAVEN_ID="org.jboss.spec.javax.interceptor:jboss-interceptors-api_1.1_spec:1.0.0.Beta1"



DEPEND="
	>=virtual/jdk-1.5:*
	app-arch/unzip
"

RDEPEND="
	>=virtual/jre-1.5:*
"

S="${WORKDIR}"

JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}