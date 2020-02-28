# rosplan_csp_exec_demo

Demo for the online esterel plan dispatch. Code under:
[CSPExecGenerator.cpp](https://github.com/oscar-lima/ROSPlan/blob/new-csp-exec/rosplan_planning_system/src/PlanDispatch/CSPExecGenerator.cpp),
[AdaptablePlanDispatcher.cpp](https://github.com/oscar-lima/ROSPlan/blob/new-csp-exec/rosplan_planning_system/src/PlanDispatch/AdaptablePlanDispatcher.cpp)

## Brief description

Finds out many different alternatives for a esterel plan to be executed by relaxing the constraints imposed by the execution graph
and by checking for online preconditions that are met.

A publication draft (currently under review) will be put here briefly.

## Run the demo

roslaunch rosplan_csp_exec_demo rosplan_csp_exec_demo.launch
