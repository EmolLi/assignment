type Exptree =
  | Const of int
  | Var of char
  | Plus of Exptree * Exptree
  | Times of Exptree * Exptree

type Env = Map<char, int>

let e1 = Const 3
let e2 = Const 4
let e3 = Var 'x'
let e4 = Var 'y'
let e5 = Const 5
let e6 = Var 'z'
let e7 = Plus(e1, e2)
let e8 = Plus(e3, e5)
let e9 = Times(e6,e8)
let e10 = Plus(e9,e7)

let rec eval(e : Exptree, rho: Env) =
  match e with
  | Const n -> n
  | Var v -> Map.find v rho
  | Plus (e1, e2) ->
      let v1 = eval(e1,rho)
      let v2 = eval(e2,rho)
      v1 + v2
  | Times (e1, e2) ->
      let v1 = eval(e1,rho)
      let v2 = eval(e2,rho)
      v1 * v2

let rho: Env = Map.ofList [('x',11);('y',7);('z',2)]

let result = eval(e10,rho)

      
(* Binary Search Trees coded from scratch.  *)
type 'key bstree = Empty | Node of 'key * 'key bstree * 'key bstree

let rec find less x (t : 'key bstree) =
  match t with
    | Empty -> false
    | Node(y,left,right) -> 
        if (less(x,y)) then find less x left
        elif (less(y,x)) then find less x right
        else (* x = y *) true

let rec insert less x (t: 'key bstree) =
  match t with
    | Empty -> Node(x,Empty,Empty)
    | Node(y,left,right) as T ->
        if (less(x,y)) then Node(y,(insert less x left),right)
        elif (less(y,x)) then Node(y,left,(insert less x right))
        else (* x = y *) T (* do nothing, perhaps raise an exception? *)

exception EmptyTree

let rec deletemin (t: 'key bstree) =
  match t with
    | Empty -> raise EmptyTree
    | Node(y,Empty,right) -> (y,right)
    | Node(y,left,right) -> 
        let (z,L) = deletemin(left)
        (z,Node(y,L,right))


let rec delete less x (t: 'key bstree) =
  match t with
    | Empty -> raise EmptyTree
    | Node(y,left,right) ->
        if (less(x,y)) then Node(y,(delete less x left),right)
        elif (less(y,x)) then Node(y,left,(delete less x right))
        else (* x = y *)
          match (left,right) with
            |  (Empty,r) -> r 
            |  (l,Empty) -> l 
            |  (l,r) ->
               let (z,r1) = deletemin(r) in Node(z,l,r1)


let strLess(s1:string, s2) = s1 < s2

let tr1 = insert strLess "monkey" Empty 
let tr2 = insert strLess "donkey" tr1 
let tr3 = insert strLess "elephant" tr2 
let tr4 = insert strLess "chimpanzee" tr3 
let tr5 = insert strLess "aadvaark" tr4 
let tr6 = insert strLess "buffalo" tr5 
let tr7 = insert strLess "giraffe" tr6 
let tr8 = insert strLess "rhinocerous" tr7 
let tr9 = insert strLess "okapi" tr8 
let tr10 = insert strLess "zebra" tr9 
let tr11 = insert strLess "tiger" tr10






    
      
      
  
