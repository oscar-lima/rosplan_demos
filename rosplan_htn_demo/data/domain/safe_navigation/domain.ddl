(HybridHTNDomain safe_navigation)

(MaxArgs 5)

(PredicateSymbols
  armposture holding robotat
# Operators:
  !move_arm
  !move_base
# Methods
  drive
  adapt_arm
)

(Resource armManCapacity 1)

(StateVariable armposture 2 n)

################################
####  OPERATORS ################

# move_arm
(:operator
 (Head !move_arm(?arm ?newPosture ?keep_gripper_orientation))
 (Pre p1 armposture(?arm ?oldPosture))
 (Del p1)
 (Add e1 armposture(?arm ?newPosture))

 (ResourceUsage
    (Usage armManCapacity 1))

 (Constraint Duration[2000,INF](task))
)

# move_base
(:operator
 (Head !move_base(?toArea))
 (Pre p1 robotat(?fromArea))
 (Del p1)
 (Add e1 robotat(?toArea))
 (Constraint Duration[4000,INF](task))
)


### DRIVE
(:method    # already there
 (Head drive(?area))
  (Pre p1 robotat(?area))
  (Constraint During(task,p1))
)

# Robot is holding nothing: tuck arm
(:method
 (Head drive(?toArea))
 (Pre p0 holding(ur5 nothing))
 (Pre p1 robotat(?fromArea))
 (VarDifferent ?toArea ?fromArea)
 (Sub s1 adapt_arm(ur5 tucked))
 (Constraint Starts(s1,task))
 (Sub s2 !move_base(?toArea))
 (Ordering s1 s2)
 (Constraint Before(s1,s2))
)

# Robot is holding an object: move arm to transport pose
(:method
 (Head drive(?toArea))
 (Pre p0 holding(ur5 ?obj))
 (NotValues ?obj nothing)
 (Pre p1 robotat(?fromArea))
 (VarDifferent ?toArea ?fromArea)
 (Sub s1 adapt_arm(ur5 transport))
 (Constraint Starts(s1,task))
 (Sub s2 !move_base(?toArea))
 (Ordering s1 s2)
 (Constraint Before(s1,s2))
)

### adapt arm
(:method  # Arm already there. Nothing to do.
 (Head adapt_arm(?arm ?posture))
 (Pre p1 armposture(?arm ?posture))
 (Constraint During(task,p1))
)

# not holding an object: use_current_orientation_constraint=false
(:method
 (Head adapt_arm(?arm ?posture))
 (Pre p0 holding(ur5 ?obj))
 (Values ?obj nothing)
 (Pre p1 armposture(?arm ?currentposture))
 (VarDifferent ?posture ?currentposture)
 (Sub s1 !move_arm(?arm ?posture false))
 (Constraint Equals(s1,task))
)

# holding an object: use_current_orientation_constraint=true
(:method
 (Head adapt_arm(?arm ?posture))
 (Pre p0 holding(ur5 ?obj))
 (NotValues ?obj nothing)
 (Pre p1 armposture(?arm ?currentposture))
 (VarDifferent ?posture ?currentposture)
 (Sub s1 !move_arm(?arm ?posture true))
 (Constraint Equals(s1,task))
)

