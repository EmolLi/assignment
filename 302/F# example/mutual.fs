let rec f = 
  let c = ref 0
  fun n -> if (n%2 = 1) then (c := !c + 1);(printfn "Inside f c is: %i" !c)
           else g(n)
and g =
  let c = ref 0
  fun n -> if (n%2 = 0) then (c := !c - 1); (printfn "Entered g c is: %i" !c)
           else f (n);;
(*
val f : (int -> unit)
val g : (int -> unit)

> > f 4;;
Entered g c is: -1
val it : unit = ()
> g 3;;
Inside f c is: 1
val it : unit = ()
> g 2;;
Entered g c is: -2
val it : unit = ()
> f 3;;
Inside f c is: 2
val it : unit = ()

*)
