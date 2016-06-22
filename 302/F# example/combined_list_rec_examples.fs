let liszt = [1; 2; 3; 4; 5]

let liszt2 = [11; 12; 13; 14; 15]

(* These are discouraged.  Use pattern-matching instead.  *)
let v = liszt.Head

let t = liszt.Tail

let rec badzip (l1,l2) =
  if l1 = [] then l2
  else
    (l1.Head)::(badzip (l2,l1.Tail))

let foo = badzip(liszt,liszt2)
    

(* The pattern matching version. *)

let rec zip (l1,l2) =
  match l1 with
  | [] -> l2
  | x:: xs -> x :: zip(l2,xs)

let l1 = [1 .. 17]

let l2 = [1 .. 2 .. 17]

let l3 = [37 .. -5 .. 2]

let rec succPairs = function
  | x0 :: x1 :: xs -> (x0,x1) :: succPairs(x1::xs)
  | _ -> []


(* One gets an error if one writes (x0,x1) :: (succPairs x1::xs).  *)
let rec succPairs2 = function
  | x0 :: (x1:: _ as xs) -> (x0,x1) :: succPairs2(xs)
  | _ -> []
  
let rec unzip l =
  match l with
  | [] -> ([],[])
  | (a1,a2) :: ps ->
  let (L,R) = unzip(ps) in
      (a1::L,a2::R)

      
let rec isMember x = function
  | y ::ys -> (x = y) || (isMember x ys)
  | [] -> false
  
let isMember2 x = fun l -> (List.exists (fun a -> (a = x)) l)

let rec zip(l1,l2) = 
    match (l1,l2) with 
    | ([],l2) -> l2
    | (l1,[]) -> l1
    | (x :: xs, y :: ys) -> x :: (y :: (zip(xs,ys)))

let rec remove(a,l) =
  match l with 
  |        [] -> []
  |   x :: xs -> if (x = a) then remove(a, xs) else x::(remove(a,xs))


let rec remDup lst =
  match lst with
  | []  -> []
  | x :: xs -> x::(remove(x,remDup(xs)))

let rec insert n lst =
  match lst with
  | [] -> [n]
  | x :: xs -> if (n < x) then n:: lst else x::(insert n xs)

let rec isort lst =
  match lst with
  | [] -> []
  | x :: xs -> insert x (isort xs)
