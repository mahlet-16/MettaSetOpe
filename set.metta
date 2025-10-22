; (= (is-empty $s ) (== $s ()))

; ; (= (atoms-union $s1 $s2)
; ;   (if (is-empty $s1)
; ;       $s2
; ;      (union-atom $s1 $s2)
      
; ;   ))
; ( = (atoms-intersection $s1 $s2)
;   (if (is-empty $s1)
;       ()
;     (intersection-atom $s1 $s2)))

; ( = (atoms-difference $s1 $s2)
;   (if (is-empty $s1)
;       ()
;     (subtraction-atom $s1 $s2)))

; ( = (atoms-sym-diff $s1 $s2)
;   (union (atoms-difference $s1 $s2) (atoms-difference $s2 $s1)))

; ; !(atoms-union (a b c) (b c d))
; !(atoms-intersection (a b c) (b c d))
; !(atoms-difference (a b c) (b c d))
; !(atoms-sym-diff (a b c) (b c d))

; === Helpers ===
(= (is-empty $s) (= $s ()))

; member: checks whether atom $a is in the cons-list $s
(= (member $a ()) ())
(= (member $a (:: $head $tail))
    (if (= $a $head) (cons $a ()) (member $a $tail)))

; === atoms implementations (consistent cons form `(:: x rest)` and empty list `()` ) ===

; atoms-union: insert each head of s1 into s2 using builtin `union-atom`
(= (atoms-union () $s2) $s2)
(= (atoms-union (:: $head $tail) $s2)
    (atoms-union $tail (union-atom (:: $head ()) $s2)))

; atoms-intersection
(= (atoms-intersection () $s2) ())
(= (atoms-intersection (:: $head $tail) $s2)
    (if (member $head $s2)
         (:: $head (atoms-intersection $tail $s2))
         (atoms-intersection $tail $s2)))

; atoms-difference (A \ B)
(= (atoms-difference () $s2) ())
(= (atoms-difference (:: $head $tail) $s2)
    (if (member $head $s2)
         (atoms-difference $tail $s2)
         (:: $head (atoms-difference $tail $s2))))

; atoms symmetric difference
(= (atoms-sym-diff $s1 $s2)
    (atoms-union (atoms-difference $s1 $s2) (atoms-difference $s2 $s1)))

; === Tests ===
!(atoms-union (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
; !(atoms-union (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-intersection (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-difference (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-sym-diff (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))

!(member b (:: b (:: c (:: a ()))))

