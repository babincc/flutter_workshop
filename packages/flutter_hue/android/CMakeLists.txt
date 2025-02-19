cmake_minimum_required(VERSION 3.6)
project(flutter_hue)
find_package(openssl REQUIRED CONFIG)
add_library(${PROJECT_NAME} SHARED empty.c)
target_link_libraries(
  ${PROJECT_NAME}
  PRIVATE openssl::crypto
  PRIVATE openssl::ssl)
