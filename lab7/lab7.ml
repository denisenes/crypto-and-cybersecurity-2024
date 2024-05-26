let mulN : int ref = ref 0 

let ( <*> ) a b = 
  mulN := !mulN + 1;
  a * b

let reset_counter() = mulN := 0

let pow_fast base exp md =
  let rec list_of_exps acc = match acc with 
    | _ when acc > exp -> []
    | _ -> acc :: list_of_exps (acc * 2)
  in
  let [@warning "-8"] gen_row1 r = List.rev @@ List.fold_left
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
  if exp = 0 then 1 else
  let row0 = list_of_exps 1                  in
  let row2 = gen_row1 row0                   in
  let row3 = gen_bits exp (List.length row0) in
  let row5 = gen_raw3 row2 row3              in
  List.rev row5 |> List.hd

let log_fast y a p =
  Printf.printf "Fast solution for %d^x = %d mod %d\n" a y p;
  let rec small_as_string = function
    | [] -> "\n" | [(_, e)] -> Printf.sprintf "%d" e
    | (_, e)::es -> (Printf.sprintf "%d" e) ^ ", " ^ small_as_string es
  in
  let m = int_of_float (sqrt @@ float_of_int p) + 1 in
  let k = m + 1 in
  assert (m * k > p);
  let rec gen_small acc = function
  | i when i = m -> []
  | i            -> (i, acc) :: gen_small ((acc <*> a) mod p) (i + 1)
  in
  let smalls = gen_small y 0 in
  print_string "Small steps: ";
  smalls |> small_as_string |> print_endline;
  let a_m = pow_fast a m p in
  let rec solve acc = function
  | i when i = k + 1 -> None
  | i -> 
    let big_step = acc in
    Printf.printf "%d) big step: %d\n" i big_step;
    match List.find_opt (fun (j, small_step) -> big_step = small_step) smalls with
    | None -> solve ((acc <*> a_m) mod p) (i + 1)
    | Some (jj, ss) -> Some ((i <*> m) - jj)
  in
  solve a_m 1

let log_slow y a p =
  Printf.printf "Slow solution for %d^x = %d mod %d\n" a y p;
  let rec log_slow0 = function
  | i when i = p -> None
  | i when pow_fast a i p = y -> Some i
  | i -> log_slow0 (i + 1)
  in log_slow0 0

let do_test logf y a p =
  reset_counter();
  match logf y a p with
  | None -> print_string "Didn't find solution"
  | Some v -> Printf.printf "Solution: %d\nMultiplications: %d\n\n" v !mulN

let _ =
  do_test log_slow 9 2 23;
  do_test log_slow 122 79 263;
  do_test log_slow 450470 667 1234567;
  do_test log_fast 9 2 23;
  do_test log_fast 122 79 263;
  do_test log_fast 450470 667 1234567