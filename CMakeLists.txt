cmake_minimum_required(VERSION 3.16)

project(WordleHelper VERSION 0.1 LANGUAGES CXX)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)


qt_add_executable(appWordleHelper
    main.cpp
)

qt_add_resources(appWordleHelper "app_wordlehelper"
    PREFIX "/"
    FILES
        images/france.png
        images/united-kingdom.png
        images/cancel.png
        dictionaries/mots.txt
        dictionaries/words_list.txt
)

qt_add_qml_module(appWordleHelper
    URI WordleHelper
    VERSION 1.0
    QML_FILES
        Main.qml
    SOURCES
        source/wordle_backend.h
        source/wordle_backend.cpp
        source/wordle_finder.h
        source/wordle_finder.cpp
        source/file_parser.h
        source/file_parser.cpp
)

target_include_directories(appWordleHelper
    PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}/source
)


target_link_libraries(appWordleHelper
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appWordleHelper
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
