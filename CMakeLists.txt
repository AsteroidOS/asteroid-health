cmake_minimum_required(VERSION 3.20)

project(
	asteroid-health
	VERSION 0.2.0
	DESCRIPTION "Graphical interface for asteroid-sensorlogd"
)

find_package(ECM REQUIRED NO_MODULE)
find_package(AsteroidApp6 REQUIRED)

set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ASTEROID_MODULE_PATH})

include(FeatureSummary)
include(GNUInstallDirs)
include(ECMFindQmlModule)
include(Asteroid6CMakeSettings)
include(Asteroid6Translations)

ecm_find_qmlmodule(Nemo.Configuration 1.0)
ecm_find_qmlmodule(org.asteroid.sensorlogd 1.0)

add_subdirectory(src)

build_translations(i18n)

configure_file(
	${CMAKE_CURRENT_SOURCE_DIR}/asteroid-health.in
	${CMAKE_BINARY_DIR}/asteroid-health
	@ONLY
)

install(
	PROGRAMS ${CMAKE_BINARY_DIR}/asteroid-health
	DESTINATION ${CMAKE_INSTALL_BINDIR}
)

generate_desktop(${CMAKE_SOURCE_DIR} asteroid-health)

feature_summary(WHAT ALL FATAL_ON_MISSING_REQUIRED_PACKAGES)
