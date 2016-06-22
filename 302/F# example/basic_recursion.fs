let rec fact n = if n = 0 then 1 else n * fact(n-1)

(* The previous definition of fact uses a stack.  The solution below is
in tail-recursive form which means that a stack is not needed.  The recursive call
is outermost here. *)
let rec fastfact(n,m) = if n = 0 then m else fastfact(n-1,n * m)

(* The above requires you to call the function with the second argument initialized to 1.
The version below packages the iterative factorial inside as a helper function and
ensures that it can only be called with the second argument set to 1. *)
let iterfact n = 
  let rec helper(x,y) =
    if x = 0 then y
    else
    helper(x-1,x*y)
  helper(n,1)


let rec rpe(b,power) =
  if (b = 0) then 0
  elif (power = 0) then 1
  elif (power = 1) then b
  elif (power % 2 = 1) then b * rpe(b,power-1)
  else 
    let temp = rpe(b, power/ 2) in
      temp * temp









    


  
  
