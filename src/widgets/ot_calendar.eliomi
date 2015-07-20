(* Ocsigen
 * http://www.ocsigen.org
 * Copyright (C) 2015
 * Jerome Vouillon and Vasilis Papavasileiou
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

   (** [make ?highlight ?click_any ?action] produces a calendar.

       If a client-side function [highlight] is provided, [highlight y
       m] should produce the list of days for the month [m] of the
       year [y] that need to be visually denoted.

       If [click_any] is [true], every date is clickable; otherwise,
       only the dates that [highlight] returns (if [highlight] is
       provided) are clickable.

       If a client-side function [action] is provided, when the user
       clicks on the date [d]:[m]:[y], [action d m y] is called. *)

val make :
  ?highlight :
    (int -> int -> int list Lwt.t) Eliom_lib.client_value ->
  ?click_any :
    bool ->
  ?action :
    (int -> int -> int -> unit) Eliom_lib.client_value ->
  unit ->
  [> Html5_types.table ] Eliom_content.Html5.elt

(** [make_date_picker ?init ()] returns a client-side reactive signal
    [(y, m, d)] corresponding to the date [d]:[m]:[y] that the user
    clicks on. The optional parameter [init] provides an initial value
    for the signal. *)

val make_date_picker :
  ?init : (int * int * int) ->
  unit ->
  [> Html5_types.table ] Eliom_content.Html5.F.elt *
  (int * int * int) Eliom_csreact.SharedReact.S.t

}}