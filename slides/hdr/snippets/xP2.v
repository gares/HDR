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
% [tb P R] finds R : reflect P p
pred tb i:term, o:term.

:name "tb:fail"
tb Ty _ :- coq.error "Cannot solve" {coq.term->string Ty}.

}}.

Elpi Tactic to_bool.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{

solve (goal Ctx _ Ty _ _ as G) GL :-
  tb Ty P,
  refine {{ elimT lp:P _ }} G GL.

}}.

Elpi Command add_tb.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{

% evenP : forall n, reflect (is_even n) (even N).
%
% tb {{ is_even lp:N }} {{ evenP lp:N }}.
%
% pi N\ tb {{ is_even lp:N }} {{ evenP lp:N }} :- [].

% andP : forall P Q p p, reflect P p -> reflect Q q ->
%                           reflect (P /\ Q) (p && q).
%
% tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :-
%   tb P PP, tb Q QQ.
%
% pi P Q PP QQ\
%   tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :-
%     [tb P PP, tb Q QQ].

pred compile i:term, i:term, i:list prop, o:prop.
compile {{ reflect lp:Ty _ }} P Hyps (tb Ty P :- Hyps).
compile {{ reflect lp:S _ -> lp:T }} P Hyps (pi h\ C h) :-
  pi h\
    compile T {{ lp:P lp:h }} [tb S h|Hyps] (C h).
compile {{ forall x, lp:(T x) }} P Hyps (pi h\ C h) :-
  pi x\
    compile (T x) {{ lp:P lp:x }} Hyps (C x).
    
main [str S] :-
  coq.locate S GR,
  coq.env.typeof GR Ty,
  compile Ty (global GR) [] C,
  coq.elpi.accumulate _ "tb.db" (clause _ (before "tb:fail") C).

}}.

Elpi add_tb evenP.
Elpi add_tb andP.

Elpi Print to_bool "Demo.snippets/to_bool".


Lemma test : is_even 6 /\ is_even 4.
elpi to_bool.
simpl.
trivial.
Qed.
