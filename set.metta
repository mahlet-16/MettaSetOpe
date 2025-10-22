; ; (= (is-empty $s ) (== $s ()))

; ; ; (= (atoms-union $s1 $s2)
; ; ;   (if (is-empty $s1)
; ; ;       $s2
; ; ;      (union-atom $s1 $s2)
      
; ; ;   ))
; ; ( = (atoms-intersection $s1 $s2)
; ;   (if (is-empty $s1)
; ;       ()
; ;     (intersection-atom $s1 $s2)))

; ; ( = (atoms-difference $s1 $s2)
; ;   (if (is-empty $s1)
; ;       ()
; ;     (subtraction-atom $s1 $s2)))

; ; ( = (atoms-sym-diff $s1 $s2)
; ;   (union (atoms-difference $s1 $s2) (atoms-difference $s2 $s1)))

; ; ; !(atoms-union (a b c) (b c d))
; ; !(atoms-intersection (a b c) (b c d))
; ; !(atoms-difference (a b c) (b c d))
; ; !(atoms-sym-diff (a b c) (b c d))


; ; member: checks whether atom $a is in the cons-list $s
; (= (member $a ()) False)
; (= (member $a (:: $a $tail)) True)
; (= (member $a (:: $head $tail)) (member $a $tail))

; ; === atoms implementations (consistent cons form `(:: x rest)` and empty list `()` ) ===

 ; atoms-union: insert each head of s1 into s2 using builtin `union-atom`
 (= (atoms-union () $s2) $s2)
 (= (atoms-union (:: $head $tail) $s2)
     (atoms-union $tail (union-atom (:: $head ()) $s2)))

; ; atoms-intersection

; Main: Recursive intersection of two atom lists/sets
;  = (atoms-intersection ?S ()) ()            ; Base: intersect with empty -> empty
;  = (atoms-intersection () ?S2) ()           ; Symmetric base
;  = (atoms-intersection (tuple ?X .?Rest) ?S2) 
;      (if (member? ?X ?S2) 
;          (tuple ?X .(atoms-intersection .?Rest ?S2)) 
;          (atoms-intersection .?Rest ?S2)
;      )        


; atoms-intersection implementations
(= (atoms-intersection () $s2) ())
(= (atoms-intersection $s1 ()) ())
(= (atoms-intersection (:: $head $tail) $s2)
    (atoms-intersection* (member $head $s2) $head $tail $s2))

(= (atoms-intersection* True $head $tail $s2)
    (:: $head (atoms-intersection $tail $s2)))
(= (atoms-intersection* False $head $tail $s2)
    (atoms-intersection $tail $s2))
; ; === Helpers ===

; Check if a list is empty
(= (is-empty ()) true)
(= (is-empty $s) false)

; Check if atom $a is in cons-list $s (returns True/False)
(= (member $a ()) False)
(= (member $a (:: $a $tail)) True)
(= (member $a (:: $head $tail)) (member $a $tail))

; Append two lists (recursive)
(= (append () $Y) $Y)
(= (append (:: $X $Xs) $Y) (:: $X (append $Xs $Y)))

; === Set Operations ===

; Union: combine $s1 and $s2, avoiding duplicates
; (= (atoms-union () $s2) $s2)
; (= (atoms-union (:: $head $tail) $s2)
;     (if (member $head $s2)
;         (atoms-union $tail $s2)               ; Skip if in $s2 (no duplicates)
;         (:: $head (atoms-union $tail $s2))))  ; Include head and recurse

; ; Intersection: keep atoms common to $s1 and $s2
; (= (atoms-intersection () $s2) ())
; (= (atoms-intersection $s1 ()) ())
; (= (atoms-intersection (:: $head $tail) $s2)
;     (if (member $head $s2)
;         (:: $head (atoms-intersection $tail $s2))  ; Include if in $s2
;         (atoms-intersection $tail $s2)))           ; Skip and recurse

; Difference: atoms in $s1 but not $s2
(= (atoms-difference () $s2) ())
(= (atoms-difference (:: $head $tail) $s2)
    (atoms-difference* (member $head $s2) $head $tail $s2))

(= (atoms-difference* True $head $tail $s2)
    (atoms-difference $tail $s2))
(= (atoms-difference* False $head $tail $s2)
    (:: $head (atoms-difference $tail $s2)))

; Symmetric Difference: (A \ B) ∪ (B \ A)
(= (atoms-sym-diff $s1 $s2)
    (atoms-union (atoms-difference $s1 $s2) (atoms-difference $s2 $s1)))

; === Tests ===
!(atoms-union (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-intersection (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-difference (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-sym-diff (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(member b (:: b (:: c (:: a ()))))