import Lean

import Lang.ReflTrans.Basic

set_option pp.fieldNotation false

namespace Lang

def Joinable (R : α → α → Prop) (ea eb : α) :=
  ∃ en , R ea en ∧ R eb en

theorem Joinable.refl_trans_right_expansion :
  R e e' →
  Joinable (ReflTrans R) ea e' →
  Joinable (ReflTrans R) ea e
:= by
  unfold Joinable
  intro h0 h1
  have ⟨en,h2,h3⟩ := h1
  clear h1
  exists en
  apply And.intro
  { exact h2 }
  { exact ReflTrans.step h0 h3 }

theorem Joinable.symm {a b} :
  Joinable R a b →
  Joinable R b a
:= by
  unfold Joinable
  intro h0
  have ⟨e,h1,h2⟩ := h0
  exists e

theorem Joinable.refl e:
  Joinable (ReflTrans R) e e
:= by
  unfold Joinable
  exists e
  apply And.intro
  { exact ReflTrans.refl e}
  { exact ReflTrans.refl e}

end Lang
