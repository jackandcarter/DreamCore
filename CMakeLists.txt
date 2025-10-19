cmake_minimum_required(VERSION 3.20)
project(DreamCore LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(OpenSSL REQUIRED)
if (OpenSSL_VERSION VERSION_GREATER_EQUAL "3.0.0")
  add_compile_definitions(HAVE_OPENSSL3=1)
endif()

find_package(Boost 1.70 REQUIRED COMPONENTS
  system filesystem program_options thread iostreams regex)

include_directories(${Boost_INCLUDE_DIRS})
link_directories(${Boost_LIBRARY_DIRS})

add_compile_options(-Wno-register -Wno-deprecated-declarations)

message(STATUS "DreamCore scaffold: C++${CMAKE_CXX_STANDARD} configured")

add_library(dreamcore_placeholder INTERFACE)
