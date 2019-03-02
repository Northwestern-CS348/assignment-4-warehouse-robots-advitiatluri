(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters(?src - location ?dest - location ?r - robot)
      :precondition (and (at ?r ?src) (no-robot ?dest) (free ?r) (connected ?src ?dest))
      :effect (and (at ?r ?dest) (no-robot ?src) (not (at ?r ?src)) (not (no-robot ?dest)))
   )
   
   (:action robotMoveWithPallette
      :parameters(?src - location ?dest - location ?r - robot ?p - pallette)
      :precondition (and (at ?r ?src) (at ?p ?src) (free ?r) (no-robot ?dest) (no-pallette ?dest) (connected ?src ?dest))
      :effect (and (at ?r ?dest) (at ?p ?dest) (no-robot ?src) (no-pallette ?src) (not (at ?r ?src)) (not (at ?p ?src)) (not (no-robot ?dest)) (not (no-pallette ?dest)))
   )
   
   (:action moveItemFromPalletteToShipment 
      :parameters(?l - location ?s - shipment ?o - order ?si - saleitem ?p - pallette)
      :precondition(and (contains ?p ?si) (at ?p ?l) (started ?s) (packing-at ?s ?l) (ships ?s ?o) (orders ?o ?si) (not (complete ?s)))
      :effect (and (includes ?s ?si) (not (contains ?p ?si)))
   )
   
   (:action completeShipment
      :parameters(?s - shipment ?o - order ?l - location)
      :precondition(and (ships ?s ?o) (packing-at ?s ?l) (started ?s) (not (available ?l)))
      :effect (and (complete ?s) (available ?l) (not(packing-at ?s ?l)) (not(started ?s)))
   )
)
