# rosplan_csp_exec_demo

Demo for the online esterel plan dispatch. Code under:
[CSPExecGenerator.cpp](https://github.com/oscar-lima/ROSPlan/blob/new-csp-exec/rosplan_planning_system/src/PlanDispatch/CSPExecGenerator.cpp),
[AdaptablePlanDispatcher.cpp](https://github.com/oscar-lima/ROSPlan/blob/new-csp-exec/rosplan_planning_system/src/PlanDispatch/AdaptablePlanDispatcher.cpp)

## Brief description

Finds out many different alternatives for a esterel plan to be executed by relaxing the constraints imposed by the execution graph
and by checking for online preconditions that are met.

A publication draft (currently under review) will be put here briefly.

## Installation

Make sure you have installed ROS first... This code has been tested on Ubuntu 18.04 & melodic distro.

Clone the following repositories inside your [catkin workspace](http://wiki.ros.org/catkin/Tutorials/create_a_workspace).

    git clone --single-branch --branch new-csp-exec https://github.com/oscar-lima/ROSPlan.git
    git clone --single-branch --branch new-csp-exec https://github.com/oscar-lima/rosplan_demos.git
    git clone https://github.com/clearpathrobotics/occupancy_grid_utils.git

Build (requires: sudo apt install python-catkin-tools)

    cd $ROS_WORKSPACE
    catkin build

## Run a single demo

roslaunch rosplan_csp_exec_demo rosplan_csp_exec_demo.launch

## Run multiple experiments (all experiments from the publication mentioned above)

rosrun rosplan_csp_exec_demo automated_multiple_experiment_run.sh
