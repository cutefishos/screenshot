cmake_minimum_required(VERSION 3.14)

project(cutefish-screenshot LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core DBus Gui Widgets Quick REQUIRED)

set(PROJECT_SOURCES
    src/main.cpp
    src/screenshotview.cpp
    qml.qrc
)

add_executable(cutefish-screenshot
  ${PROJECT_SOURCES}
)

target_link_libraries(cutefish-screenshot
  PRIVATE
  Qt5::Core
  Qt5::DBus
  Qt5::Gui
  Qt5::Widgets
  Qt5::Quick
)

install(TARGETS cutefish-screenshot RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})

install(FILES
    cutefish-screenshot.desktop
    DESTINATION /usr/share/applications/
    COMPONENT Runtime
)
