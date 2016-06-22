type 'a tree = Empty | Node of 'a tree * 'a * 'a tree

let t1 = Node(Empty, 0, (Node(Empty, 1, Empty)))
let t2 = Node(Node(Empty,5,Empty),6,Empty)
let t3 = Node(Node(t2,2,Node(Empty,3,Empty)),4,t1)

let max (n,m) = if n < m then m else n

let rec height (t: 'a tree) =
  match t with
    |  Empty -> 0
    |  Node (l,_,r) -> 1 + max(height l, height r)

let rec sumNodes (t : int tree) = 
  match t with
    | Empty -> 0
    | Node(l,n,r) -> n + sumNodes(l) + sumNodes(r)

let showInt n = printf "%i\n" n

let rec inOrder (t: int tree) =
  match t with
    | Empty -> printf " "
    | Node(l,n,r) -> inorder(l); showInt n; inorder(r)

let rec preOrder (t: int tree) =
  match t with
    | Empty -> printf ""
    | Node(l,n,r) -> showInt n; preOrder(l); preOrder(r)

let rec postOrder (t: int tree) =
  match t with
    | Empty -> printf ""
    | Node(l,n,r) -> postOrder(l); postOrder(r); showInt n;

let isEmpty t =
  match t with
    | Empty -> true
    | _ -> false


let rec flatten (t: 'a tree) = 
  match t with
    | Empty -> []
    | Node(lft,v,rt) -> v::((flatten(lft))@(flatten(rt)))


