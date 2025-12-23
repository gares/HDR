From Coq Require Import Bool ssreflect ssrbool.
From elpi Require Import elpi.
Set Printing Coercions.

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

(* #region to_bool *)
(* tactic *)(*.*)
Elpi Tactic to_bool.
Elpi Accumulate lp:{{

% [tb P R] finds R : reflect P p
pred tb i:term, o:term.
tb {{ is_even lp:N }} {{ evenP lp:N }} :- !.
tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :- tb P PP, tb Q QQ, !.
tb Ty _ :- coq.error "Cannot solve" {coq.term->string Ty}.

solve (goal _ _ Ty _ _ as G) GL :-
  tb Ty P,
  refine {{ elimT lp:P _ }} G GL.

}}.
(* #endregion *)
(* tactic *)(*.*)

Lemma test : is_even 6 /\ is_even 4.
Proof.
  elpi to_bool.
  simpl.
  trivial.
Qed.

(* 6 minutes *)