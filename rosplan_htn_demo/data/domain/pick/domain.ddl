(HybridHTNDomain safe_navigation)

(MaxArgs 5)

(PredicateSymbols
  arm_posture holding robot_at
  on                            # ?obj ?obj_area
  reachable_from                # ?obj_area ?drive_area
  recognized                    # ?robot_area ?obj
# Operators:
  move_arm
  move_base
  grasp_object
  recognize_object
# Methods
  drive
  adapt_arm
  get
)

(Resource arm_man_capacity 1)

(StateVariable arm_posture 2 n)

################################
####  OPERATORS ################

# move_arm
(:operator
 (Head move_arm(?arm ?old_posture ?new_posture ?keep_gripper_orientation))
 (Pre p1 arm_posture(?arm ?old_posture))
 (Del p1)
 (Add e1 arm_posture(?arm ?new_posture))

 (ResourceUsage
    (Usage arm_man_capacity 1))

 (Constraint Duration[2000,INF](task))
)

# move_base
(:operator
 (Head move_base(?from_area ?to_area))
 (Pre p1 robot_at(?from_area))
 (Del p1)
 (Add e1 robot_at(?to_area))
 (Constraint Duration[4000,INF](task))
)

# recognize_object
(:operator
 (Head recognize_object(?robot_area ?obj))
 (Pre p1 robot_at(?robot_area))
 (Add e1 recognized(?obj))
 (Constraint Duration[1000,INF](task))
)


# grasp_object
(:operator
 (Head grasp_object(?arm ?obj ?obj_area))
 (Pre p1 on(?obj ?obj_area))
 (Pre p2 holding(?arm nothing))
 (Pre p3 recognized(?obj))
 #(Pre p3 reachable_from(?obj_area ?robot_area))
 #(Pre p4 arm_posture(?arm ?oldPosture))
 (Del p1)
 (Del p2)
 (Del p3)
 #(Del p4)
 (Add e1 holding(?arm ?obj))
 #(Add e2 arm_posture(?arm undefined))

 (Constraint OverlappedBy(task,p1))
 (Constraint OverlappedBy(task,p2))
 (Constraint Meets(p2,e1))
 #(Constraint Meets(p4,e2))
 (Constraint Duration[4000,INF](task)) # TODO update duration

 (ResourceUsage
    (Usage arm_man_capacity 1))
)


### DRIVE
(:method    # already there
 (Head drive(?area))
  (Pre p1 robot_at(?area))
  (Constraint During(task,p1))
)

# Robot is holding nothing: tuck arm
(:method
 (Head drive(?to_area))
 (Pre p0 holding(ur5 nothing))
 (Pre p1 robot_at(?from_area))
 (VarDifferent ?to_area ?from_area)
 (Sub s1 adapt_arm(ur5 home))
 (Constraint Starts(s1,task))
 (Sub s2 move_base(?from_area ?to_area))
 (Ordering s1 s2)
 (Constraint Before(s1,s2))
)

# Robot is holding an object: move arm to transport pose
(:method
 (Head drive(?to_area))
 (Pre p0 holding(ur5 ?obj))
 (NotValues ?obj nothing)
 (Pre p1 robot_at(?from_area))
 (VarDifferent ?to_area ?from_area)
 (Sub s1 adapt_arm(ur5 transport))
 (Constraint Starts(s1,task))
 (Sub s2 move_base(?from_area ?to_area))
 (Ordering s1 s2)
 (Constraint Before(s1,s2))
)

### adapt arm
(:method  # Arm already there. Nothing to do.
 (Head adapt_arm(?arm ?posture))
 (Pre p1 arm_posture(?arm ?posture))
 (Constraint During(task,p1))
)

# not holding an object: use_current_orientation_constraint=false
(:method
 (Head adapt_arm(?arm ?posture))
 (Pre p0 holding(ur5 ?obj))
 (Values ?obj nothing)
 (Pre p1 arm_posture(?arm ?currentposture))
 (VarDifferent ?posture ?currentposture)
 (Sub s1 move_arm(?arm ?old_posture ?posture false))
 (Constraint Equals(s1,task))
)

# holding an object: use_current_orientation_constraint=true
(:method
 (Head adapt_arm(?arm ?posture))
 (Pre p0 holding(ur5 ?obj))
 (NotValues ?obj nothing)
 (Pre p1 arm_posture(?arm ?currentposture))
 (VarDifferent ?posture ?currentposture)
 (Sub s1 move_arm(?arm ?old_posture ?posture true))
 (Constraint Equals(s1,task))
)


# get the object
(:method
 (Head get(?obj))
 (Pre p0 on(?obj ?obj_area))
 (Pre p1 reachable_from(?obj_area ?drive_area))
 (Sub s1 drive(?drive_area))
 (Sub s2 recognize_object(?drive_area ?obj))
 (Sub s3 grasp_object(ur5 ?obj ?obj_area))
 (Ordering s1 s2)
 (Ordering s2 s3)
 (Constraint Before(s1,s2))
 (Constraint Before(s2,s3))
)
