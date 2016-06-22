(* The basic list operations are "cons" written as :: which adds an element to the front of
a list and "append", written @ which combines two lists.  Lists in Fsharp are homogenous
and immutable.
*)

let vowels = ['a';'e';'i';'o';'u']

let vowels2 = 'y' :: vowels

(* What if we want to add y at the end? vowels :: 'y' gives a type error. *)

let vowels3 = vowels @ ['y']
(* We had to make 'y' into a list (of length 1) by writing ['y]. *)

let odds = [1 .. 2 .. 19]
let evens = [2 .. 2 .. 20]

(* Our own append function. It is O(n), unlike cons which is O(1). *)
let rec myappend l1 l2 = 
  match l1 with
  | [] -> l2
  | x :: xs -> x :: (myappend xs l2)


(* Reverse done naively.  This is O(n^2). *)
let rec reverse l = 
  (match l with    
  | [] -> []
  | x::xs -> (reverse xs) @ [x])


(* Better reverse using an accumulating parameter. This is O(n). *)
let rev l = 
  let rec helper(l,acc) = 
    match l with
    | [] -> acc
    | x :: xs -> helper(xs, x::acc)
  helper(l,[])
  


(* Some built in functions: List.length, List.head, List.tail, List.rev, List.zip.
The built in zip is not the same as my zip function.  It can take lists of different types
but they must have the same length.  *)
let pairs = List.zip odds evens

(* More interesting functions; these take functions as arguments. *)
(* These are all provided in Fsharp as primitives. *)

let rec mymap f l = 
  match l with
    | [] -> []
    | x :: xs -> f(x) :: (mymap f xs)


let inc = function n -> n + 1
let allnums n = [1 .. n]
let test = mymap inc (allnums 13)

let rec myfilt tester lst = 
  match lst with
  | [] -> []
  | x :: xs ->
  if (tester x) then x :: (myfilt tester xs)
  else myfilt tester xs


let oddval n = (n % 2) = 1
let test2 = myfilt oddval (allnums 17)

(* Now a search function.  But what if the item is not there?  Introducing option types.*)
let rec search item lst = 
  match lst with
  | [] -> None
  | x :: xs ->
  if (x = item) then (Some x)
  else search item xs


(* This version of reduce is provided in Fsharp. *)

let rec myreduce op lst = 
  match lst with
  | [] -> failwith "List argument cannot be empty"
  | x :: [] -> x
  | x :: xs -> op x (myreduce op xs)


(* I like this better.  It takes an identity element for the operation. *)

let rec good_reduce op iden lst = 
  match lst with
  | [] -> iden
  | x :: xs -> op x (good_reduce op iden xs)

(* 
val good_reduce : op:('a -> 'b -> 'b) -> iden:'b -> lst:'a list -> 'b
*)
(* > good_reduce (+) 0 (allnums 5);; 
val it : int = 15 
> good_reduce mult 1 (allnums 5);;
val it : int = 120
> let cons a b = a :: b;;
val cons : a:'a -> b:'a list -> 'a list
> let app3 a b = good_reduce cons b a;;
val app3 : a:'a list -> b:'a list -> 'a list
> app3 odds evens;;
val it : int list =
  [1; 3; 5; 7; 9; 11; 13; 15; 17; 19; 2; 4; 6; 8; 10; 12; 14; 16; 18; 20]
*)

(* Fold in Fsharp.  More powerful than reduce.
> List.fold;;
val it : (('a -> 'b -> 'a) -> 'a -> 'b list -> 'a) = <fun:clo@98-2>
*)

(* Example taken from Chris Smith's book. *)

let countVowels (str:string) =
  let charList = List.ofSeq str

  let accFunc (As, Es, Is, Os , Us) letter =
    if   letter = 'a' then (As + 1, Es, Is, Os, Us)
    elif letter = 'e' then (As, Es + 1, Is, Os, Us)
    elif letter = 'i' then (As, Es, Is + 1, Os, Us)
    elif letter = 'o' then (As, Es, Is, Os + 1, Us)
    elif letter = 'u' then (As, Es, Is, Os, Us + 1) 
    else                   (As, Es, Is, Os, Us)

  List.fold accFunc (0,0,0,0,0) charList;;
    
(* 
val countVowels : str:string -> int * int * int * int * int

> countVowels "Double double toil and trouble, Fire burn and cauldron bubble.";;
val it : int * int * int * int * int = (3, 5, 2, 5, 6)
*)










                 


  
  
  
  
  
