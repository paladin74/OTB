include(ExternalProject)
set(proj PACKAGE-TOOLS)

if(NOT __EXTERNAL_${proj}__)
set(__EXTERNAL_${proj}__ 1)

set(PKGTOOLS_SB_SRC "${CMAKE_BINARY_DIR}/${proj}/src/${proj}")
set(PKGTOOLS_SB_BUILD_DIR "${CMAKE_BINARY_DIR}/${proj}/build/")

ExternalProject_Add(${proj}
  PREFIX ${proj}
  URL "http://nixos.org/releases/patchelf/patchelf-0.8/patchelf-0.8.tar.gz"
  URL_MD5 407b229e6a681ffb0e2cdd5915cb2d01
  DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
  SOURCE_DIR ${PKGTOOLS_SB_SRC}
  BINARY_DIR ${PKGTOOLS_SB_BUILD_DIR}
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  PATCH_COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_INSTALL_PREFIX}/tools
  UPDATE_COMMAND ${CMAKE_COMMAND} -E copy_directory ${PKGTOOLS_SB_SRC} ${PKGTOOLS_SB_BUILD_DIR}
  CONFIGURE_COMMAND ${PKGTOOLS_SB_BUILD_DIR}/configure --prefix ${CMAKE_INSTALL_PREFIX}/tools
  BUILD_COMMAND $(MAKE)
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${PKGTOOLS_SB_BUILD_DIR}/src/patchelf ${CMAKE_INSTALL_PREFIX}/tools )

ExternalProject_Add(makeself
  PREFIX makeself
  URL "https://www.orfeo-toolbox.org/packages/makeself-2.2.0.tar.gz"
  URL_MD5 3c61df934b0c61ddcd7bd63b391e951d
  DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
  SOURCE_DIR ${PKGTOOLS_SB_BUILD_DIR}/makeself/src
  BINARY_DIR ${PKGTOOLS_SB_BUILD_DIR}/makeself/build
  INSTALL_DIR ${CMAKE_INSTALL_PREFIX}
  ####${CMAKE_COMMAND} -E copy ${PKGTOOLS_SB_BUILD_DIR}/makeself/src/makeself.lsm ${CMAKE_BINARY_DIR}/makeself.lsm
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ${CMAKE_COMMAND} -E copy ${PKGTOOLS_SB_BUILD_DIR}/makeself/src/makeself-header.sh ${CMAKE_BINARY_DIR}/makeself-header.sh
  INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${PKGTOOLS_SB_BUILD_DIR}/makeself/src/makeself.sh ${CMAKE_BINARY_DIR}/makeself.sh  
  DEPENDS ${proj})

endif()
