add_library(asteroid-health main.cpp cpp/lineGraph.cpp cpp/lineGraph.h resources.qrc)
set_target_properties(asteroid-health PROPERTIES PREFIX "")

target_link_libraries(asteroid-health PUBLIC
	AsteroidApp)

install(TARGETS asteroid-health
	DESTINATION ${CMAKE_INSTALL_LIBDIR})
