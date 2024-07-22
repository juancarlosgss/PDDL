(define (problem mover-single)
  (:domain mover-domainP)
  (:objects
    mover1 - mover
    cell1 cell2 cell3 - cell
  )
  (:init
    (= (demand cell1) -1)
    (= (demand cell2) 0)
    (= (demand cell3) 1)
    (link cell2 cell1)
    (link cell2 cell3)
    (link cell3 cell2)
    (mover_at mover1 cell3)
  )
  (:goal
    (and
      (= (demand cell1) 0)
      (= (demand cell2) 0)
      (= (demand cell3) 0)
      (mover_at mover1 cell1)
    )
  )
)