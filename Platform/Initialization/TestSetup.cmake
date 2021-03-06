if(ARDUINO_CMAKE_SKIP_TEST_SETUP)
   return()
endif()

# Ensure that all required paths are found
validate_variables_not_empty(VARS
        ARDUINO_PLATFORMS
        ARDUINO_CORES_PATH
        ARDUINO_BOOTLOADERS_PATH
        ARDUINO_LIBRARIES_PATH
        ARDUINO_BOARDS_PATH
        ARDUINO_PROGRAMMERS_PATH
        ARDUINO_VERSION_PATH
        ARDUINO_AVRDUDE_FLAGS
        ARDUINO_AVRDUDE_PROGRAM
        ARDUINO_AVRDUDE_CONFIG_PATH
        AVRSIZE_PROGRAM
        ${ADDITIONAL_REQUIRED_VARS}
        MSG "Invalid Arduino SDK path (${ARDUINO_SDK_PATH}).\n")
