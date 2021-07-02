# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MAVEN_ID="org.jetbrains.kotlin:${PN}:${PV}"

KOTLIN_LIBS_BINJAR_SRC_URI="https://repo1.maven.org/maven2/org/jetbrains/kotlin/${PN}/${PV}/${P}.jar"
KOTLIN_LIBS_SRCJAR_SRC_URI="https://repo1.maven.org/maven2/org/jetbrains/kotlin/${PN}/${PV}/${P}-sources.jar"

inherit kotlin-libs

KEYWORDS="~amd64"

DEPEND="!binary? (
	>=dev-lang/kotlin-bin-1.5.10-r1:0[javascript]
)"

JAVA_BINJAR_FILENAME="${P}.jar"

# No -module-name option for Kotlin/JS compiler
KOTLIN_LIBS_MODULE_NAME=""
KOTLIN_LIBS_RUNTIME_COMPONENT="Main"

src_compile() {
	if has binary ${JAVA_PKG_IUSE} && use binary; then
		kotlin-libs_src_compile
		return 0
	fi

	export KOTLIN_COMPILER=org.jetbrains.kotlin.cli.js.K2JSCompiler
	local target="target"

	# Maintain a list of used sources for source Zip archive generation,
	# although the list of source files actually collected into the archive
	# seems inaccurate
	local sources="kotlin_sources.lst"
	local src_files

	# :kotlin-stdlib-js:compileBuiltinsKotlin2Js
	local builtins_target="${target}/classes/builtins"
	KOTLIN_LIBS_KOTLINC_ARGS=(
		-main noCall
		-module-kind commonjs
		-no-stdlib
		-source-map
		-source-map-base-dirs libraries/stdlib/js-v1
		-source-map-prefix ./
		-target v5
		-Xallow-kotlin-package
		-Xallow-result-return-type
		-Xmulti-platform
	)
	src_files=(
		core/builtins/native/kotlin/Comparable.kt
		libraries/stdlib/js/runtime/primitiveCompanionObjects.kt
		$(find libraries/stdlib/js-v1/runtime -name "*.kt")
	)
	tr ' ' '\n' <<< "${src_files[@]}" >> "${sources}" || \
		die "Failed to append to list of source files"
	kotlin-libs_kotlinc -output "${builtins_target}/kotlin.js" "${src_files[@]}"

	# :kotlin-stdlib-js:prepareBuiltinsSources
	local builtin_sources_dir="${target}/builtin-sources"
	mkdir -p "${builtin_sources_dir}" || \
		die "Could not create built-in sources directory"
	cp \
		core/builtins/native/kotlin/Annotation.kt \
		core/builtins/native/kotlin/CharSequence.kt \
		core/builtins/native/kotlin/Collections.kt \
		core/builtins/native/kotlin/Iterator.kt \
		core/builtins/src/kotlin/Function.kt \
		core/builtins/src/kotlin/Iterators.kt \
		core/builtins/src/kotlin/Progressions.kt \
		core/builtins/src/kotlin/ProgressionIterators.kt \
		core/builtins/src/kotlin/Range.kt \
		core/builtins/src/kotlin/Ranges.kt \
		core/builtins/src/kotlin/Unit.kt \
		"${builtin_sources_dir}" || die "Failed to copy built-in sources"
	cp -r core/builtins/src/kotlin/{annotation,internal} \
		"${builtin_sources_dir}" || die "Failed to copy built-in sources"

	# :kotlin-stdlib-js:compileKotlin2Js
	local main_target="${target}/classes/main"
	local source_map_base_dirs_args=(
		"${builtin_sources_dir}"
		libraries/stdlib/js-v1/src
		libraries/stdlib/js/src
		libraries/stdlib/src/kotlin
		libraries/stdlib/{common,unsigned}/src
	)
	local OLD_IFS="${IFS}"
	IFS=':'
	local source_map_base_dirs="${source_map_base_dirs_args[*]}"
	IFS="${OLD_IFS}"
	KOTLIN_LIBS_COMMON_SOURCES_DIR=( libraries/stdlib/{,common,unsigned}/src )
	KOTLIN_LIBS_KOTLINC_ARGS=(
		-main noCall
		-meta-info
		-module-kind commonjs
		-no-stdlib
		-source-map
		-source-map-base-dirs "${source_map_base_dirs}"
		-source-map-prefix ./
		-target v5
		-Xallow-kotlin-package
		-Xallow-result-return-type
		-Xmulti-platform
		-Xopt-in=kotlin.RequiresOptIn
		-Xopt-in=kotlin.ExperimentalMultiplatform
		-Xopt-in=kotlin.contracts.ExperimentalContracts
	)
	src_files=(
		$(find \
			"${builtin_sources_dir}" \
			libraries/stdlib/js/src \
			libraries/stdlib/{,common,unsigned}/src \
			libraries/stdlib/js-v1/src/kotlin \
			-name "*.kt")
	)
	tr ' ' '\n' <<< "${src_files[@]}" >> "${sources}" || \
		die "Failed to append to list of source files"
	kotlin-libs_kotlinc -output "${main_target}/kotlin.js" "${src_files[@]}"

	# TODO: Build and use kotlin.js and kotlin.js.map
	# with the logic of :kotlin-stdlib-js:compileJs

	# :kotlin-stdlib-js-ir:commonMainSources is unnecessary
	# because it unconditionally copies all files under
	# libraries/stdlib/{,common,unsigned}/src without
	# any filtering or modification

	# :kotlin-stdlib-js-ir:jsMainSources
	local ir_js_main_dir="${target}/jsMainSources"
	mkdir -p "${ir_js_main_dir}" || \
		die "Could not create the IR JS main sources directory"
	local ir_js_main_unimpl_builtins=(
		core/builtins/native/kotlin/Annotation.kt
		core/builtins/native/kotlin/Any.kt
		core/builtins/native/kotlin/Array.kt
		core/builtins/native/kotlin/CharSequence.kt
		core/builtins/native/kotlin/Comparable.kt
		core/builtins/native/kotlin/Coroutines.kt
		core/builtins/native/kotlin/Iterator.kt
		core/builtins/native/kotlin/Nothing.kt
		core/builtins/native/kotlin/Number.kt
	)
	cp -r --parents \
		core/builtins/src \
		libraries/stdlib/js/{src,runtime} \
		"${ir_js_main_unimpl_builtins[@]}" \
		"${ir_js_main_dir}" || \
		die "Could not copy sources to the IR JS main sources directory"
	rm -r \
		"${ir_js_main_dir}"/libraries/stdlib/js/src/generated \
		"${ir_js_main_dir}"/core/builtins/src/kotlin/ArrayIntrinsics.kt || \
		die "Could not remove files from the IR JS main sources directory"
	for file in "${ir_js_main_unimpl_builtins[@]/#/${ir_js_main_dir}/}"; do
		cat - "${file}" <<- _EOC_ > "${file}.new" || \
			die "Failed to create a copy of ${file} for editing"
		@file:Suppress(
			"NON_ABSTRACT_FUNCTION_WITH_NO_BODY",
			"MUST_BE_INITIALIZED_OR_BE_ABSTRACT",
			"EXTERNAL_TYPE_EXTENDS_NON_EXTERNAL_TYPE",
			"PRIMARY_CONSTRUCTOR_DELEGATION_CALL_EXPECTED",
			"WRONG_MODIFIER_TARGET",
			"UNUSED_PARAMETER"
		)
		_EOC_
		mv "${file}.new" "${file}" || die "Failed to overwrite ${file}"
	done

	# :kotlin-stdlib-js-ir:compileKotlinJs
	local js_ir_target="${target}/classes/js-ir"
	KOTLIN_LIBS_COMMON_SOURCES_DIR=( libraries/stdlib/{,common,unsigned}/src )
	KOTLIN_LIBS_KOTLINC_ARGS=(
		-main call
		-meta-info
		-module-kind umd
		-no-stdlib
		-source-map
		-target v5
		-Xallow-kotlin-package
		-Xallow-result-return-type
		-Xinline-classes
		-Xir-only
		-Xir-produce-klib-dir
		-Xir-module-name=kotlin
		-Xmulti-platform
		-Xopt-in=kotlin.RequiresOptIn
		-Xopt-in=kotlin.ExperimentalUnsignedTypes
		-Xopt-in=kotlin.ExperimentalStdlibApi
		-Xread-deserialized-contracts
		-Xuse-experimental=kotlin.Experimental
		-Xuse-experimental=kotlin.ExperimentalMultiplatform
		-Xuse-experimental=kotlin.contracts.ExperimentalContracts
	)
	src_files=(
		$(find \
			"${ir_js_main_dir}" \
			libraries/stdlib/js-ir \
			libraries/stdlib/{,common,unsigned}/src \
			-name "*.kt")
	)
	tr ' ' '\n' <<< "${src_files[@]}" >> "${sources}" || \
		die "Failed to append to list of source files"
	kotlin-libs_kotlinc -output "${js_ir_target}" "${src_files[@]}"
	cp -r "${js_ir_target}/default" "${main_target}" || \
		die "Could not copy compiled files for IR to main target directory"

	# Create MANIFEST.MF
	kotlin-libs_create_manifest "${main_target}"

	# Create JAR
	jar cfm "${JAVA_JAR_FILENAME}" "${main_target}/META-INF/MANIFEST.MF" \
		-C "${main_target}" . || die "jar failed"
}