import Lang.Util
import Lang.Basic
import Lang.Static
import Lang.Dynamic

set_option pp.fieldNotation false


mutual

  theorem ListSubtyping.soundness skolems assums cs skolems' assums' :
    ListSubtyping.Static skolems assums cs skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.diff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      MultiSubtyping.Dynamic (am ++ am') cs
    )
  := by sorry

  theorem Subtyping.soundness skolems assums lower upper skolems' assums' :
    Subtyping.Static skolems assums lower upper skolems' assums' →
    ∃ am, ListPair.dom am ⊆ (List.diff skolems' skolems) ∧
    (∀ am',
      MultiSubtyping.Dynamic (am ++ am') assums' →
      Subtyping.Dynamic (am ++ am') lower upper
    )
  := by sorry

end
