let x = 1 in
  let y = 2 in
    x + y;;

let x = 1 in
  let x = 2 in
    x + x;;

let x = 1 in
  let x = 2 in
  printf "x is %i\n" x;;

let x = 1 in
  let y = x in
    let x = 2 in
      x + y;;

let result =
  let x = 1
  let y = x
  let x = 2
  y


(* The first interesting example.  The function remembers the definition of x!  *)
let result2 =
  let x = 1 in
  let f = fun u -> (printf "Inside f, x is %i\n" x);(u + x) in
  let x = 2 in
  (printf "x is %i\n" x);f x

(* Lightweight syntax. *)
let result3 =
  let x = 1
  let f = fun u -> (u + x)
  let x = 2
  f x
  
let result4 =
  let x = 1
  let y = let x = 3 in x
  (printf "x is %i\n" x); let x = 2  in (printf "Now x is %i\n" x);y;;


let x = 1 in
  let y = (let u = 3 in u + x) in
    let x = 2 in
    x + y;;

let x = 1 in
  let f = (let u = 3 in (fun y -> u + y + x)) in
    let x = 2 in
    f x;;

 
  




  
  

  
    
    
