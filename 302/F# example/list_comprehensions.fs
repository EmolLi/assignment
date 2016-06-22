let listofSquares n = [ for i in 1 .. n do yield i * i ]

let listofCubes n = [ for i in 1 .. n -> i * i * i]

let rec choose n m =
  if (m = 0) || (n = m) then 1
  else (choose (n - 1) (m - 1)) + (choose (n - 1) m)

let pascalRow n = [ for i in 0 .. n -> choose n i]

(* The examples below are written so you can see how to write longer examples
spread out over many lines. *)

let multiplesOf n =
  [
    for i in 1 .. 10 ->
      i * n
  ]

let l =
  [
    for i in 1 .. 20 do
      if i % 2 = 0 then
        yield -i
      else
        yield i
  ]


let primesUnder max =
  [
    for n in 2 .. max do
      let factorsOfN =
        [
          for i in 2 .. (n - 1) do
            if n % i = 0 then
              yield i
        ]
      if factorsOfN = [] then
        yield n
  ]

(* Results:

val choose : n:int -> m:int -> int
val pascalRow : n:int -> int list

> pascalRow 9;;
val it : int list = [1; 9; 36; 84; 126; 126; 84; 36; 9; 1]
> pascalRow 8;;
val it : int list = [1; 8; 28; 56; 70; 56; 28; 8; 1]
> 
val primesUnder : max:int -> int list

> primesUnder 100;;
val it : int list =
  [2; 3; 5; 7; 11; 13; 17; 19; 23; 29; 31; 37; 41; 43; 47; 53; 59; 61; 67; 71;
   73; 79; 83; 89; 97]
> 

*)
