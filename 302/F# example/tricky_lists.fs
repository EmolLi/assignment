let psums lst =
  let rec helper l a =
    match l with
      | [] -> [a]
      | x ::xs -> a :: (helper xs (x + a))
  match lst with
    | [] -> [0]
    | x :: xs -> helper xs x

let smash ll = List.fold (@) [] ll

let rec inter item lst =
  match lst with
    | [] -> [[item]]
    | x :: xs -> (item :: lst) :: (List.map (fun u -> (x:: u)) (inter item xs))

let rec perms l =
  match l with
    | [] -> [[]]
    | x::xs -> smash (List.map (fun u -> (inter x u)) (perms xs))
