module hw3

(* Assignment 3 *) (* Do not edit this line. *)
(* Student name: Duan Li, Id Number: 260683698 *) (* Edit this line. *)

(* Question 1 *)
type Cell = { data : int; next : RList}
and RList = Cell option ref

(* For testing.  Uncomment if you want to use them. 
let c1 = {data = 1; next = ref None}
let c2 = {data = 2; next = ref (Some c1)}
let c3 = {data = 3; next = ref (Some c2)}
let c5 = {data = 5; next = ref (Some c3)}
*)

(* This converts an RList to an ordinary list. *)
let rec displayList (c : RList) =
  match !c with
    | None -> []
    | Some { data = d; next = l } -> d :: (displayList l)

(* This may be useful.  You don't have to use it.*)
let cellToRList (c:Cell):RList = ref (Some c)

(* Example for testing. *)
let bigger(x:int, y:int) = (x > y)

let rec insert comp (item: int) (list: RList) = 
    match !list with
    | None -> list := Some {data = item; next = ref None}
    | Some { data = d; next = l } -> if (comp (item, d)) then 
                                        let newnext = { data = d; next = l}
                                        list := Some {data = item; next = ref (Some newnext)}
                                     else insert comp item l
 
 
 
 
 
 //   let rec helper comp item list =
   //     match !list with
     //   | None -> cellToRList {data = item; next = ref None}
       // | Some ({ data = d; next = l }:Cell) ->
          //                              if (comp (item, d)) then cellToRList {data = item; next = list}
            //                            else cellToRList {data = d; next = helper comp item l} 
    //list := !(helper comp item list)

    //Why StackOverflowException????
                                    



(* Question 2*)

type transaction = Withdraw of int | Deposit of int | CheckBalance

let make_protected_account(opening_balance: int,password: string) =
      let balance = ref opening_balance
      fun (p: string, t: transaction) ->
        if not (p = password) then printfn "Incorrect password."    
        else 
          match t with
          | Withdraw(m) -> if (!balance >= m) then
                             balance := !balance - m
                             printfn "Balance is %i\n" !balance
                           else 
                             printfn "Insufficient funds."
          | Deposit(m) -> balance := !balance + m
                          printf "Balance is %i\n" !balance
          | CheckBalance -> printf "Balance is %i\n." !balance
(* Question 3 *)

open System.Collections.Generic;;

type ListTree<'a> = Node of 'a * (ListTree<'a> list)

let bfIter f ltr = 
    let todo = Queue<ListTree<'a>> ()
    todo.Enqueue(ltr)
    while (todo.Count>0) do
      let (Node (x, list)) = todo.Dequeue()
      f x
      List.iter (fun x -> todo.Enqueue(x)) list
       


        

(*   This is how you set up a new Queue: let todo = Queue<ListTree<'a>> () *)

(* For testing.  Uncomment if you want to use them. 
let n5 = Node(5,[])
let n6 = Node(6,[])
let n7 = Node(7,[])
let n8 = Node(8,[])
let n9 = Node(9,[])
let n10 = Node(10,[])
let n12 = Node(12,[])
let n11 = Node(11,[n12])
let n2 = Node(2,[n5;n6;n7;n8])
let n3 = Node(3,[n9;n10])
let n4 = Node(4,[n11])
let n1 = Node(1,[n2;n3;n4])
*)


(* How I tested the BFS program.   
bfIter (fun n -> printfn "%i" n) n1;;

*)

    






        


        

      
