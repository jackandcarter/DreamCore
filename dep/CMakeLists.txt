# Copyright (C) 2020 BfaCore
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

function(dc_silence_vendor target)
  if(TARGET ${target})
    get_target_property(_type ${target} TYPE)
    if(NOT _type OR _type STREQUAL "INTERFACE_LIBRARY")
      return()
    endif()

    get_target_property(_imported ${target} IMPORTED)
    if(_imported)
      return()
    endif()

    if(MSVC)
      return()
    endif()

    target_compile_options(${target}
      PRIVATE
        -Wno-deprecated
        -Wno-deprecated-declarations
        -Wno-register)
  endif()
endfunction()

add_subdirectory(threads)

if(SERVERS OR TOOLS)
  add_subdirectory(boost)
  add_subdirectory(process)
  add_subdirectory(zlib)
  add_subdirectory(g3dlite)
  add_subdirectory(recastnavigation)
  add_subdirectory(fmt)
  add_subdirectory(SFMT)
  add_subdirectory(utf8cpp)
  add_subdirectory(valgrind)
  add_subdirectory(openssl)
  add_subdirectory(jemalloc)
endif()

if(SERVERS)
  add_subdirectory(mysql)
  add_subdirectory(readline)
  add_subdirectory(gsoap)
  add_subdirectory(rapidjson)
  add_subdirectory(efsw)
  add_subdirectory(protobuf)
endif()

if(TOOLS)
  add_subdirectory(bzip2)
  add_subdirectory(CascLib)
endif()

dc_silence_vendor(protobuf)
dc_silence_vendor(gsoap)
dc_silence_vendor(g3dlite)
dc_silence_vendor(Detour)
dc_silence_vendor(Recast)
dc_silence_vendor(fmt)
dc_silence_vendor(efsw)
dc_silence_vendor(casc)
dc_silence_vendor(jemalloc)
dc_silence_vendor(bzip2)
dc_silence_vendor(zlib)
