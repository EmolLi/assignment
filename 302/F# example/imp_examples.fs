let mutable x = 1

(* This is forbidden:
let change (mutable n: int) = n <- n + 1
*)

let munge (n:int) =
  let mutable m = n
  (m <- m + 1);;

let mess_with () = x <- x + 1

let result = (printfn "x is %i" x); (mess_with ()); x

let mash (n:int) =
  let mutable m = n
  (printfn "m is %i" m);(m <- m + 1); (printfn "n is %i" n); (printfn "m is %i" m); m

let foo n =
  let mutable x = n in     
    while (x < 10) do (printfn "x is %i" x);(x <- x + 1)

(* Basic record syntax . *)

type Person = { name : string ; birthday : int * int; title : string }

let prakash = { name = "Prakash"; birthday = (3,11); title = "Lord of all he surveys"}


type intRec = { mutable count : int }

let r1 = { count = 0}

let increment (counter: intRec) =
  counter.count <- counter.count + 1
  counter.count;;

(* Using ref, :=, ! *  Run these and explain what happens. *)

let x = ref 1
let y = x
let incr n = (n := !n + 1)
incr x
!x
!y
let z = ref (!y)
incr z
!z
!y

(* Here is what happened:

val x : int ref = {contents = 1;}
val y : int ref = {contents = 1;}
val incr : n:int ref -> unit
> val it : unit = ()
> val it : int = 2
> val it : int = 2

val z : int ref = {contents = 2;}

> val it : unit = ()
> val it : int = 3
> val it : int = 2

*)
  
  
