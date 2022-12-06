cmake_minimum_required(VERSION 3.1)
project(mono_perspective_resectioning)
set(CXX_STANDARD C++20)
set (CMAKE_CXX_FLAGS "-lstdc++fs -std=c++17")


find_package(OpenCV REQUIRED)

add_executable(capture src/capture.cpp)

target_link_libraries(capture PRIVATE ${OpenCV_LIBS})
