(define (domain mover-domainP)
  (:requirements :strips :typing :fluents :equality :conditional-effects :negative-preconditions)
  (:types 
    mover
    cell
  )
  (:functions
    (demand ?cell - cell) - number
  )

  (:predicates
    (link ?from_cell ?to_cell)
    (mover_at ?mover ?cell)
    (loaded_at ?mover ?cell)
    (loaded ?mover)
  )

  (:action load
    :parameters (?mover - mover ?from_cell - cell)
    :precondition
      (and
        (mover_at ?mover ?from_cell)
        (> (demand ?from_cell) 0)
        (not (loaded ?mover))
      )
    :effect
      (and
        (loaded ?mover)
        (loaded_at ?mover ?from_cell)
        (decrease (demand ?from_cell) 1)
      )
  )
     
  (:action haul
    :parameters (?mover - mover ?from_cell - cell ?to_cell - cell)
    :precondition
      (and
        (loaded ?mover)
        (mover_at ?mover ?from_cell)
        (link ?from_cell ?to_cell)
      )
    :effect
      (and
        (not (mover_at ?mover ?from_cell))
        (mover_at ?mover ?to_cell)
      )
  )

  (:action dump
    :parameters (?mover - mover ?dump_cell - cell)
    :precondition
      (and
        (loaded ?mover)
        (mover_at ?mover ?dump_cell)
      )
    :effect
      (and
        (not (loaded ?mover))
        (not (loaded_at ?mover ?dump_cell))
        (increase (demand ?dump_cell) 1)
      )
  )

  (:action move
    :parameters (?mover - mover ?from_cell - cell ?to_cell - cell)
    :precondition
      (and
        (not (loaded ?mover))
        (mover_at ?mover ?from_cell)
        (link ?from_cell ?to_cell)
      )
    :effect
      (and
        (mover_at ?mover ?to_cell)
        (not (mover_at ?mover ?from_cell))
      )
  )
)