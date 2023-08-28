cmake_minimum_required(VERSION 3.16)
project(atomic-replace LANGUAGES C CXX)

find_package(LLVM REQUIRED CONFIG)
include_directories(${LLVM_INCLUDE_DIRS})

if(LLVM_VERSION_MAJOR LESS 10 OR LLVM_VERSION_MAJOR GREATER 15)
  message(FATAL_ERROR "\
LLVM version 10 through 15 is required (version ${LLVM_VERSION_MAJOR} found)")
endif()

if(LLVM_VERSION_MAJOR GREATER_EQUAL 15)
  set(LLVM_SUFF "-15")
elseif(LLVM_VERSION_MAJOR GREATER_EQUAL 13)
  set(LLVM_SUFF "-13")
else()
  set(LLVM_SUFF "-10")
endif()

add_library(atomic-replace MODULE AtomicReplacePass.cpp)
target_compile_options(atomic-replace PUBLIC -Wall -Werror)
install(TARGETS atomic-replace DESTINATION lib)

set(PASSNAME "atomic-replace")
configure_file(wrapper${LLVM_SUFF}.sh atomic-replace @ONLY)
install(PROGRAMS ${CMAKE_CURRENT_BINARY_DIR}/atomic-replace DESTINATION bin)

enable_testing()
add_subdirectory(tests)
