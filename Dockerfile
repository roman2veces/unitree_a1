FROM ros:foxy-ros1-bridge

RUN sudo apt update 
# libglib2.0-dev is a LCM dependency 
RUN sudo apt install -y git wget unzip libglib2.0-dev 

WORKDIR /
RUN mkdir /home/mistlab
WORKDIR /home/mistlab/

RUN wget https://github.com/lcm-proj/lcm/archive/refs/tags/v1.5.0.zip && \
    unzip v1.5.0.zip

# Install LCM library
RUN mkdir lcm-1.5.0/build 
WORKDIR lcm-1.5.0/build 
RUN cmake .. && make && sudo make install && sudo ldconfig -v

# # Install unitree_legged_sdk library
WORKDIR /home/mistlab/
RUN wget https://github.com/unitreerobotics/unitree_legged_sdk/archive/refs/tags/v3.2.zip && \
    unzip v3.2.zip
# COPY unitree_legged_sdk ./unitree_legged_sdk
RUN mv unitree_legged_sdk-3.2 unitree_legged_sdk && \
    mkdir unitree_legged_sdk/build
WORKDIR unitree_legged_sdk/build 
RUN cmake .. && make

# Set environment variables
# 3_1 is for Aliengo robot, 3_2 is for A1 robot
ENV UNITREE_SDK_VERSION=3_2
ENV UNITREE_LEGGED_SDK_PATH=/home/mistlab/unitree_legged_sdk
# amd64, arm32, arm64 
# TODO: change this to arm64 
ENV UNITREE_PLATFORM="amd64" 

# # Install our source code (A1 ROS2 drivers)
WORKDIR /home/mistlab/
RUN mkdir -p ros2_ws/src
WORKDIR ros2_ws/src
RUN git clone https://github.com/roman2veces/ros2_unitree_legged_msgs && \
    git clone https://github.com/roman2veces/unitree_ros2_to_real

# TODO: maybe try to make this work 
# CMD ["source", "/opt/ros/foxy/setup.bash"]
# CMD ["cd", "/home/mistlab/ros2_ws"]
# CMD ["colcon", "build"]
# CMD ["source", "install/setup.bash"]