(define (domain skip_door)

(:requirements :strips :typing :fluents :durative-actions :timed-initial-literals)

(:types
	robot
	door
	waypoint
)

(:predicates

	(robot_at ?r - robot ?wp - waypoint)
	(connected ?wp1 ?wp2 - waypoint)
	(door_at ?d - door ?wp - waypoint)
	(door_is_open ?d - door)
)

(:durative-action navigate
	:parameters (?r - robot ?origin ?dest - waypoint ?dorigin ?ddest - door)
	:duration ( = ?duration 1)
	:condition (and
					(at start (robot_at ?r ?origin))
					(at start (connected ?origin ?dest))

					(over all (door_at ?dorigin ?origin))
				    (over all (door_at ?ddest ?dest))

					(over all (door_is_open ?dorigin))
			   )
	:effect (and
				(at start (not (robot_at ?r ?origin)))
				(at end (robot_at ?r ?dest))
		    )
)

(:durative-action open_door
	:parameters (?r - robot ?wp - waypoint ?door - door)
	:duration ( = ?duration 1)
	:condition (and
					(at start (robot_at ?r ?wp))
					(over all (door_at ?door ?wp))
			   )
	:effect (and
				(at end (door_is_open ?door))
		    )
)

)
