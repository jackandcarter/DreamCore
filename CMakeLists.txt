cmake_minimum_required(VERSION 3.20)
project(DreamCore LANGUAGES CXX)

# Keep CI green while we import/modernize real sources
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message(STATUS "DreamCore scaffold: C++${CMAKE_CXX_STANDARD} configured")

# Placeholder target; replace with real subdirs later
add_library(dreamcore_placeholder INTERFACE)
