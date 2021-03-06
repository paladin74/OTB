set(proj OPENSSL)

if(NOT __EXTERNAL_${proj}__)
set(__EXTERNAL_${proj}__ 1)

message(STATUS "Setup OpenSSL ...")

if(USE_SYSTEM_OPENSSL)
  find_package ( OPENSSL )
  message(STATUS "  Using OpenSSL system version")
else()
  SETUP_SUPERBUILD(PROJECT ${proj})
  message(STATUS "  Using OpenSSL SuperBuild version")
  
  # declare dependencies
  ADDTO_DEPENDENCIES_IF_NOT_SYSTEM(${proj} ZLIB)

  INCLUDE_SUPERBUILD_DEPENDENCIES(${${proj}_DEPENDENCIES})
  # set proj back to its original value
  set(proj OPENSSL)

  if(WIN32)
    set(OPENSSL_BUILD_ARCH "linux-x32")
    set(OPENSSL_BUILD_ARCH "VC-WIN32")
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
      set(OPENSSL_BUILD_ARCH "linux-x86_64")
      set(OPENSSL_BUILD_ARCH "VC-WIN64A")
    endif()
  endif() 
  
  if(MSVC)
      STRING(REGEX REPLACE "/$" "" CMAKE_WIN_INSTALL_PREFIX ${SB_INSTALL_PREFIX})    
    STRING(REGEX REPLACE "/" "\\\\" CMAKE_WIN_INSTALL_PREFIX ${CMAKE_WIN_INSTALL_PREFIX})
    ExternalProject_Add(${proj}
        PREFIX ${proj}
        URL "https://github.com/openssl/openssl/archive/OpenSSL_1_0_1p.tar.gz"
        URL_MD5 6bc1f9a9d9d474aceceb377e758e48ec
        DEPENDS ${${proj}_DEPENDENCIES}
        BINARY_DIR ${OPENSSL_SB_BUILD_DIR}
        INSTALL_DIR ${SB_INSTALL_PREFIX}
        DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
         PATCH_COMMAND  ${CMAKE_COMMAND} -E copy_directory ${OPENSSL_SB_SRC} ${OPENSSL_SB_BUILD_DIR}
        CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir ${OPENSSL_SB_BUILD_DIR} perl Configure ${OPENSSL_BUILD_ARCH} no-asm  --prefix=${CMAKE_WIN_INSTALL_PREFIX} --openssldir=${CMAKE_WIN_INSTALL_PREFIX}
      BUILD_COMMAND ms/do_ms.bat
      INSTALL_COMMAND nmake -f ms/ntdll.mak install
    )
    
  else(UNIX)
    ExternalProject_Add(${proj}
      PREFIX ${proj}
      DEPENDS ${${proj}_DEPENDENCIES}
      URL "https://github.com/openssl/openssl/archive/OpenSSL_1_0_1p.tar.gz"
      URL_MD5 6bc1f9a9d9d474aceceb377e758e48ec
      BINARY_DIR ${OPENSSL_SB_BUILD_DIR}
      INSTALL_DIR ${SB_INSTALL_PREFIX}
      DOWNLOAD_DIR ${DOWNLOAD_LOCATION}
      PATCH_COMMAND  ${CMAKE_COMMAND} -E copy_directory ${OPENSSL_SB_SRC} ${OPENSSL_SB_BUILD_DIR}
      CONFIGURE_COMMAND ${CMAKE_COMMAND} -E chdir ${OPENSSL_SB_BUILD_DIR} ./config ${OPENSSL_BUILD_ARCH}
      --prefix=${SB_INSTALL_PREFIX} shared zlib zlib-dynamic -I${SB_INSTALL_PREFIX}/include -L${SB_INSTALL_PREFIX}/lib
      BUILD_COMMAND $(MAKE)
      INSTALL_COMMAND $(MAKE) install)

    ExternalProject_Add_Step(${proj} remove_static
      COMMAND ${CMAKE_COMMAND} -E remove
      ${SB_INSTALL_PREFIX}/lib/libssl.a
      ${SB_INSTALL_PREFIX}/lib/libcrypto.a
      ${SB_INSTALL_PREFIX}/bin/openssl
      ${SB_INSTALL_PREFIX}/bin/c_rehash
      DEPENDEES install)

  endif()
  
  set(_SB_${proj}_INCLUDE_DIR ${SB_INSTALL_PREFIX}/include)
  if(WIN32)
    set(_SB_${proj}_LIBRARY ${SB_INSTALL_PREFIX}/lib/libcurl.lib)
  elseif(UNIX)
    set(_SB_${proj}_LIBRARY ${SB_INSTALL_PREFIX}/lib/libssl${CMAKE_SHARED_LIBRARY_SUFFIX})
  endif()

endif()
endif()




