project(otbossimplugins)

set(OTB3P_INSTALL_EXPORT_NAME "${OTBOssimPlugins-targets}")
set(OTB3P_INSTALL_INCLUDE_DIR "${OTBOssimPlugins_INSTALL_INCLUDE_DIR}")
set(OTB3P_INSTALL_RUNTIME_DIR "${OTBOssimPlugins_INSTALL_RUNTIME_DIR}")
set(OTB3P_INSTALL_LIBRARY_DIR "${OTBOssimPlugins_INSTALL_LIBRARY_DIR}")
set(OTB3P_INSTALL_ARCHIVE_DIR "${OTBOssimPlugins_INSTALL_ARCHIVE_DIR}")

set(ossimplugins_VERSION_MAJOR "1")
set(ossimplugins_VERSION_MINOR "8")
set(ossimplugins_VERSION_PATCH "4")

# svn revision number of ossim (used for .so versioning)
set(OSSIMPLUGINS_SVN_REVISION "18162")
# patch number for OTB modifications applied on top of OSSIM_SVN_REVISION (used for .so versioning)
set(OSSIMPLUGINS_OTB_PATCH "1")

# include_directories(${CMAKE_CURRENT_SOURCE_DIR}
#   ${CMAKE_CURRENT_SOURCE_DIR}/ossim
# #  ${OTB_SOURCE_DIR}/Utilities/otbossim/include
# #  ${OTB_BINARY_DIR}/Utilities/otbossim/include
# )
#if(OTB_USE_EXTERNAL_OSSIM)
#  include_directories(${OSSIM_INCLUDE_DIR})

  # When using External ossim, compile ossimplugin as a DLL
  # even if we compile OTB as a static lib
  set(ossimplugins_LIBTYPE SHARED)
  if(WIN32)  
    add_definitions(-DOSSIMPLUGINSMAKINGDLL)
  endif()

#else()
#  include_directories(${OTB_SOURCE_DIR}/Utilities/otbossim/include)
#  include_directories(${OTB_BINARY_DIR}/Utilities/otbossim/include)
#endif()

#include_directories(AFTER ${GEOTIFF_INCLUDE_DIRS} ${TIFF_INCLUDE_DIRS})

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/gdal)
include_directories(${CMAKE_CURRENT_SOURCE_DIR}/ossim)

file(GLOB_RECURSE ossimplugins_gdal_SRCS "${CMAKE_CURRENT_SOURCE_DIR}/gdal/*.cpp")
file(GLOB_RECURSE ossimplugins_ossim_SRCS "${CMAKE_CURRENT_SOURCE_DIR}/ossim/*.cpp")

set(ossimplugins_SOURCES
  ${ossimplugins_gdal_SRCS}
  ${ossimplugins_ossim_SRCS}
)

add_library(otbossimplugins ${ossimplugins_LIBTYPE} ${ossimplugins_SOURCES})
target_link_libraries(otbossimplugins 
  ${OTBGDAL_LIBRARIES}
  ${OTBOssim_LIBRARIES}
  ${OTBGeoTIFF_LIBRARIES}
  )

# Apply user-defined properties to the library target.
if(OTB_LIBRARY_PROPERTIES)
  set_target_properties(otbossimplugins PROPERTIES ${OTB_LIBRARY_PROPERTIES})
endif(OTB_LIBRARY_PROPERTIES)

install(TARGETS otbossimplugins
  EXPORT ${OTB3P_INSTALL_EXPORT_NAME}
  RUNTIME DESTINATION ${OTB3P_INSTALL_RUNTIME_DIR} COMPONENT RuntimeLibraries
  LIBRARY DESTINATION ${OTB3P_INSTALL_LIBRARY_DIR} COMPONENT RuntimeLibraries
  ARCHIVE DESTINATION ${OTB3P_INSTALL_ARCHIVE_DIR} COMPONENT Development
  )

# purposely do not install headers as OssimAdapters API do not require them.

otb_module_target( otbossimplugins NO_INSTALL )
