From Coq Require Import Bool ssreflect ssrbool.
From elpi Require Import elpi.

Axiom is_even : nat -> Prop.

Fixpoint even n : bool :=
  match n with
  | O => true
  | S (S n) => even n
  | _ => false
  end.

Lemma evenP n : reflect (is_even n) (even n).
Admitted.

Lemma andP  {P Q : Prop} {p q : bool} :
  reflect P p -> reflect Q q ->
    reflect (P /\ Q) (p && q).
Admitted.

Lemma elimT {P b} :
  reflect P b -> b = true ->
    P.
Admitted.

Elpi Db tb.db lp:{{ 

pred tb i:term, o:term.

}}.

(*
% pi N \ tb {{ is_even lp:N }} {{ evenP lp:N }}.
% pi P Q PP PQ \ tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:PQ }} :-
%   tb P PP, tb Q PQ.
*)

Elpi Command register.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{

pred compile i:term, i:term, i:list prop, o:prop.
compile {{ reflect lp:S _ }} R Todo (tb S R :- Todo).
compile {{ reflect lp:S _ -> lp:Ty }} R Todo (pi h\ C h) :-
  pi h\ compile Ty {{ lp:R lp:h }} [tb S h|Todo] (C h).
compile {{ forall x, lp:(Ty x) }} R Todo (pi x\ C x) :-
  pi x\ compile (Ty x) {{ lp:R lp:x }} Todo (C x).

main [str S] :-
  coq.locate S GR,
  coq.env.typeof GR Ty,
  compile Ty (global GR) [] C,
  coq.elpi.accumulate _ "tb.db" (clause _ _ C).

}}.
Elpi Export register.

register andP.
register evenP.

Elpi Tactic to_bool.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{


solve (goal _ _ Ty _ _ as G) GL :-
  tb Ty P,
  refine {{ elimT lp:P _ }} G GL.

}}.

Lemma test : is_even 6 /\ is_even 4.
Proof.
  elpi to_bool.
  simpl.
  trivial.
Qed.
