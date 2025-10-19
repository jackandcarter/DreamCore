cmake_minimum_required(VERSION 3.20)
project(DreamCore LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Detect Homebrew prefix on macOS and add common hint paths
if(APPLE)
  # Try both Apple Silicon and Intel prefixes
  foreach(PFX "/opt/homebrew" "/usr/local")
    if(EXISTS "${PFX}")
      list(APPEND CMAKE_PREFIX_PATH
        "${PFX}"
        "${PFX}/opt/openssl@3"
        "${PFX}/opt/boost"
        "${PFX}/opt/mysql-client")
      list(APPEND CMAKE_INCLUDE_PATH
        "${PFX}/include" "${PFX}/opt/mysql-client/include")
      list(APPEND CMAKE_LIBRARY_PATH
        "${PFX}/lib" "${PFX}/opt/mysql-client/lib")
    endif()
  endforeach()
endif()

find_package(OpenSSL REQUIRED)
if (OpenSSL_VERSION VERSION_GREATER_EQUAL "3.0.0")
  add_compile_definitions(HAVE_OPENSSL3=1)
endif()

find_package(Boost 1.70 REQUIRED COMPONENTS
  system filesystem program_options thread iostreams regex)

# MySQL client can be named differently on macOS (mysqlclient / mariadb)
find_library(MYSQLCLIENT_LIB
  NAMES mysqlclient mariadb
  HINTS ${CMAKE_LIBRARY_PATH})
find_path(MYSQLCLIENT_INCLUDE_DIR
  NAMES mysql/mysql.h mariadb/mysql.h
  HINTS ${CMAKE_INCLUDE_PATH})

if(NOT MYSQLCLIENT_LIB OR NOT MYSQLCLIENT_INCLUDE_DIR)
  message(FATAL_ERROR "MySQL client not found — install 'mysql-client' via Homebrew.")
endif()

set(MYSQL_INCLUDE_DIR ${MYSQLCLIENT_INCLUDE_DIR})

if(NOT TARGET mysql)
  add_library(mysql UNKNOWN IMPORTED)
  set_target_properties(mysql PROPERTIES
    IMPORTED_LOCATION "${MYSQLCLIENT_LIB}"
    INTERFACE_INCLUDE_DIRECTORIES "${MYSQL_INCLUDE_DIR}")
endif()

if(APPLE)
  set(CMAKE_MACOSX_RPATH ON)
  set(CMAKE_INSTALL_RPATH
      "@loader_path/../lib;@executable_path/../lib")
  # Add brew runtime paths to help local dev binaries run without install
  list(APPEND CMAKE_BUILD_RPATH
      "/opt/homebrew/lib" "/usr/local/lib")
endif()

include_directories(${Boost_INCLUDE_DIRS} ${MYSQLCLIENT_INCLUDE_DIR})
link_directories(${Boost_LIBRARY_DIRS})

add_compile_options(-Wno-register -Wno-deprecated-declarations)

message(STATUS "DreamCore scaffold: C++${CMAKE_CXX_STANDARD} configured")

add_subdirectory(src/compat)
