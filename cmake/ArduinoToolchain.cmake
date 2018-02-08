#=============================================================================#
# Author: Tomasz Bogdal (QueezyTheGreat)
# Home:   https://github.com/queezythegreat/arduino-cmake
#
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.
#=============================================================================#
if (_IS_TOOLCHAIN_PROCESSED)
    return()
endif ()
set(_IS_TOOLCHAIN_PROCESSED True)

IF(NOT DEFINED ARDUINO_CPU_ARCHITECTURE)
    SET(ARDUINO_CPU_ARCHITECTURE "avr")
ENDIF(NOT DEFINED ARDUINO_CPU_ARCHITECTURE)

set(CMAKE_SYSTEM_NAME Arduino)
# Add current directory to CMake Module path automatically
if (EXISTS ${CMAKE_CURRENT_LIST_DIR}/Platform/Arduino.cmake)
    set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_LIST_DIR})
endif ()

#=============================================================================#
#                         System Paths                                        #
#=============================================================================#
if (UNIX)
    include(Platform/UnixPaths)
    if (APPLE)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH ~/Applications
                /Applications
                /Developer/Applications
                /sw        # Fink
                /opt/local) # MacPorts
    endif ()
elseif (WIN32)
    include(Platform/WindowsPaths)
endif ()

#=============================================================================#
#                         Detect Arduino SDK                                  #
#=============================================================================#
if ((NOT ARDUINO_SDK_PATH) AND (NOT DEFINED ENV{_ARDUINO_CMAKE_WORKAROUND_ARDUINO_SDK_PATH}))
    set(ARDUINO_PATHS)

    foreach (DETECT_VERSION_MAJOR 1)
        foreach (DETECT_VERSION_MINOR RANGE 5 0)
            list(APPEND ARDUINO_PATHS arduino-${DETECT_VERSION_MAJOR}.${DETECT_VERSION_MINOR})
            foreach (DETECT_VERSION_PATCH RANGE 3 0)
                list(APPEND ARDUINO_PATHS arduino-${DETECT_VERSION_MAJOR}.${DETECT_VERSION_MINOR}.${DETECT_VERSION_PATCH})
            endforeach ()
        endforeach ()
    endforeach ()

    foreach (VERSION RANGE 23 19)
        list(APPEND ARDUINO_PATHS arduino-00${VERSION})
    endforeach ()

    if (UNIX)
        file(GLOB SDK_PATH_HINTS
                /usr/share/arduino*
                /opt/local/arduino*
                /opt/arduino*
                /usr/local/share/arduino*)
    elseif (WIN32)
        set(SDK_PATH_HINTS
                "C:\\Program Files\\Arduino"
                "C:\\Program Files (x86)\\Arduino")
    endif ()
    list(SORT SDK_PATH_HINTS)
    list(REVERSE SDK_PATH_HINTS)

    if (DEFINED ENV{ARDUINO_SDK_PATH})
        list(APPEND SDK_PATH_HINTS $ENV{ARDUINO_SDK_PATH})
    endif ()

    find_path(ARDUINO_SDK_PATH
            NAMES lib/version.txt
            PATH_SUFFIXES share/arduino Arduino.app/Contents/Resources/Java/ Arduino.app/Contents/Java/ ${ARDUINO_PATHS}
            HINTS ${SDK_PATH_HINTS}
            DOC "Arduino SDK base directory")
elseif ((NOT ARDUINO_SDK_PATH) AND (DEFINED ENV{_ARDUINO_CMAKE_WORKAROUND_ARDUINO_SDK_PATH}))
    set(ARDUINO_SDK_PATH "$ENV{_ARDUINO_CMAKE_WORKAROUND_ARDUINO_SDK_PATH}")
endif ()

MESSAGE(STATUS "Architecture is ${ARDUINO_CPU_ARCHITECTURE}")
IF(ARDUINO_CPU_ARCHITECTURE STREQUAL "stm32" )
    SET(ARDUINO_ARCHITECTURE_POSTFIX "Stm32")
ELSEIF(ARDUINO_CPU_ARCHITECTURE STREQUAL "avr" )
    SET(ARDUINO_ARCHITECTURE_POSTFIX "Avr")
ELSE(ARDUINO_CPU_ARCHITECTURE STREQUAL "avr" )
    MESSAGE(FATAL_ERROR "Unknown architecture")
ENDIF(ARDUINO_CPU_ARCHITECTURE STREQUAL "stm32" )
include(${CMAKE_CURRENT_LIST_DIR}/ArduinoToolchain${ARDUINO_ARCHITECTURE_POSTFIX}.cmake)


