(define (domain minimal_chimp_demo)

(:requirements :strips :fluents :typing :durative-actions)


(:types
    arm
    arm_posture
    area
    physobj
    boolean
)

(:constants
    ur5 - arm
    tucked - arm_posture
    false true - boolean
)


(:predicates
    (ArmPosture ?arm - arm ?posture - arm_posture)
    (RobotAt ?area - area)
    (Holding ?arm - arm ?obj - physobj)
)


(:durative-action move_arm
    :parameters (?arm - arm ?oldPosture ?newPosture - arm_posture ?keep_gripper_orientation - boolean)
    :duration (= ?duration 2)
    :condition (and 
        (at start (ArmPosture ?arm ?oldPosture))
    )
    :effect (and 
        (at start (not (ArmPosture ?arm ?oldPosture)))
        (at end (ArmPosture ?arm ?newPosture))
    )
)

(:durative-action move_base
    :parameters (?fromArea ?toArea - area)
    :duration (= ?duration 4)
    :condition (and 
        (at start (RobotAt ?fromArea))
    )
    :effect (and 
        (at start (not (RobotAt ?fromArea)))
        (at end (RobotAt ?toArea))
    )
)

)
