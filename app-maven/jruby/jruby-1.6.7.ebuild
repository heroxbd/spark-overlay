# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Skeleton command:
# java-ebuilder --generate-ebuild --workdir . --pom /var/lib/java-ebuilder/poms/jruby-1.6.7.pom --download-uri https://repo1.maven.org/maven2/org/jruby/jruby/1.6.7/jruby-1.6.7-sources.jar --slot 0 --keywords "~amd64" --ebuild jruby-1.6.7.ebuild

EAPI=7

JAVA_PKG_IUSE="doc source binary"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A 1.8.7 compatible Ruby interpreter written in 100% pure Java"
HOMEPAGE="http://www.jruby.org/jruby-common/jruby/"
SRC_URI="https://repo1.maven.org/maven2/org/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar
	https://repo1.maven.org/maven2/org/${PN}/${PN}/${PV}/${P}.jar -> ${P}-bin.jar"
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
MAVEN_ID="org.jruby:jruby:1.6.7"


# Compile dependencies
# POM: /var/lib/java-ebuilder/poms/${P}.pom
# asm:asm:3.3.1 -> >=dev-java/asm-8.0.1:4
# asm:asm-analysis:3.3.1 -> >=dev-java/asm-8.0.1:4
# asm:asm-commons:3.3.1 -> >=dev-java/asm-8.0.1:4
# asm:asm-tree:3.3.1 -> >=dev-java/asm-8.0.1:4
# asm:asm-util:3.3.1 -> >=dev-java/asm-8.0.1:4
# bsf:bsf:2.3.0 -> >=dev-java/bsf-2.4.0:2.3
# jline:jline:1.0 -> >=dev-java/jline-2.12.1:2
# joda-time:joda-time:1.6 -> >=dev-java/joda-time-2.7:0
# org.apache.ant:ant:1.7.0 -> >=dev-java/ant-core-1.10.7:0
# org.jruby.ext.posix:jnr-posix:1.1.9 -> >=app-maven/jnr-posix-1.1.9:0
# org.jruby.extras:bytelist:1.0.10 -> >=dev-java/bytelist-1.0.10:0
# org.jruby.extras:constantine:0.6 -> >=dev-java/constantine-0.7:0
# org.jruby.extras:jaffl:0.5.11 -> >=app-maven/jaffl-0.5.11:0
# org.jruby.extras:jffi:1.0.8 -> >=app-maven/jffi-1.0.8:0
# org.jruby.extras:jnr-netdb:1.0.3 -> >=app-maven/jnr-netdb-1.0.3:0
# org.jruby.jcodings:jcodings:1.0.7 -> >=dev-java/jcodings-1.0.11:1
# org.jruby.joni:joni:1.1.7 -> >=dev-java/joni-2.1.0:2.1
# org.yaml:snakeyaml:1.9 -> >=dev-java/snakeyaml-1.16:0

DEPEND="
	>=virtual/jdk-1.5:*
	app-arch/unzip
	!binary? (
	>=app-maven/jaffl-0.5.11:0
	>=app-maven/jffi-1.0.8:0
	>=app-maven/jnr-netdb-1.0.3:0
	>=dev-java/jnr-posix-1.1.9:0
	>=dev-java/ant-core-1.10.7:0
	>=dev-java/asm-8.0.1:4
	>=dev-java/bsf-2.4.0:2.3
	>=dev-java/bytelist-1.0.10:0
	>=dev-java/constantine-0.7:0
	>=dev-java/jcodings-1.0.11:1
	>=dev-java/jline-2.12.1:2
	>=dev-java/joda-time-2.7:0
	>=dev-java/joni-2.1.0:2.1
	>=dev-java/snakeyaml-1.16:0
	)
"

RDEPEND="
	>=virtual/jre-1.5:*
"

S="${WORKDIR}"

JAVA_CLASSPATH_EXTRA="asm-4,asm-4,asm-4,asm-4,asm-4,bsf-2.3,jline-2,joda-time,ant-core,jnr-posix,bytelist,constantine,jaffl,jffi,jnr-netdb,jcodings-1,joni-2.1,snakeyaml"
JAVA_SRC_DIR="../../src"

src_unpack() {
	mkdir -p ${S}/${JAVA_SRC_DIR}
	unzip ${DISTDIR}/${P}.jar -d ${S}/${JAVA_SRC_DIR} || die
	use binary && ( cp ${DISTDIR}/${P}-bin.jar ${S}/${PN}.jar || die "failed to copy binary jar" )
}
