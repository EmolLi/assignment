(* Assignment 1 *) (* Do not edit this line. *)
(* Student name: Duan Li, Id Number: 260683698 *) (* Edit this line. *)

(* In the template below we have written the names of the functions that
you need to define.  You MUST use these names.  If you introduce auxiliary
functions you can name them as you like except that your names should not
clash with any of the names we are using.  We have also shown the types
that you should have.  Your code must compile and must not go into infinite
loops.  *)

(* Question 1 *) (* Do not edit this line. *)

(* val sumlist : l:float list -> float *)
let rec sumlist l = 
    match l with
    | [] -> 0.0
    | x::xs -> x + (sumlist xs)


(* val squarelist : l:float list -> float list *)
let rec squarelist l:float list =  
    match l with
    | [] -> []
    | x::xs -> x*x :: squarelist xs


(* val mean : l:float list -> float *)
let mean l = 
    (sumlist l)/float l.Length

(* val mean_diffs : l:float list -> float list *)
let mean_diffs l = 
    let u = mean l
    List.map (fun x -> abs(x-u)) l

    
(* val variance : l:float list -> float *)
let variance l = 
    l
    |> mean_diffs
    |> List.map(fun x -> x*x)
    |> List.sum   
    |> fun x -> x/ float l.Length                  



(* End of question 1 *) (* Do not edit this line. *)

(* Question 2 *) (* Do not edit this line. *)

(* val memberof : 'a * 'a list -> bool when 'a : equality *)
let rec memberof (x:'a, y:'a list) : bool = 
    match y with 
    | [] -> false
    | z::zs -> if z=x then true
               else memberof (x, zs)  

(* val remove : 'a * 'a list -> 'a list when 'a : equality *)
let rec remove (x:'a, y:'a list) : 'a list =
    match y with
    | [] -> []
    | z::zx -> if z=x then remove (x, zx)
               else z::remove (x, zx) 

(* End of question 2 *) (* Do not edit this line *)

(* Question 3 *) (* Do not edit this line *)

(* val isolate : l:'a list -> 'a list when 'a : equality *)
let rec isolate l: 'a list = 
    match l with
    | [] -> []
    | x::xs -> if memberof (x, xs) then isolate xs
               else x::isolate xs

(* End of question 3 *) (* Do not edit this line *)

(* Question 4 *) (* Do not edit this line *)




(* val common : 'a list * 'a list -> 'a list when 'a : equality *)
let rec common (la: 'a list, lb: 'a list): 'a list =           
    match la with
    | [] -> []
    | x::xs -> if  memberof (x, lb) && ( not (memberof (x, xs))) then x::common (xs, lb)
               else common (xs, lb)

(* End of question 4 *) (* Do not edit this line *)

(* Question 5 *) (* Do not edit this line *)

(* val split : l:'a list -> 'a list * 'a list *)
let rec split (l:'a list)= 
    match l with
    | [] -> ([],[])
    | x::[] -> ([x],[])
    | x::y::xs -> let (A,B) = split (xs)
                  (x::A, y::B)

(* val merge : 'a list * 'a list -> 'a list when 'a : comparison *)
let rec merge (A: 'a list, B: 'a list) : 'a list = 
    match A with
    | [] -> B
    | x::xs -> 
              match B with
              | [] -> A
              | y::yx -> if x<y then x::merge(xs, B)
                         else y::merge(A, yx)

(* val mergesort : l:'a list -> 'a list when 'a : comparison *)
let rec mergesort (l: 'a list) :'a list = 
    match l with
    | [] -> []
    | x::[] -> [x]
    | x::xs ->
              let (A,B)= split l
              let A1 = mergesort A
              let A2 = mergesort B
              merge (A1, A2)


(* End of question 5 *) (* Do not edit this line *)

