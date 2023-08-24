cmake_minimum_required(VERSION 3.16.3)
project(ipb_car_hardware)

find_package(catkin REQUIRED)

catkin_package()

install(
  PROGRAMS launch/create_urdf.py
  DESTINATION ${CATKIN_PACKAGE_BIN_DESTINATION}/scripts)

