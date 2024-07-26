;; Earthmoving domain
(define (domain mover-domainP)
  (:requirements :strips :typing :fluents :equality :conditional-effects :negative-preconditions)
  (:types 
    mover ;; the excavator/hauler
    cell
    ;demand
  ) ;; the cell
  (:functions
    (demand ?cell - cell) - number
  )

  (:predicates
    ;; there is access from from-cell to to-cell or not
    (link ?from_cell ?to_cell)
    ;; mover is at cell or not
    (mover_at ?mover ?cell)
    ;; mover is loaded at cell or not
    (loaded_at ?mover ?cell)
    ;; mover is loaded or not
    (loaded ?mover)
  )

 (:action load
    :parameters (?mover - mover ?from_cell - cell)
    :precondition
      (and
        ;; mover at the cell
        (mover_at ?mover ?from_cell)
        ;; the cell is a cut cell
        (> (demand ?from_cell) 0)
        ;; the mover is not loaded
        (not (loaded ?mover))
      )
    :effect
      (and
        ;; load the mover
        (loaded ?mover)
        ;; record the loading pit
        (loaded_at ?mover ?from_cell)
        ;; update demand, load one unit
        (decrease (demand ?from_cell) 1)
      )
  )
     
  (:action haul
    :parameters (?mover - mover ?from_cell - cell ?to_cell - cell)
    :precondition
      (and
        (loaded ?mover) ;; mover is loaded
        (mover_at ?mover ?from_cell) ;; mover at current cell
        (link ?from_cell ?to_cell) ;; connection between cells
      )
    :effect
      (and
        (not (mover_at ?mover ?from_cell)) ;; mover not at current cell
        (mover_at ?mover ?to_cell) ;; mover relocated to destination cell
      )
  )

  (:action dump
    :parameters (?mover - mover ?dump_cell - cell)
    :precondition
      (and
        (loaded ?mover) ;; mover is loaded
        (mover_at ?mover ?dump_cell) ;; mover relocated to destination cell
        ;(= (demand ?dump-cell) 1) ;; demand at dump cell is negativo
      )
    :effect
      (and
        (not (loaded ?mover)) ;; mover becomes unloaded
        (not (loaded_at ?mover ?dump_cell))
        ;(increase (demand ?dump-cell) 1) ;; decrease demand at dump cell
        )
  )

 (:action move
    :parameters (?mover - mover ?from_cell - cell ?to_cell - cell)
    :precondition
      (and
        (= (demand ?from_cell) 0)   ;; mover is not loaded
        ;(when (= (demand ?from_cell) 0))   ;; mover is not loaded        
        (not (loaded ?mover))
        ;; mover is at current cell
        (mover_at ?mover ?from_cell)
        ;; Access between from-cell to to-cell
        (link ?from_cell ?to_cell)
             
      ) 
    :effect
      (and
        ;; mover relocated to destination cell
        (mover_at ?mover ?to_cell)
        ;; mover not at current cell
        (not (mover_at ?mover ?from_cell))
        )
      )
    
)
