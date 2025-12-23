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

Elpi Db tb.db lp:{{

% [tb P R] finds R : reflect P B
pred tb i:term, o:term.

}}.

Elpi Tactic to_bool.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{

solve (goal _ _ Ty _ _ as G) GL :-
  tb Ty P,
  refine {{ elimT lp:P _ }} G GL.

}}.

Elpi Command register_tb.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{

% evenP : forall n, reflect (is_even n) (even N).
%
% tb {{ is_even lp:N }} {{ evenP lp:N }}.
%
% pi N\ tb {{ is_even lp:N }} {{ evenP lp:N }} :- [].

% andP : forall P Q p q, reflect P p -> reflect Q q ->
%                           reflect (P /\ Q) (p && q).
%
% tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :-
%   tb P PP, tb Q QQ.
%
% pi P Q PP QQ\
%   tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :-
%     [tb P PP, tb Q QQ].

}}.
Elpi Export register_tb.

register_tb evenP.
register_tb andP.

(* Elpi Print to_bool "Demo.snippets/to_bool". *)

Lemma test : is_even 6 /\ is_even 4.
Proof.
  elpi to_bool.
  simpl.
  trivial.
Qed.

