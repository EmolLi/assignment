module hw4

(* Assignment 4 *) (* Do not edit this line. *)
(* Student name: Duan Li, Id Number: 260683698 *) (* Edit this line. *)


type typExp =
  | TypInt
  | TypVar of char
  | Arrow of typExp * typExp
  | Lst of typExp

type substitution = (char * typExp) list

(* check if a variable occurs in a term *)
//match tau with four possible types
//check if v exists in the type expression
let rec occurCheck (v: char) (tau: typExp) : bool = 
    match tau with
    | TypInt -> false
    | TypVar a -> if (v=a) then true
                  else false
    | Arrow (typExp1, typExp2) -> (occurCheck v typExp1) || (occurCheck v typExp2) //any shortcut? like avoiding the second if the first is true?
    | Lst (typExp1) -> occurCheck v typExp1

(* substitute typExp tau1 for all occurrences of type variable v in typExp tau2 *)
let rec substitute (tau1 : typExp) (v : char) (tau2 : typExp) : typExp =
    match tau2 with
    | TypInt -> tau2
    | TypVar a -> if (v=a) then tau1
                  else tau2
    | Arrow (typExp1, typExp2) -> Arrow ((substitute tau1 v typExp1) , (substitute tau1 v typExp2))
    | Lst (typExp1) -> Lst (substitute tau1 v typExp1)    

let applySubst (sigma: substitution) (tau: typExp) : typExp =
    List.fold (fun acc (v:char, tau1:typExp) -> substitute tau1 v acc) tau sigma
 
 
   // repeat oneTime (List.length sigma) tau          
 //   let rec repeat f n=
   //   if (n=0) then fun x->x
     // else fun x->f (repeat f (n-1) x)
 //   let oneTime tau2 = List.fold (fun acc (v:char, tau1:typExp) -> substitute tau1 v acc) tau2 sigma
   // repeat oneTime (List.length sigma) tau                                            

(* This is a one-line program *)

let unify (tau1: typExp) (tau2:typExp) : substitution =
    let rec helper tau1 tau2 =
        match tau1 with
        | TypInt -> match tau2 with
                    | TypInt -> [] //what if there is no type variable?
                    | TypVar a -> [(a, TypInt)]
                    | _ -> failwith "Clash in principal type constructor"
        | TypVar a -> match tau2 with
                      | TypInt -> [(a, TypInt)]
                      | TypVar b -> [(a, TypVar b)]
                      | t -> if (occurCheck a t) then failwith "Failed occurs check"
                             else [a, t]
        | Arrow (typExp1, typExp2) -> match tau2 with
                                      | TypVar a -> if (occurCheck a tau1) then failwith "Failed occurs check"
                                                    else [(a, tau1)]
                                      | Arrow (typExpa, typExpb) -> let x = helper typExp1 typExpa
                                                                    x@(helper (applySubst x typExp2) (applySubst x typExpb))
                                      | _ -> failwith "Clash in principal type constructor"
        | Lst (typExp1) -> match tau2 with
                           | TypVar a ->  if (occurCheck a tau1) then failwith "Failed occurs check"
                                          else [(a, tau1)]
                           | Lst (typExpa) -> helper typExp1 typExpa 
                           | _ -> failwith "Clash in principal type constructor"
    let l1 = helper tau1 tau2 
    //check other errors        
    List.iter(fun (a, t) -> List.iter (fun (b,c) -> if (a=b) then 
                                                      try  helper t c |> ignore
                                                      with Failure(msg) -> failwith "Not unifiable"
                                                   
                                                     ) l1) l1
    l1


   // List.map(fun (a,t) -> match t with
     //                     | TypVar v -> let n = List.tryFind (fun (a2, t2) -> ((a2=v)&& (not (t2 = t)))) l1
       //                                 match n with
         //                               | None -> (a,t)
           //                             | Some ((a2, t2)) -> (a, t2)
             //             | _ -> (a, t))l1
                         

(* Use the following signals if unification is not possible:

 failwith "Clash in principal type constructor"
 failwith "Failed occurs check"
 failwith "Not unifiable"

*)


(*

> let te4 = Prod(TypInt, Arrow(TypVar 'c', TypVar 'a'));;

val te4 : typExp = Prod (TypInt,Arrow (TypVar 'c',TypVar 'a'))

> let te3 = Prod (TypVar 'a',Arrow (TypVar 'b',TypVar 'c'));;

val te3 : typExp = Prod (TypVar 'a',Arrow (TypVar 'b',TypVar 'c'))

> unify te3 te4;;
val it : substitution = [('c', TypInt); ('b', TypVar 'c'); ('a', TypInt)]
> let result = it;;

val result : substitution = [('c', TypInt); ('b', TypVar 'c'); ('a', TypInt)]

> applySubst result te3;;
val it : typExp = Prod (TypInt,Arrow (TypInt,TypInt))
> applySubst result te4;;
val it : typExp = Prod (TypInt,Arrow (TypInt,TypInt))

*)


    

    
(*

> let te4 = Prod(TypInt, Arrow(TypVar 'c', TypVar 'a'));;

val te4 : typExp = Prod (TypInt,Arrow (TypVar 'c',TypVar 'a'))

> let te3 = Prod (TypVar 'a',Arrow (TypVar 'b',TypVar 'c'));;

val te3 : typExp = Prod (TypVar 'a',Arrow (TypVar 'b',TypVar 'c'))

> unify te3 te4;;
val it : substitution = [('c', TypInt); ('b', TypVar 'c'); ('a', TypInt)]
> let result = it;;

val result : substitution = [('c', TypInt); ('b', TypVar 'c'); ('a', TypInt)]

> applySubst result te3;;
val it : typExp = Prod (TypInt,Arrow (TypInt,TypInt))
> applySubst result te4;;
val it : typExp = Prod (TypInt,Arrow (TypInt,TypInt))

*)


  
