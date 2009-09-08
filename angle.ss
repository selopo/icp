#lang scheme/base

(require
 scheme/math)

(define 2pi (* 2 pi))

;; Number -> Number
;;
;; Normalises an angle (in radians) to [0, 2pi)
(define (angle-normalise a)
  (cond
   [(and (<= 0 a) (< a 2pi)) a]
   [(< a 0)
    (angle-normalise (- a (* (floor (/ a 2pi)) 2pi)))]
   [(<= 2pi a)
    (angle-normalise (- a (* (ceiling (/ a 2pi)) 2pi)))]
   [else (error 'angle-normalise "impossible condition for angle ~a\n" a)]))


;; Number Number [Number] -> (U #t #f)
;;
;; #t if a1 is within e radians of a2
;;
;; a1 and a2 MUST be normalised
(define (angle=? a1 a2 [e 0])
  (if (zero? e)
      (= a1 a2)
      (let ([low (angle-normalise (- a2 e))]
            [high (angle-normalise (+ a2 e))])
        ;;(printf "~a in [~a ~a] (~a +- ~a) \n" a1 low high a2 e)
        ;; It may be the case that low > high, due to wrap
        ;; around at 2pi, so we can't just check (<= low a1
        ;; high)
        (if (< low high)
            (<= low a1 high)
            (or (<= low a1 2pi)
                (<= 0 a1 high))))))

;; Number Number -> (U #t #f)
;;
;; True if the shortest rotation from a1 to a2 is in the
;; anticlockwise direction
;;
;; a1 and a2 should be normalised
(define (angle<? a1 a2)
  (< (angle-normalise (- a2 a1)) pi))

(provide
 angle-normalise
 angle=?
 angle<?)