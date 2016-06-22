let norm (x:float, y:float):float = sqrt(x * x + y * y)

let list_of_points = [(1.0,0.0); (0.7071,0.7071); (0.0,1.0)]

let sumOfNorms plist =
  List.fold (fun s (x,y) -> s + norm(x,y)) 0.0 plist
