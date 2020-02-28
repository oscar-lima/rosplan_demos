#!/bin/bash

# Calls multiple experiments in parallel exploiting the ROS capability for
# using multiple PORTS, 

# NOTE: domain is same for all experiments: domain_robot_delivery.pddl

# function call_exec_experiment(){
#     # make experiments in parallel
#     for i in `seq 0 9`; # do not set more than 9!
#         do
#             PORT=11${i}11
#             export ROS_MASTER_URI=http://localhost:$PORT # roscore -p $PORT not needed!
#             echo "roslaunch rosplan_csp_exec_demo rosplan_csp_exec_demo.launch adaptable_plan_dispatcher_required:=$1 category:=$2 problem:=$3 domain:=$4"
#             timeout 600 roslaunch rosplan_csp_exec_demo rosplan_csp_exec_demo.launch adaptable_plan_dispatcher_required:=$1 category:=$2 problem:=$3 domain:=$4&
#         done
# }

function call_exec_experiment_with_wait(){
    for i in `seq 0 9`;
        do
            PORT=11${i}11
            export ROS_MASTER_URI=http://localhost:$PORT # roscore -p $PORT not needed!
            # ./procs[${i}] &
            echo "roslaunch rosplan_csp_exec_demo rosplan_csp_exec_demo.launch adaptable_plan_dispatcher_required:=$1 category:=$2 problem:=$3 domain:=$4"
            timeout 600 roslaunch rosplan_csp_exec_demo rosplan_csp_exec_demo.launch adaptable_plan_dispatcher_required:=$1 category:=$2 problem:=$3 domain:=$4&
            # run processes and store pids in array
            pids[${i}]=$!
        done

    # wait for all pids to finish
    for pid in ${pids[*]};
        do
            wait $pid
        done

    echo '---------------- DONE WITH BATCH ----------------'
}

# arg 1: adaptable_plan_dispatcher_required options: (true, false)
# arg 2: category, temporal or non temporal? options: (iros_problems_free, iros_problems_deadlines)
# arg 3: problem instance name, options: (too large, check below for details)

# iros problems deadlines (temporal) (9)
# ===
declare -a t_prob=("problem_w5_m5_g3" "problem_w6_m4_g3" "problem_w7_m3_g3" "problem_w8_m3_g3" "problem_w8_m5_g3" "problem_w6_m3_g3" "problem_w6_m5_g3" "problem_w7_m4_g3" "problem_w8_m4_g3")

# iros_problems_free (non temporal) bash array (30)
# ===
declare -a nt_prob=("problem_w4_m3_g2" "problem_w4_m5_g2" "problem_w5_m4_g2" "problem_w6_m3_g2" "problem_w6_m5_g2" "problem_w7_m4_g2" "problem_w8_m3_g2" "problem_w8_m5_g2" "problem_w4_m3_g3" "problem_w4_m5_g3" "problem_w5_m4_g3" "problem_w6_m3_g3" "problem_w6_m5_g3" "problem_w7_m4_g3" "problem_w8_m3_g3" "problem_w8_m5_g3" "problem_w4_m4_g2" "problem_w5_m3_g2" "problem_w5_m5_g2" "problem_w6_m4_g2" "problem_w7_m3_g2" "problem_w7_m5_g2" "problem_w8_m4_g2" "problem_w4_m4_g3" "problem_w5_m3_g3" "problem_w5_m5_g3" "problem_w6_m4_g3" "problem_w7_m3_g3" "problem_w7_m5_g3" "problem_w8_m4_g3")

# echo "${nt_prob[1]}" # test

# DONE!
# non adaptable free
# for j in `seq 0 29`;
#     do
#         call_exec_experiment_with_wait false iros_problems_free "${nt_prob[$j]}"
#     done

# non adaptable deadline
for j in `seq 0 8`;
    do
        call_exec_experiment_with_wait false iros_problems_deadlines "${t_prob[$j]}" domain_robot_delivery
    done

# adaptable free
for j in `seq 0 29`;
    do
        call_exec_experiment_with_wait true iros_problems_free "${nt_prob[$j]}" domain_robot_delivery
    done

# adaptable deadline
for j in `seq 0 8`;
    do
        call_exec_experiment_with_wait true iros_problems_deadlines "${t_prob[$j]}" domain_robot_delivery
    done
