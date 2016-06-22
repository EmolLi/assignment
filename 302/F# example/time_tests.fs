(* This is how you turn on timing

> #time;;

--> Timing now on

*)

let lst = [1;2]

let rec wastetime n =
  match n with
    | 0 -> lst
    | _ -> let ys = n :: wastetime(n-1)
           List.rev ys;;

let rec fib n =
  match n with
    | 0 -> 1
    | 1 -> 1
    | _ -> fib(n-1) + fib(n-2);;

let tailfib n =
  let rec helper (n,a,b) =
    match n with
      | 0 -> a
      | 1 -> b
      | _ -> helper(n-1,b,a+b)
  helper(n,1,1);;

let rec naive_reverse l =
  match l with
    | [] -> []
    | x :: xs -> naive_reverse(xs) @ [x];;

let tfact n =
  let rec helper(n,m) =
    match n with
      | 0 -> m
      | _ -> helper(n-1,n*m)
  helper(n,1);;

let factW n =
  let ni = ref n
  let r = ref 1
  while (!ni > 0) do
    (r := !r * !ni); (ni := !ni - 1)
  !r;;

(* Timing examples

> wastetime 10000;;
Real: 00:00:01.131, CPU: 00:00:01.131, GC gen0: 187, gen1: 5
val it : int list =
  [9999; 9997; 9995; 9993; 9991; 9989; 9987; 9985; 9983; 9981; 9979; 9977;
   9975; 9973; 9971; 9969; 9967; 9965; 9963; 9961; 9959; 9957; 9955; 9953;
   9951; 9949; 9947; 9945; 9943; 9941; 9939; 9937; 9935; 9933; 9931; 9929;
   9927; 9925; 9923; 9921; 9919; 9917; 9915; 9913; 9911; 9909; 9907; 9905;
   9903; 9901; 9899; 9897; 9895; 9893; 9891; 9889; 9887; 9885; 9883; 9881;
   9879; 9877; 9875; 9873; 9871; 9869; 9867; 9865; 9863; 9861; 9859; 9857;
   9855; 9853; 9851; 9849; 9847; 9845; 9843; 9841; 9839; 9837; 9835; 9833;
   9831; 9829; 9827; 9825; 9823; 9821; 9819; 9817; 9815; 9813; 9811; 9809;
   9807; 9805; 9803; 9801; ...]
> Real: 00:00:00.000, CPU: 00:00:00.000, GC gen0: 0, gen1: 0

Pretty fast!

> > fib 20;;
Real: 00:00:00.000, CPU: 00:00:00.000, GC gen0: 0, gen1: 0
val it : int = 10946
> fib 30;;
Real: 00:00:00.008, CPU: 00:00:00.008, GC gen0: 0, gen1: 0
val it : int = 1346269
> fib 40;;
Real: 00:00:00.996, CPU: 00:00:00.996, GC gen0: 0, gen1: 0
val it : int = 165580141
> fib 50;;
  ^C ^C
- Interrupt I couldn't wait!
> fib 45;;
Real: 00:00:10.997, CPU: 00:00:10.997, GC gen0: 0, gen1: 0
val it : int = 1836311903

> > tailfib 40;;
Real: 00:00:00.000, CPU: 00:00:00.000, GC gen0: 0, gen1: 0
val it : int = 165580141
> tailfib 45;;
Real: 00:00:00.000, CPU: 00:00:00.000, GC gen0: 0, gen1: 0
val it : int = 1836311903
> tailfib 50;;
Real: 00:00:00.000, CPU: 00:00:00.000, GC gen0: 0, gen1: 0
val it : int = -1109825406

Fast but cannot handle big numbers with ordinary integers.

> > let result = naive_reverse [1 .. 10000];;
Real: 00:00:01.483, CPU: 00:00:01.483, GC gen0: 190, gen1: 6

val result : int list =
  [10000; 9999; 9998; 9997; 9996; 9995; 9994; 9993; 9992; 9991; 9990; 9989;
   9988; 9987; 9986; 9985; 9984; 9983; 9982; 9981; 9980; 9979; 9978; 9977;
   9976; 9975; 9974; 9973; 9972; 9971; 9970; 9969; 9968; 9967; 9966; 9965;
   9964; 9963; 9962; 9961; 9960; 9959; 9958; 9957; 9956; 9955; 9954; 9953;
   9952; 9951; 9950; 9949; 9948; 9947; 9946; 9945; 9944; 9943; 9942; 9941;
   9940; 9939; 9938; 9937; 9936; 9935; 9934; 9933; 9932; 9931; 9930; 9929;
   9928; 9927; 9926; 9925; 9924; 9923; 9922; 9921; 9920; 9919; 9918; 9917;
   9916; 9915; 9914; 9913; 9912; 9911; 9910; 9909; 9908; 9907; 9906; 9905;
   9904; 9903; 9902; 9901; ...]

> let r2d2 = List.rev [1 .. 10000];;
Real: 00:00:00.000, CPU: 00:00:00.000, GC gen0: 0, gen1: 0

val r2d2 : int list =
  [10000; 9999; 9998; 9997; 9996; 9995; 9994; 9993; 9992; 9991; 9990; 9989;
   9988; 9987; 9986; 9985; 9984; 9983; 9982; 9981; 9980; 9979; 9978; 9977;
   9976; 9975; 9974; 9973; 9972; 9971; 9970; 9969; 9968; 9967; 9966; 9965;
   9964; 9963; 9962; 9961; 9960; 9959; 9958; 9957; 9956; 9955; 9954; 9953;
   9952; 9951; 9950; 9949; 9948; 9947; 9946; 9945; 9944; 9943; 9942; 9941;
   9940; 9939; 9938; 9937; 9936; 9935; 9934; 9933; 9932; 9931; 9930; 9929;
   9928; 9927; 9926; 9925; 9924; 9923; 9922; 9921; 9920; 9919; 9918; 9917;
   9916; 9915; 9914; 9913; 9912; 9911; 9910; 9909; 9908; 9907; 9906; 9905;
   9904; 9903; 9902; 9901; ...]

Built in list reversal is very fast.

I computed 16! a million times and threw away the answer.  I used a tailrecursive
version and a familiar imperative version with a while loop.  The tail recursive
version was actually faster.

> > for i in 1 .. 1000000 do let _ = tfact(16) in ();;
Real: 00:00:00.022, CPU: 00:00:00.022, GC gen0: 0, gen1: 0
val it : unit = ()
> for i in 1 .. 1000000 do let _ = factW(16) in ();;
Real: 00:00:00.054, CPU: 00:00:00.054, GC gen0: 8, gen1: 0
val it : unit = ()

*)



             
let rec apply_list l=
  match l with
  | [] ->(fun x ->x)
  | f::fs -> (fun x -> apply_list(fs) (f x))