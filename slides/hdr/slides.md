---
# You can also start simply with 'default'
theme: neversink
color: rocq
# random image from a curated Unsplash collection by Anthony
# like them? see https://unsplash.com/collections/94734566/slidev
# background: https://cover.sli.dev
# some information about your slides (markdown enabled)
title: "Elpi: rule-based extension language"
info: |
  ## Slidev Starter Template
  Presentation slides for developers.

  Learn more at [Sli.dev](https://sli.dev)
# apply unocss classes to the current slide
class: text-center
# https://sli.dev/features/drawing
drawings:
  persist: false
# slide transition: https://sli.dev/guide/animations.html#slide-transitions
# enable MDC Syntax: https://sli.dev/features/mdc
mdc: true
layout: cover
ximage: logo.png
transition: fade
level: 2
hideInToc: true
---

# Elpi: rule-based extension language

<style>
  tr { border-style: none; padding-top: 0.1rem; padding-bottom: 0.1rem; }
  td { border-style: none; padding-top: 0.1rem; padding-bottom: 0.1rem; text-align: left !important; }
</style>
<table><tbody>
<tr ><td style="text-align: right !important;">Candidate:</td><td>Enrico Tassi</td></tr>
<tr ><td style="text-align: right !important;">Jury:</td><td>Catherine Dubois, Professeur, ENSIIE </td></tr>
<tr ><td ></td><td>Dale Miller, Directeur de Recherche, Inria</td></tr>
<tr ><td ></td><td>Brigitte Pientka, Full Professor, McGill University</td></tr>
<tr ><td ></td><td>Alberto Momigliano, Associate Professor, University of Milan</td></tr>
<tr ><td ></td><td>Christine Paulin-Mohring, Professeur, Université Paris-Saclay</td></tr>
<tr ><td ></td><td>Yves Bertot, Directeur de Recherche, Inria</td></tr>
</tbody></table>

<div style="text-align: right !important;">HDR 9/1/2026</div>


<!--
First of all thanks the orga
-->

---
layout: default
title: The title
level: 2
---

# Elpi: [rule-based]{style="background-color: var(--highlight-one)"} [extension language]{style="background-color: var(--highlight-two)"}

<br/>

## [context]{style="background-color: var(--highlight-two)"} &nbsp; extension language (for an ITP written in OCaml)

<!--- no such a thing as general purpose PL-->
- there is a *host application* and a *host programming language*
- the opposite of "general purpose" programming language

## [the key]{style="background-color: var(--highlight-one)"} &nbsp; rule-based

- binders
- context
- scheduling
- self extension


---
layout: center
level: 2
---

# This talk
<br/>

<Toc minDepth="1" maxDepth="1" />



---
layout: section
color: rocq
---

# The host application

---
layout: image
image: coq-brain.svg
title: The arcitecture of an ITP
backgroundSize: 40%
#transition: slide-left
level: 2
---

# The architecture of an ITP

---
title: The elaborator
level: 2
---

# The elaborator...

<style>
  tr { border-style: none; padding-top: 0rem; padding-bottom: 0rem; }
  td { border-style: none; padding-top: 0rem; padding-bottom: 0rem; text-align: left !important; }
</style>

<v-clicks>
<table>
<tbody>
<tr><td> 

$\lambda x.x + 1$

</td></tr>
<tr><td>

$\lambda x :~ ?_T.~ \mathrm{add~} x~ (S~ O)$

</td><td>

$\Sigma = \{\; ?_T \mapsto \mathrm{some~ type} \;\}$

</td></tr>
<tr><td>

$\lambda x :~ ?_T.~ \mathrm{add~} ?_s~ x~ (S~ O)$

</td><td>

$\Sigma = \{\; ?_T \mapsto \mathrm{some~ type};  \qquad\quad\;\;?_s \mapsto \mathrm{some~ record} \;\}$

</td><td><mdi-database-search/></td></tr>
<tr><td>

$\lambda x :~ ?_T.~ \mathrm{add~} ?_{s[x]}~ x~ (S~ O)$

</td><td>

$\Sigma = \{\; ?_T \mapsto \mathrm{some~ type}; \;x :~?_T \vdash ?_s \mapsto \mathrm{some~ record} \;\}$

</td><td><mdi-database-search/></td></tr>
<tr><td>

$\lambda \;\, :~ ?_T.~ \mathrm{add~} ?_{s[\$1]}~ \$1~ (S~ O)$

</td><td>

$\Sigma = \{\; ?_T \mapsto \mathrm{some~ type}; \;\;\,\; :~?_T \vdash ?_s \mapsto \mathrm{some~ record} \;\}$

</td><td><mdi-database-search/></td></tr>
</tbody></table>
</v-clicks>

# ...and its daemons

<v-clicks at="2">

- holes (pointers in a heap)
- ... and to be filled by user-given rules (database)

</v-clicks>

<v-clicks at="4">

- reduction/substitution (scope)
- binders (De Bruijn indexes)

</v-clicks>

<!--
- <v-click at="2">holes: pointers <mdi-biohazard/></v-click>
- <v-click at="4">reduction/substitution <mdi-bottle-tonic-skull/></v-click>
- <v-click at="5">binders: numbers <mdi-bomb/></v-click>
-->



---
layout: section
color: rocq
---

# The language in a nutshell

---
layout: two-cols-header
level: 2
---

# Elpi: Hello World!

::left::

Simply typed $\lambda$-calculus in HOAS

<<< @/snippets/stlc.elpi#types elpi

Typing


````md magic-move

<<< @/snippets/stlc.elpi#of elpi
<<< @/snippets/stlc.elpi#of1 elpi
<<< @/snippets/stlc.elpi#of2 elpi
<<< @/snippets/stlc.elpi#of elpi


````

<br/>
<br/>
<br/>

::right::

````md magic-move {at:1}

```elpi
goal> of (lam x\ lam y\ x) TyFst.
```

```elpi
goal> of (lam x\ lam y\ x) (arr S0 T0).
goal> of        (lam y\ c) T0.
```

```elpi
goal> of (lam x\ lam y\ x) (arr S0 (arr S1 T1)).
goal> of        (lam y\ c) (arr S1 T1).
goal> of                c  T1.
```

```elpi
goal> of (lam x\ lam y\ x) TyFst.

Success:
  TyFst = arr S0 (arr S1 S0)
```

```elpi
goal> of (app H A) T.

Failure.
```

````

---
layout: two-cols-header
level: 2
---

# Elpi = $\lambda$Prolog + CHR

::left::

Typing (as before)

<<< @/snippets/stlc.elpi#of elpi

Holes & constraints

<<< @/snippets/stlc.elpi#cst elpi

<v-click at="6">
Constraint Handling Rules

<<< @/snippets/stlc.elpi#chr elpi
</v-click>

<br/>
<br/>
<br/>


::right::

````md magic-move
```elpi
goal> of (app H A) T.
```

```elpi
goal> of (app H A) T.

Success:

Constraints:
  of A S  /* suspended on A */
  of H (arr S T)  /* suspended on H */
```

```elpi
goal> of (app H A) T, H = (lam x\ x).

Success:

Constraints:
  of A T  /* suspended on A */
```

```elpi
goal> of (app (lam x\ x) A) T.

Success:

Constraints:
  of A T  /* suspended on A */
```

```elpi
goal> of (app D D) T.
```

```elpi
goal> of (app D D) T.

Success:

Constraints:
  of D S  /* suspended on D */
  of D (arr S T)  /* suspended on D */
```

```elpi
goal> of (app D D) T.

Failure
```
````


---
layout: image
image: chr.png
level: 2
backgroundSize: 50%
---

# Elpi = $\lambda$Prolog + CHR


---
layout: section
color: rocq
---

# The integration in Rocq


---
layout: image-right
image: readme.png
backgroundSize: 80%
transition: fade
level: 2
---

# Notable features

- HOAS for Gallina
- quotations and anti-quotations

  ![Quotations](/quote.png "quote")

- Databases of rules
- Extensive API

  ![API example](/api.png "api")


---
layout: two-cols-header
transition: fade
level: 2
---

# Integration with Rocq: from Prop to bool (1/3)

:: left ::

````md magic-move

```coq
Inductive is_even : nat -> Prop := ...

Fixpoint even (n : nat) : bool := ...

Lemma evenP n : reflect (is_even n) (even n).


Lemma andP  {P Q : Prop} {p q : bool} :
  reflect P p -> reflect Q q ->
    reflect (P /\ Q) (p && q).


Lemma elimT {P b} : reflect P b -> b = true -> P.

Lemma test : is_even 6 /\ is_even 4.
Proof.
  refine (elimT (andP (evenP 6) (evenP 4)) _).


  (* even 6 && even 4 = true *)
  simpl. trivial.
Qed.
```

```coq
Inductive is_even : nat -> Prop := ...

Fixpoint even (n : nat) : bool := ...

Lemma evenP n : reflect (is_even n) (even n).


Lemma andP  {P Q : Prop} {p q : bool} :
  reflect P p -> reflect Q q ->
    reflect (P /\ Q) (p && q).


Lemma elimT {P b} : reflect P b -> b = true -> P.

Lemma test : is_even 6 /\ is_even 4.
Proof.
  (* refine (elimT (andP (evenP 6) (evenP 4)) _). *)
  to_bool.

  (* even 6 && even 4 = true *)
  simpl. trivial.
Qed.
```

````

:: right ::

---
layout: two-cols-header
transition: fade
level: 2
---

# Integration with Rocq: from Prop to bool (2/3)

:: left ::

```coq
Inductive is_even : nat -> Prop := ...

Fixpoint even (n : nat) : bool := ...

Lemma evenP n : reflect (is_even n) (even n).


Lemma andP  {P Q : Prop} {p q : bool} :
  reflect P p -> reflect Q q ->
    reflect (P /\ Q) (p && q).


Lemma elimT {P b} : reflect P b -> b = true -> P.

Lemma test : is_even 6 /\ is_even 4.
Proof.
  (* refine (elimT (andP (evenP 6) (evenP 4)) _). *)
  to_bool.

  (* even 6 && even 4 = true *)
  simpl. trivial.
Qed.
```

:: right ::

```coq
(* [tb P R] finds R : reflect P _ *)
Elpi Tactic to_bool.
Elpi Accumulate lp:{{
  func tb term -> term.
  tb {{ is_even lp:N }} {{ evenP lp:N }}.
  tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :- tb P PP, tb Q QQ.

  solve (goal _ _ Ty _ _ as G) GL :-
    tb Ty P, refine {{ elimT lp:P _ }} G GL.              }}.
```


---
layout: two-cols-header
transition: fade
level: 2
---

# Integration with Rocq: from Prop to bool (3/3)

:: left ::

```coq
Inductive is_even : nat -> Prop := ...
Fixpoint even (n : nat) : bool := ...

Lemma evenP n : reflect (is_even n) (even n).
add_tb evenP.
(* tb {{ is_even lp:N }} {{ evenP lp:N }} *)

Lemma andP  {P Q : Prop} {p q : bool} :
  reflect P p -> reflect Q q ->
    reflect (P /\ Q) (p && q).
add_tb andP.
(* tb {{ lp:P /\ lp:Q }} {{ andP lp:PP lp:QQ }} :- 
     tb P PP, tb Q QQ. *)

Lemma elimT {P b} : reflect P b -> b = true -> P.
Lemma test : is_even 6 /\ is_even 4.
Proof.
  (* refine (elimT (andP (evenP 6) (evenP 4)) _). *)
  to_bool.

  (* even 6 && even 4 = true *)
  simpl. trivial.
Qed.
```

:: right ::

```coq
(* [tb P R] finds R : reflect P _ *)
Elpi Db tb.db lp:{{ func tb term -> term. }}.

Elpi Tactic to_bool.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{
  solve (goal _ _ Ty _ _ as G) GL :-
    tb Ty P, refine {{ elimT lp:P _ }} G GL.              }}.

Elpi Command add_tb.
Elpi Accumulate Db tb.db.
Elpi Accumulate lp:{{
  func compile term, term, list prop -> prop.
  compile {{ reflect lp:P _ }} R Todo (tb P R :- Todo).
  compile {{ reflect lp:S _ -> lp:Ty }} R Todo (pi h\C h) :- 
    pi h\ compile Ty {coq.mk-app R [h]} [tb S h|Todo] (C h).
  compile {{ forall x, lp:(Ty x) }} R Todo (pi x\ C x) :-
    pi x\ compile (Ty x) {coq.mk-app R [x]} Todo (C x).

  main [str S] :-
    coq.locate S GR,
    coq.env.typeof GR Ty,
    compile Ty (global GR) [] C,
    coq.elpi.accumulate _ "tb.db" (clause _ _ C).        }}.

```


---
layout: section
color: rocq
---

# The good company

https://github.com/rocq-community/metaprogramming-rosetta-stone

---
transition: fade
zoom: 0.75
level: 2
---

# Comparison

<table>

<thead>
<tr style="border-bottom-width: 4px"> <th></th> <th>Elpi</th> <th>Ltac2</th> <th>MetaRocq</th> </tr>
</thead>
<tbody>

<tr> <td>Gallina</td>
  <td>
    <icon-park-twotone-pie-seven/>
    <br/><small>no mutual fix/ind</small>
  </td>
  <td>
    <icon-park-twotone-round/>
  </td>
  <td>
    <icon-park-twotone-round/>
  </td>
</tr>

<tr> <td>Bound Variables</td>
  <td>
    <icon-park-twotone-round/>
  </td>
  <td>
    <icon-park-twotone-pie-three/>
    <br/><small>quotations</small>

  </td>
  <td>
    <icon-park-twotone-pie-one/>
    <br/><small>toplevel quotation</small>
  </td>
</tr>

<tr style="border-bottom-width: 4px"> <td>Holes</td>
  <td>
    <icon-park-twotone-round/>
  </td>
  <td>
    <icon-park-twotone-pie-five/>
    <br/><small>tactic monad</small>

  </td>
  <td>
    <icon-park-twotone-pie-one/>
    <br/><small>only AST</small>
  </td>
</tr>

<tr> <td>Proof API</td>
  <td>
    <icon-park-twotone-pie-four/>
    <br/><small>weak ltac1 bridge</small>
  </td>
  <td>
    <icon-park-twotone-round/>
    <br/><small>(sufficiently close)</small>
  </td>
  <td>
    <icon-park-twotone-pie-one/>
    <br/><small>only TC search, obligations</small>
  </td>
</tr>

<tr style="border-bottom-width: 4px"> <td>Vernacular API</td>
  <td>
    <icon-park-twotone-pie-seven/>
    <br/><small>no notations, obligations</small>
  </td>
  <td>
    <material-symbols-circle-outline/>
  </td>
  <td>
    <icon-park-twotone-pie-three/>
    <br/><small>only env, obligations</small>
  </td>
</tr>

<tr style="border-bottom-width: 4px"> <td>Elaborator API</td>
  <td>
    <icon-park-twotone-pie-six/>
    <br/><small>no error locations</small>
  </td>
  <td>
    <material-symbols-circle-outline/>
  </td>
  <td>
    <material-symbols-circle-outline/>
  </td>
</tr>


<tr style="border-bottom-width: 4px"> <td>Reasoning logic</td>
  <td>
    <icon-park-twotone-pie-one/>
    <br/><small>Abella</small>
  </td>
  <td>
    <material-symbols-circle-outline/>
  </td>
  <td>
    <icon-park-twotone-pie-six/>
    <br/><small>no holes, unif</small>
  </td>
</tr>

</tbody>
</table>

To the best of my knowledge, on 1/1/2026 {style="text-align:center"}


---
layout: section
color: rocq
---

# What makes me proud


---
layout: two-cols-header
level: 2
---

# Hierarchy Builder

<div class="authors">

![CohenCyril](/avatars/CohenCyril.jpg)
![pi8027](/avatars/pi8027.jpg)
![gares](/avatars/gares.jpg)
![proux01](/avatars/proux01.jpg)
![ThomasPortet](/avatars/ThomasPortet.jpg)
![affeldt-aist](/avatars/affeldt-aist.jpg)
<!--
![FissoreD](/avatars/FissoreD.jpg)
![SkySkimmer](/avatars/SkySkimmer.jpg)
![thery](/avatars/thery.jpg)
![Tvallejos](/avatars/Tvallejos.jpg)
![VojtechStep](/avatars/VojtechStep.jpg)
![ybertot](/avatars/ybertot.jpg)
-->

</div>

DSL to declare a hierarchy of interfaces

:: left ::

* generates boilerplate via Elpi's API: modules, implicit arguments, canonical structures, ... 
* used by the Mathematical Components library and other ~20 libraries
* makes "packed classes" easy

  ![MC](/hb_intf.png "number of interfaces"){style="width: 80%"}

  2017
  <span style="width:8em; display:inline-block"/>
  2022
  <span style="width:2em; display:inline-block"/>
  2024

:: right ::

```coq
From HB Require Import structures.

HB.mixin Record IsAddComoid A := {
  zero : A;
  add : A -> A -> A;
  addrA : forall x y z, add x (add y z) = add (add x y) z;
  addrC : forall x y, add x y = add y x;
  add0r : forall x, add zero x = x;
}.

HB.structure Definition AddComoid := { A of IsAddComoid A }.

Notation "0" := zero.
Infix "+" := add.

Check forall (M : AddComoid.type) (x : M), x + x = 0.
```

<!--
this is the command / this is the argument

uses the APIs to declare modules, coercions, implicit arguments

--
layout: two-cols-header
level: 2
--

# Trocq

<div class="authors">

![ecranceMERCE](/avatars/ecranceMERCE.jpg)
![amahboubi](/avatars/amahboubi.jpg)
![CohenCyril](/avatars/CohenCyril.jpg)
<!-- ![palmskog](/avatars/palmskog.jpg) -- >

</div>

Proof transfer via parametricity (with or without univalence).

:: left ::

<div style="padding-right: 3em">


- Registers in Elpi Databases translation rules
- Synthesizes transfer proofs minimizing the axioms required

</div>

:: right :: 

<div style="transform: scale(1.2)">

```coq 
From Trocq Require Import Trocq.

Definition RN : (N <=> nat)%P := ...
Trocq Use RN.

Lemma RN0 : RN 0%N 0%nat. ...
Lemma RNS m n : RN m n -> RN (N.succ m) (S n). ...
Trocq Use RN0 RNS.

Lemma N_Srec : ∀P : N -> Type, P 0%N ->
    (∀n, P n -> P (N.succ n)) -> ∀n, P n.
Proof.
trocq. (* replaces N by nat in the goal *)
exact nat_rect.
Qed.
```

</div>

--
layout: two-cols-header
level: 2
--

# Derive

<div class="authors">

![gares](/avatars/gares.jpg)
![CohenCyril](/avatars/CohenCyril.jpg)
![bgregoir](/avatars/bgregoir.jpg)
![eponier](/avatars/eponier.jpg)
![Blaisorblade](/avatars/Blaisorblade.jpg)
![rlepigre](/avatars/rlepigre.jpg)
![dwarfmaster](/avatars/dwarfmaster.jpg)
<!--
![artagnon](/avatars/artagnon.jpg)
![ecranceMERCE](/avatars/ecranceMERCE.jpg)
![ejgallego](/avatars/ejgallego.jpg)
![FissoreD](/avatars/FissoreD.jpg)
![herbelin](/avatars/herbelin.jpg)
![jfehrle](/avatars/jfehrle.jpg)
![maximedenes](/avatars/maximedenes.jpg)
![pedrotst](/avatars/pedrotst.jpg)
![phikal](/avatars/phikal.jpg)
![pi8027](/avatars/pi8027.jpg)
![ppedrot](/avatars/ppedrot.jpg)
![proux01](/avatars/proux01.jpg)
![robblanco](/avatars/robblanco.jpg)
![SimonBoulier](/avatars/SimonBoulier.jpg)
![SkySkimmer](/avatars/SkySkimmer.jpg)
![Tragicus](/avatars/Tragicus.jpg)
![vbgl](/avatars/vbgl.jpg)
![VojtechStep](/avatars/VojtechStep.jpg)
![wdeweijer](/avatars/wdeweijer.jpg)
![whonore](/avatars/whonore.jpg)
![ybertot](/avatars/ybertot.jpg)
![yoichi-at-bedrock](/avatars/yoichi-at-bedrock.jpg)
![Zimmi48](/avatars/Zimmi48.jpg)
- ->

</div>

Framework for type driven code synthesis

:: left ::

<div style="padding-right: 3em">

Derivations:
- parametricity
- deep induction
- equality tests and proofs
- lenses (record update syntax)
- a few more...

</div>

:: right :: 

<div style="transform: scale(1.2)">

```coq
From elpi.apps Require Import derive.std lens.

#[only(lens_laws, eqb), module] derive
Record Box A := { contents : A; tag : nat }.

About Box. (* Notation Box := Box.t *)

Check Box.eqb :
  ∀A, (A -> A -> bool) -> Box A -> Box A -> bool.

(* the Lens for the second field *)
Check @Box._tag : ∀A, Lens (Box A) (Box A) nat nat.

(* a Lens law *)
Check Box._tag_set_set : ∀A (r : Box A) y x,
  set Box._tag x (set Box._tag y r) = set Box._tag x r.
```

</div>


--
layout: two-cols-header
level: 2
--

# Algebra Tactics

<div class="authors">

![pi8027](/avatars/pi8027.jpg)
![proux01](/avatars/proux01.jpg)
![amahboubi](/avatars/amahboubi.jpg)
<!-- ![CohenCyril](/avatars/CohenCyril.jpg)
![gares](/avatars/gares.jpg) -- >

</div>

`ring`, `field`, `lra`, `nra`, and `psatz` tactics for the Mathematical Components library. 

:: left ::

- works with any instance of the structure: concrete, abstract and mixed
  like `int * R` where `R` is a variable
- automatically push down ring morphisms and additive functions to
  leaves of the expression
- reification up to instance unification in Elpi


:: right ::

```coq
From mathcomp Require Import all_ssreflect.
From mathcomp Require Import all_algebra.
From mathcomp Require Import ring lra.

Lemma test (F : realFieldType) (x y : F) :
  x + 2 * y <= 3 ->
  2 * x + y <= 3 ->
    x + y <= 2.
Proof. lra. Qed.

Variables (R : unitRingType) (x1 x2 x3 y1 y2 y3 : R).
Definition f1 : R := ...
Definition f2 : R := ...
Definition f3 : R := ...

(* 500 lines of polynomials later... *)

Lemma example_from_Sander : f1 * f2 = f3.
Proof. rewrite /f1 /f2 /f3. ring. Qed.
```


--
layout: section
color: rocq
--

# Elpi in a nutshell

https://github.com/LPCIC/elpi/

--
layout: two-cols-header
image: vespa.png
backgroundSize: 80%
level: 2
--

# Rules, rules, rules!{style="text-align:center"}


:: left ::


## Roots

- Elpi is a constraint logic programming language
- Elpi is a dialect of λProlog and CHR
- backtracking is not the point

<br/>

## What really matters

- Code is organized in rules
- Rule application is guided by a pattern
- Rules can be added statically and dynamically



:: right ::

## <icon-park-twotone-caution/> Vintage syntax ahead

<ul>
<li><p>variables are capitals
<force-inline>
```elpi
X
```
</force-inline>
</p></li>

<li><p> λx.t  is written
<force-inline>
```elpi
x\ t
```
</force-inline>
</p></li>

<li><p>rules are written
<force-inline>
```elpi
goal :- subgoal1, subgoal2...
```
</force-inline>
</p></li>

</ul>



--
layout: section
color: rocq
transition: fade
--

# Integration in Rocq

https://github.com/LPCIC/coq-elpi/
-->


---
layout: section
color: rocq
---

# Conclusion

---
layout: default
level: 2
---

# Elpi: take home

<br/>

## Extension language
  - Use a language (ony) when it is a good fit
  
## Rule-based is a good fit for
  - HOAS (binders and local context)
  - prover logical environment (global context)
  - (meta) meta programming (homoiconicity)


---
layout: default
level: 2
---

# Perspectives

- Rocq-Elpi into Rocq proper
  - mutual fixpoints (and mutual inductive types)
  - "functional" syntax
- Mechanization of Elpi's semantics in Rocq (done, by Fissore)
  - static analysis (ongoing)
  - unifier (todo and scary)
- Mechanization of $\mathcal{G}$ in Rocq (warming up)
- Memoization (tabling)

---
layout: two-cols-header
image: logo.png
backgroundSize: 80%
level: 2
title: Thanks
---

# Thanks for contributing code! {style="text-align:center"}

<div style="text-align:center">

https://github.com/LPCIC/elpi/

</div>

:: right ::

<div class="vauthors">


<br/>

![Armael](/avatars/Armael.jpg)
![artagnon](/avatars/artagnon.jpg)
![bgregoir](/avatars/bgregoir.jpg)
![Blaisorblade](/avatars/Blaisorblade.jpg)
![cdunchev](/avatars/cdunchev.jpg)
![CohenCyril](/avatars/CohenCyril.jpg)
![dwarfmaster](/avatars/dwarfmaster.jpg)
![ecranceMERCE](/avatars/ecranceMERCE.jpg)
![ejgallego](/avatars/ejgallego.jpg)
![eponier](/avatars/eponier.jpg)
![FissoreD](/avatars/FissoreD.jpg)
<!-- ![gares](/avatars/gares.jpg) -->
![gdufrc](/avatars/gdufrc.jpg)
![herbelin](/avatars/herbelin.jpg)
![jfehrle](/avatars/jfehrle.jpg)
![jwintz](/avatars/jwintz.jpg)
![kit-ty-kate](/avatars/kit-ty-kate.jpg)
![lthls](/avatars/lthls.jpg)
![lukovdm](/avatars/lukovdm.jpg)
![maximedenes](/avatars/maximedenes.jpg)
![mb64](/avatars/mb64.jpg)
![MSoegtropIMC](/avatars/MSoegtropIMC.jpg)
![palmskog](/avatars/palmskog.jpg)
![pedrotst](/avatars/pedrotst.jpg)
![phikal](/avatars/phikal.jpg)
![pi8027](/avatars/pi8027.jpg)
![ppedrot](/avatars/ppedrot.jpg)
![proux01](/avatars/proux01.jpg)
![rgrinberg](/avatars/rgrinberg.jpg)
![rlepigre](/avatars/rlepigre.jpg)
![robblanco](/avatars/robblanco.jpg)
![sacerdot](/avatars/sacerdot.jpg)
![shonfeder](/avatars/shonfeder.jpg)
![SimonBoulier](/avatars/SimonBoulier.jpg)
![SkySkimmer](/avatars/SkySkimmer.jpg)
![smuenzel](/avatars/smuenzel.jpg)
![Tragicus](/avatars/Tragicus.jpg)
![vbgl](/avatars/vbgl.jpg)
![VojtechStep](/avatars/VojtechStep.jpg)
![voodoos](/avatars/voodoos.jpg)
![wdeweijer](/avatars/wdeweijer.jpg)
![whonore](/avatars/whonore.jpg)
![XVilka](/avatars/XVilka.jpg)
![ybertot](/avatars/ybertot.jpg)
![yoichi-at-bedrock](/avatars/yoichi-at-bedrock.jpg)
![Zimmi48](/avatars/Zimmi48.jpg)

</div>

<br/>

:: left ::

<!--![logo](/logo.png){style="width:40%; margin-left:auto; margin-right: auto;"}-->

<div style="text-align:justify">

Pedro Abreu, Yves Bertot, Frederic Besson, Rob Blanco, Simon Boulier, Luc Chabassier, Cyril Cohen, Enzo Crance, Maxime Dénès, Jim Fehrle, Davide Fissore, Paolo G. Giarrusso, Gaëtan Gilbert, Benjamin Gregoire, Hugo Herbelin, Yoichi Hirai, Jasper Hugunin, Emilio Jesus Gallego Arias, Jan-Oliver Kaiser, Philip Kaludercic, Chantal Keller, Vincent Laporte, Jean-Christophe Léchenet, Rodolphe Lepigre, Karl Palmskog, Pierre-Marie Pédrot, Ramkumar Ramachandra, Pierre Roux, Pierre Roux, Claudio Sacerdoti Coen, Kazuhiko Sakaguchi, Matthieu Sozeau, Gordon Stewart, David Swasey, Alexey Trilis, Quentin Vermande, Théo Zimmermann, wdewe, whonore 

</div>


---
layout: two-cols-header
image: logo.png
backgroundSize: 80%
level: 2
title: Thanks
---

# Thanks for support and motivation! {style="text-align:center"}


:: right ::

![anna](./anna.jpg){style="size:80%"}

:: left ::

<img src="./cinzia.jpeg" alt="cinzia" style="width: 85%">


---
layout: image-right
image: grill.svg
backgroundSize: 80%
level: 2
title: Thanks
---

# Thanks for listening! {style="text-align:center"}

<br/>

[Elpi: rule-based extension language]{style="font-weight: bold"}

<style>
  tr { border-style: none; padding-top: 0.1rem; padding-bottom: 0.1rem; }
  td { border-style: none; padding-top: 0.1rem; padding-bottom: 0.1rem; text-align: left !important; }
</style>
<table><tbody>
<tr ><td style="text-align: right !important;">Candidate:</td><td>Enrico Tassi</td></tr>
<tr ><td style="text-align: right !important;">Date:</td><td>9/1/2026</td></tr>
<tr ><td style="text-align: right !important;">Jury:</td><td>Catherine Dubois</td></tr>
<tr ><td ></td><td>Dale Miller</td></tr>
<tr ><td ></td><td>Brigitte Pientka</td></tr>
<tr ><td ></td><td>Alberto Momigliano</td></tr>
<tr ><td ></td><td>Christine Paulin-Mohring</td></tr>
<tr ><td ></td><td>Yves Bertot</td></tr>
</tbody></table>

