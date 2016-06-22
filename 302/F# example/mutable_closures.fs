type counter = { mutable i: int};;
let mutable a = 0;;
let flip0 () = (a <- (1 - a)); (printf "%i\n" a);;

let flip =
  let c:counter = { i = 0 }
  fun () -> (c.i <- 1 - c.i); (printf "%i\n" c.i);;

let flip2 =
  let c:counter = { i = 0 }
  fun () -> (c.i <- 1 - c.i); (printf "%i\n" c.i);;

let make_flipper = fun () ->
  let c:counter = { i = 0 }
  fun () -> (c.i <- 1 - c.i); (printf "%i\n" c.i)

(* Datatype of bank account transactions.*)
type transaction = Withdraw of int | Deposit of int | Checkbalance

(* Bank account generator. *)
let make_account(opening_balance: int) =
    let balance = ref opening_balance
    fun (t: transaction) ->
      match t with
        | Withdraw(m) ->  if (!balance > m)
                          then
                            balance := !balance - m
                            printfn "Balance is %i" !balance
                          else
                            printfn "Insufficient funds."
        | Deposit(m) -> (balance := !balance + m; (printf "Balance is %i\n" !balance))
        | Checkbalance -> (printf "Balance is %i\n" !balance);;


let morgoth = make_account(1000)

let sauron = make_account(500)

(* Monitoring *)
type 'a tagged = Query | Normal of 'a
type 'b answers = Numcalls of int | Ans of 'b

let makeMonitored f =
    let c = ref 0
    fun x ->
      match x with
        | Query -> (Numcalls !c)
        | (Normal y) -> ( c := !c + 1; (Ans (f y)));;

(* To avoid the value restriction we have to use a non-polymorphic version. *)
let monLength = makeMonitored (fun (l : int list) -> (List.length l));;

let inc n = n + 1

let moninc = makeMonitored(inc)

let taglist l = List.map (fun x -> Normal(x)) l







