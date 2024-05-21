let mulN : int ref = ref 0 

let ( <*> ) a b = 
  mulN := !mulN + 1;
  a * b

let reset_counter() = mulN := 0

let pow_fast base exp md =
  let rec as_string = function
    | [] -> "\n" | [e] -> Printf.sprintf "%3d" e
    | e::es -> (Printf.sprintf "%4d" e) ^ ", " ^ as_string es 
  in
  let rec list_of_exps acc = match acc with 
    | _ when acc > exp -> []
    | _ -> acc :: list_of_exps (acc * 2)
  in
  let gen_row1 r = List.rev @@ List.fold_left 
    (fun (h::acc) _ -> ((h <*> h) mod md)::h::acc) [base] (List.tl r)
  in
  let rec gen_bits acc n = match n with
    | 0 -> []
    | _ -> [acc land 1] @ gen_bits (acc lsr 1) (n-1)
  in
  let gen_raw3 r bits = List.rev @@ snd @@ List.fold_left2
    (fun (acc, all) e b -> 
      match b with
      | 0 -> (acc, (acc::all))
      | _ -> let x = (b <*> (e <*> acc)) mod md in (x, (x::all)) 
    ) (1, []) r bits
  in
  let row0 = list_of_exps 1                  in
  let row2 = gen_row1 row0                   in
  let row3 = gen_bits exp (List.length row0) in
  let row5 = gen_raw3 row2 row3              in
  List.iter (fun r -> r |> as_string |> print_endline) [row0; row2; row3; row5];
  List.rev row5 |> List.hd

let do_pow base exp md =
  Printf.printf "--------------------------\n";
  Printf.printf "%d ^ %d mod %d\n" base exp md;
  Printf.printf "Result         : %d\n" (pow_fast base exp md);
  Printf.printf "Multiplications: %d\n\n" !mulN;
  reset_counter()

let _ =
  do_pow 1 511 10;
  do_pow 1 512 10;
  do_pow 5 701 11;
  do_pow 3 800 13;
  do_pow 16 2003 123;