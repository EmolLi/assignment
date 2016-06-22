let rec sumInts(a,b) = if (a > b) then 0 else a + sumInts(a+1,b)

let rec sumSquares(a,b) = if (a > b) then 0 else (a*a) + sumSquares(a+1,b)

let rec sumCubes(a,b) = if (a > b) then 0 else (a*a*a) + sumCubes(a+1,b)

let rec sum(f,a,b) =
  if (a > b) then 0 else (f a) + sum(f,a+1,b)

let square n = n * n
let cube n = n * n * n

let rec sum_inc(f,a,b,inc) =
    if (a > b) then 0
    else (f a) + sum_inc(f, (inc a), b, inc)

let byTwo n = n + 2

let rec product(f,a,b,inc) =
    if (a > b) then 1
    else (f a) * product(f, (inc a), b, inc)

let id x = x
let inc n = n + 1
product(id, 1, 5, inc)

let acc(comb,f,a,b,inc,init) =
  let rec helper(a, res) =
    if (a > b) then res
    else helper (inc(a), comb(res, f(a)))
  helper(a,init)

let test = acc((fun (x,y) -> x + y),(fun n -> n * n), 1,5,(fun m -> m + 1),0);;

(* Doubler and self-application. *)
let twice f = fun x -> f (f x)

let inc n = n + 1

let fourtimes f = (twice twice) f

let compose(f,g) = fun x -> g(f(x))

(* Some examples from calculus. *)
let deriv (f, dx:float) = fun x -> ((f(x + dx) - f(x))/dx)

let abs(x:float) = if (x < 0.0) then ~x else x
let close(x:float,y:float,tol:float) = (abs(x-y) < tol)
let square(x:float) = x*x

let rec halfint(f,pos_value:float,neg_value:float,epsilon:float) =
  let mid = (pos_value + neg_value)/2.0
  if (abs(f(mid)) < epsilon)
  then
    mid
  elif (f(mid) < 0.0)
  then
    halfint(f,pos_value,mid,epsilon)
  else
    halfint(f,mid,neg_value,epsilon);;


let rec iter_sum(f, lo:float, hi:float, inc) =
  let rec helper(x:float, result:float) =
    if (x > hi) then result
    else helper(inc(x), f(x) + result)
  helper(lo,0.0);;

let integral(f,lo:float,hi:float,dx:float) =
  let delta (x:float) = x+dx
  dx * iter_sum(f,(lo + (dx/2.0)), hi, delta)

let r_sq (x:float):float = x * x

integral(r_sq,0.0,1.0,0.001)

integral(sin,0.0, 3.14159, 0.001)


