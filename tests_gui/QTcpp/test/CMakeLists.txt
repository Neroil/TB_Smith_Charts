cmake_minimum_required(VERSION 3.16)

project(test VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets)

qt_standard_project_setup()

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

qt_add_executable(test
    main.cpp
    mainwindow.cpp
    mainwindow.h
    mainwindow.ui
    smithchartwidget.cpp
    smithchartwidget.h
)

target_link_libraries(test PRIVATE Qt${QT_VERSION_MAJOR}::Widgets)

set_target_properties(test PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

include(GNUInstallDirs)
install(TARGETS test
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
