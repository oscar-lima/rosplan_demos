#!/bin/bash

# add robot kenny instance + goals: visit all waypoint instances
echo "Adding initial state and goals to knowledge base.";

# physobj : nothing
param_type="update_type:
- 0";
param="knowledge:
- knowledge_type: 0
  instance_type: 'physyobj'
  instance_name: 'nothing'
  attribute_name: ''
  function_value: 0.0";

# (Holding ur5 nothing)
param_type="$param_type
- 0";
param="$param
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'holding'
  values:
  - {key: 'arm', value: 'ur5'}
  - {key: 'obj', value: 'nothing'}
  function_value: 0.0";

# arm_posture : undefined
param_type="$param_type
- 0";
param="$param
- knowledge_type: 0
  instance_type: 'arm_posture'
  instance_name: 'undef'
  attribute_name: ''
  function_value: 0.0";

# (ArmPosture ur5 undefined)
param_type="$param_type
- 0";
param="$param
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'arm_posture'
  values:
  - {key: 'arm', value: 'ur5'}
  - {key: 'obj', value: 'undef'}
  function_value: 0.0";

# area : lab1
param_type="$param_type
- 0";
param="$param
- knowledge_type: 0
  instance_type: 'area'
  instance_name: 'lab1'
  attribute_name: ''
  function_value: 0.0";

# (RobotAt lab1)
param_type="$param_type
- 0";
param="$param
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'robot_at'
  values:
  - {key: 'area', value: 'lab1'}
  function_value: 0.0";

# area : table1
param_type="$param_type
- 0";
param="$param
- knowledge_type: 0
  instance_type: 'area'
  instance_name: 'table1'
  attribute_name: ''
  function_value: 0.0";

 # area : table1_man_area
param_type="$param_type
- 0";
param="$param
- knowledge_type: 0
  instance_type: 'area'
  instance_name: 'table1_man_area'
  attribute_name: ''
  function_value: 0.0"; 


# (reachable_from tabl1 table1_man_area)
param_type="$param_type
- 0";
param="$param
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'reachable_from'
  values:
  - {key: 'obj_area', value: 'table1'}
  - {key: 'man_area', value: 'table1_man_area'}
  function_value: 0.0";

# physobj : powerdrill1
param_type="$param_type
- 0";
param="$param
- knowledge_type: 0
  instance_type: 'physyobj'
  instance_name: 'powerdrill1'
  attribute_name: ''
  function_value: 0.0";

# (on powerdrill1 table1)
param_type="$param_type
- 0";
param="$param
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'on'
  values:
  - {key: 'obj', value: 'powerdrill1'}
  - {key: 'area', value: 'table1'}
  function_value: 0.0";

# Goal: (get powerdrill1)
param_type="$param_type
- 1"
param="$param
- knowledge_type: 1
  instance_type: ''
  instance_name: ''
  attribute_name: 'get'
  values:
  - {key: 'obj', value: 'powerdrill1'}
  function_value: 0.0"

rosservice call /rosplan_knowledge_base/update_array "
$param_type
$param"

# automatically generate PDDL problem from KB snapshot (e.g. fetch knowledge from KB and create problem.pddl)
echo "Calling problem generator.";
rosservice call /rosplan_problem_interface/problem_generation_server;

# make plan (e.g. call chimp to create solution)
echo "Calling planner interface.";
rosservice call /rosplan_planner_interface/planning_server;

# parse plan (parse console output and extract actions and params, e.g. create esterel graph)
echo "Calling plan parser.";
rosservice call /rosplan_parsing_interface/parse_plan;

# # dispatch (execute) plan. (send actions one by one to their respective interface and wait for them to finish)
echo "Calling plan dispatcher.";
rosservice call /rosplan_plan_dispatcher/dispatch_plan;

echo "Finished!";
