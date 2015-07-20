(* Ocsigen
 * http://www.ocsigen.org
 * Copyright (C) 2015
 * Vasilis Papavasileiou
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, with linking exception;
 * either version 2.1 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*)

{shared{

module Html5 = Eliom_content.Html5
open Html5.D

type t = int * int * string array option

}}

{client{

module Eliom_lib = struct
  (* copied from Eliom_csreact ; find a proper place for this *)
  include Eliom_lib
  let create_shared_value _ x = x
end

let r_node a = Eliom_content.Html5.R.node a

}}

{server{ let r_node a = Eliom_csreact.R.node a }} ;;

{shared{

let display_aux (_, _, a) v =
  let v =
    match a with
    | Some a ->
      a.(v)
    | None ->
      string_of_int v
  and a = [a_class ["ot-r-value"]] in
  div ~a [pcdata v] }} ;;

{client{

   let go_up (lb, ub, a) r f =
     let v = Eliom_csreact.SharedReact.S.value r in
     assert (v <= ub - 1);
     f (if v = ub - 1 then lb else v + 1)

let go_down (lb, ub, a) r f =
  let v = Eliom_csreact.SharedReact.S.value r in
  assert (v >= lb);
  f (if v = lb then ub - 1 else v - 1)

}} ;;

{shared{

let display_aux e r =
  Eliom_csreact.React.S.map
    (Eliom_lib.create_shared_value (display_aux e) {{display_aux %e}})
    r |>
  r_node

let display
    ?txt_up:(txt_up = "up")
    ?txt_down:(txt_down = "down")
    e (v, f) =
  div ~a:[a_class ["ot-range"]]
    [div ~a:[a_class ["ot-r-up"];
             a_onclick {{ fun _ -> go_up %e %v %f }}]
       [pcdata txt_up];
     display_aux e v;
     div ~a:[a_class ["ot-r-down"];
             a_onclick {{ fun _ -> go_down %e %v %f }}]
       [pcdata txt_down]]

let make ?txt_up ?txt_down ?f ?lb:(lb = 0) ub =
  assert (ub > lb);
  let ((v, _) as rp) = Eliom_csreact.SharedReact.S.create lb
  and a =
    match f with
    | Some f ->
      let f i = f (i + lb) in
      Some (Array.init (ub - lb) f)
    | None ->
      None
  in
  display ?txt_up ?txt_down (lb, ub, a) rp, v

}}