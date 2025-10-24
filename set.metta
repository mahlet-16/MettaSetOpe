; --- Set operations ------------------------------------------------------

(= (member $a ()) ())
(= (member $a (:: $head $tail))
   (if (== $a $head) (:: $a ()) (member $a $tail)))

; union
(= (atoms-union () $s2) $s2)
(= (atoms-union (:: $head $tail) $s2)
   (:: $head (atoms-union $tail $s2)))

; intersection
(= (atoms-intersection () $s2) ())
(= (atoms-intersection $s1 ()) ())
(= (atoms-intersection (:: $head $tail) $s2)
   (atoms-intersection-case (member $head $s2) $head $tail $s2))

(= (atoms-intersection-case () $head $tail $s2)
   (atoms-intersection $tail $s2))
(= (atoms-intersection-case (:: $found ()) $head $tail $s2)
   (:: $head (atoms-intersection $tail $s2)))

; difference
(= (atoms-difference () $s2) ())
(= (atoms-difference (:: $head $tail) $s2)
   (atoms-difference-case (member $head $s2) $head $tail $s2))

(= (atoms-difference-case () $head $tail $s2)
   (:: $head (atoms-difference $tail $s2)))
(= (atoms-difference-case (:: $found ()) $head $tail $s2)
   (atoms-difference $tail $s2))

; symmetric difference = (A \ B) ∪ (B \ A)
(= (atoms-sym-diff $s1 $s2)
   (atoms-union (atoms-difference $s1 $s2)
                (atoms-difference $s2 $s1)))



!(atoms-union (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-intersection (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-difference (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))
!(atoms-sym-diff (:: a (:: b (:: c ()))) (:: b (:: c (:: d ()))))