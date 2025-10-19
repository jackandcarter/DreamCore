add_subdirectory(genrev)
add_subdirectory(common)

if(SERVERS)
  add_subdirectory(server)
endif()

if(TOOLS)
  add_subdirectory(tools)
endif()
