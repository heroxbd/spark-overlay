# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/yecht-1.0.pom --download-uri https://repo1.maven.org/maven2/org/jruby/yecht/1.0/yecht-1.0-sources.jar --slot 0 --keywords "~amd64" --ebuild yecht-1.0.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Sonatype helps open source projects to set up Maven repositories on https://oss.sonatype.org/"
HOMEPAGE="https://github.com/jruby/yecht"
SRC_URI="https://repo1.maven.org/maven2/org/jruby/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/jruby/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.jruby:yecht:1.0"


# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# org.jruby:jruby-core:[1.7.0,1.8.0) -> >=app-maven/jruby-core-1.7.22:0

DEPEND="
	>=virtual/jdk-1.8:*
	app-arch/unzip
	!binary? (
	>=app-maven/jruby-core-1.7.22:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="jruby-core"
JAVA_SRC_DIR="src/main/java"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}