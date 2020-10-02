(define (problem interference)
(:domain rush_to_school)

(:objects  
    left_arm - arm
    folded pregrasp - arm_posture
    kitchen bedroom - area
    teddy_bear - physobj
    false true - boolean
)

(:init
    (ArmPosture left_arm folded)
    (RobotAt kitchen)
    (Holding left_arm teddy_bear)
)

(:goal
  (and
    (RobotAt bedroom)
  )
)

)
