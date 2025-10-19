# Copyright (C) 2020 BfaCore
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

if (NOT MYSQL_FOUND)
  message(FATAL_ERROR "MySQL wasn't found on your system but it's required to build the servers!")
endif()

add_library(mysql STATIC IMPORTED GLOBAL)

set(_mysql_interface_dirs "${MYSQL_INCLUDE_DIR}")
get_filename_component(_mysql_parent "${MYSQL_INCLUDE_DIR}" DIRECTORY)
if (_mysql_parent)
  list(APPEND _mysql_interface_dirs "${_mysql_parent}")
endif()
list(REMOVE_DUPLICATES _mysql_interface_dirs)

set_target_properties(mysql
  PROPERTIES
    IMPORTED_LOCATION
      "${MYSQL_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES
      "${_mysql_interface_dirs}")
