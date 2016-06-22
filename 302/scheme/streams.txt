let nat = Seq.initInfinite (fun i -> i)

let cons x sigma = Seq.append (Seq.singleton x) sigma

let first sigma = Seq.nth 0 sigma

let rest sigma = Seq.skip 1 sigma

let rec prefix (n: int) sigma = 
  if (n = 0) then []
  else (first sigma) :: (prefix (n - 1) (rest sigma))

let rec numsFrom n = cons n (Seq.delay (fun () -> (numsFrom (n + 1))))

let idWithPrint n = (printfn "%i" n); n

let natWithPrint = Seq.initInfinite idWithPrint

let natWPCached = Seq.cache natWithPrint

let divides n m = (m % n) = 0

let rec sieve sigma =
  Seq.delay (fun () -> 
                 let head = first sigma 
                 cons head (sieve (Seq.filter (fun n -> (n % head) <> 0) (rest sigma))))

let primes = sieve (numsFrom 2)

let rec addStreams s1 s2 = Seq.delay (fun () -> cons ((first s1) + (first s2))
                                                      (addStreams (rest s1) (rest s2)))

let rec psums sigma = 
  Seq.delay (fun () -> cons (first sigma) (addStreams (psums sigma) (rest sigma)))

let ones = Seq.initInfinite (fun i -> 1)

let yaNats = psums ones

let rec fibs = Seq.delay (fun () -> cons 1 (cons 1 (addStreams fibs (rest fibs))))

let rec pascal = Seq.delay (fun () -> cons ones (Seq.map psums pascal))

let triangular = Seq.cache (psums nat)

let showrow n ss =
  let rec helper n ss acc =
    if n = 0 then acc
    else 
       helper (n - 1) (rest ss) ((Seq.nth (n - 1) (first ss))::acc)
  helper n ss []
