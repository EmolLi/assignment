This is the Scheme process buffer.
Type C-x C-e to evaluate the expression before point.
Type C-c C-c to abort evaluation.
Type C-h m for more information.

MIT/GNU Scheme running under MacOSX

Copyright (C) 2010 Massachusetts Institute of Technology
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Image saved on Tuesday March 9, 2010 at 6:41:34 PM
  Release 9.0.1 || Microcode 15.1 || Runtime 15.7 || SF 4.41 || LIAR/i386 4.118
  Edwin 3.116

;; Making pairs

(cons 1 2)
;Value 11: (1 . 2)

(define foo (cons 1 2))
;Value: foo

foo
;Value 12: (1 . 2)
; Taking pairs apart
(car foo)
;Value: 1
(cdr foo)
;Value: 2

; Equality for numbers
(= 1 2)
;Value: #f

(= 1.0 1.1)
;Value: #f

(= 1.0 1)
;Value: #t

; Equality for structures
(define a (cons 1 2))
;Value: a

(define b (cons 1 2))
;Value: b

(equal? a b)
;Value: #t

; But they are different cells in memory.  eq? tests pointer equality
(eq? a b)
;Value: #f

; Lists

(cons 1 (cons 2 (cons 3 (cons 4 '()))))
;Value 13: (1 2 3 4)

;; Constructed form "cons" cells but if it is a list it must end in nil.  A
;; dot is not displayed in that case.  If there is a dot at the end it
;; means that one does not have a proper list.

(cons 1 (cons 2 (cons 3 4)))
;Value 14: (1 2 3 . 4)

;; The function "list" makes a list.  It is NOT a free constructor like cons.
(list 1 2 3 4)
;Value 15: (1 2 3 4)

;; There are many standard list operations: map, filter etc. just like F#.

(map (lambda (n) (+ n 1)) '(1 2 3))
;Value 19: (2 3 4)

(filter odd? (list 1 2 3 4 5 6 7))
;Value 21: (1 3 5 7)

; Lists can be nested 
'((1 2 3) (4 5 6) (7 8 9))
;Value 22: ((1 2 3) (4 5 6) (7 8 9))

; Unlike F# they can be heterogeneous.
(list '(1 2 3) '((4 5) (((6)))) 7)
;Value 23: ((1 2 3) ((4 5) (((6)))) 7)

(length '(1 2 (3 4 5)))
;Value: 3
; Did you understand why it got 3?

; Here is a useful list function defined by recursion.
(define (nth n l)
  (if (= n 0)
      (if (null? l)
          (print "List too short")
          (car l))
      (nth (- n 1) (cdr l))))
;Value: nth

(nth 5 '(1 2 3 4 5 6 7 8 9))
;Value: 6
; Huh?  Oh, we are counting from zero!

(nth 5 '(1 2 3))

[Entering #[compound-procedure 24 nth]
    Args: 5
          (1 2 3)]
[Entering #[compound-procedure 24 nth]
    Args: 4
          (2 3)]
[Entering #[compound-procedure 24 nth]
    Args: 3
          (3)]
[Entering #[compound-procedure 24 nth]
    Args: 2
          ()]
;The object (), passed as the first argument to cdr, is not the correct type.
;To continue, call RESTART with an option number:
; (RESTART 7) => Specify an argument to use in its place.
; (RESTART 6) => Return a value from the advised procedure.
; (RESTART 5) => Return a value from the advised procedure.
; (RESTART 4) => Return a value from the advised procedure.
; (RESTART 3) => Return a value from the advised procedure.
; (RESTART 2) => Return to read-eval-print level 2.
; (RESTART 1)

;Abort!

 => Return to read-eval-print level 1.

;; What went wrong?  No idea!

;; We will trace the execution.
(trace nth)
;Unspecified return value

(nth 3 (list 1 2))

[Entering #[compound-procedure 24 nth]
    Args: 3
          (1 2)]
[Entering #[compound-procedure 24 nth]
    Args: 2
          (2)]
[Entering #[compound-procedure 24 nth]
    Args: 1
          ()]
;The object (), passed as the first argument to cdr, is not the correct type.
;To continue, call RESTART with an option number:
; (RESTART 5) => Specify an argument to use in its place.
; (RESTART 4) => Return a value from the advised procedure.
; (RESTART 3) => Return a value from the advised procedure.
; (RESTART 2) => Return a value from the advised procedure.
; (RESTART 1) => Return to read-eval-print level 1.

;; OK, I see. The test for empty list is in the wrong place.

(define (nth n l)
  (if (null? l)
      (pp "List too short.")
      (if (= n 0) (car l)
          (nth (- n 1) (cdr l)))))
;Value: nth

(nth 5 '(1 2 3))
"List too short."
;Unspecified return value



;; If you just type in (1 2 3 4) it will think that you want to apply the
;; function "1" (remember there is no type system) to the following as
;; arguments.

(1 2 3 4)

;The object 1 is not applicable.
;To continue, call RESTART with an option number:
; (RESTART 2) => Specify a procedure to use in its place.
; (RESTART 1) => Return to read-eval-print level 1.

(restart 1)

;Abort!

; So how does one make a list without using "list"?
; We have a unique feature, the quote which inhibits computation.
'(1 2 3)
;Value 16: (1 2 3)

; Here are some examples of quote in action.
(quote a)
;Value: a

'quote
;Value: quote

; Note that scheme has SYMBOLS as a basic type.  These are not strings.
; They are atomic and cannot be taken apart.

'(The quick brown fox jumps over the lazy dog)
;Value 17: (the quick brown fox jumps over the lazy dog)

; Very handy for symbolic computation.  Here is a sentence generator.

(define nouns '(rock-star professor student dog cat baby owl))
;Value: nouns

(define articles '(a the))
;Value: articles

(define verbs '((intrans runs) (intrans sleeps) (trans shoots) (intrans sings) (intrans snores) (trans hugs)))
;Value: verbs

(define adverbs '(quickly slowly loudly lazily))
;Value: adverbs

(define adjectives '(old sexy bald crazy cranky silly))
;Value: adjectives

(define (make-sentence) 
  (append (make-noun) (make-verb)))
;Value: make-sentence

(define (make-noun)
  (let ((size (random 2)) (noun-chosen (modulo (random 100) 7)))
    (define (iter n)
      (if (= n 0)
          (list (nth noun-chosen nouns))
          (cons (nth (random 5) adjectives)
                (iter (- n 1)))))
    (cons (nth (random 2) articles) (iter size))))
;Value: make-noun

(define (make-verb)
  (let ((adv (nth (random 4) adverbs)) (verb-choice (nth (random 5) verbs)))
    (let ((verb (cadr verb-choice)) (verb-type (car verb-choice)))
      (if (eq? verb-type 'trans)
          (cons verb (append (make-noun) (list adv)))
          (cons verb (list adv))))))
;Value: make-verb

(make-sentence)
;Value 25: (the cranky professor snores slowly)

(make-sentence)
;Value 26: (a cat snores quickly)

(make-sentence)
;Value 27: (the old rock-star snores loudly)

(make-sentence)
;Value 28: (a cat shoots the old cat loudly)

(make-sentence)
;Value 29: (the cranky rock-star sings lazily)

; Can we construct a self reproducing function?


((lambda (x) (list x (list (quote quote) x))) (quote (lambda (x) (list x (list (quote quote) x)))))
;Value 30: ((lambda (x) (list x (list (quote quote) x))) (quote (lambda (x) (list x (list (quote quote) x)))))

;; Yes!

;; How did we come up with it?

; First try
((lambda (x) (list x x))(quote (lambda (x) (list x x))))
;Value 31: ((lambda (x) (list x x)) (lambda (x) (list x x)))

; We don't have the quote.  Need to put it in.

((lambda (x) (list x 'quote x))(quote (lambda (x) (list x 'quote x))))
;Value 32: ((lambda (x) (list x (quote quote) x)) quote (lambda (x) (list x (quote quote) x)))

;  This is right but the interpreter expand the abbreviation for quote, so 
;  we will put it in in the unabbreviated form.

((lambda (x) (list x (quote quote) x))
(quote (lambda (x) (list x (quote quote) x))))
;Value 33: ((lambda (x) (list x (quote quote) x)) quote (lambda (x) (list x (quote quote) x)))

;; Some list programming
(define (flatten ll)
  (if (null? ll)
      '()
      (append (car ll) (flatten (cdr ll)))))
;Value: flatten

(flatten '((1 2 3) (4 5)))
;Value 34: (1 2 3 4 5)

(define (insert-all x l)
  (if (null? l)
      (list (list x))
      (cons (cons x l) (map (lambda (u) (cons (car l) u)) 
                            (insert-all x (cdr l))))))
;Value: insert-all

(insert-all 1 '(2 3 4))
;Value 36: ((1 2 3 4) (2 1 3 4) (2 3 1 4) (2 3 4 1))

(define (perms l)
  (if (null? l)
      (list '())
      (flatten (map (lambda (x) (insert-all (car l) x))
                    (perms (cdr l))))))

;Value: perms

(perms '(1 2 3))
;Value 37: ((1 2 3) (2 1 3) (2 3 1) (1 3 2) (3 1 2) (3 2 1))

(perms '(a b c d))
;Value 38: ((a b c d) (b a c d) (b c a d) (b c d a) (a c b d) (c a b d) (c b a d) (c b d a) (a c d b) (c a d b) (c d a b) (c d b a) (a b d c) (b a d c) (b d a c) (b d c a) (a d b c) (d a b c) (d b a c) (d b c a) (a d c b) (d a c b) (d c a b) (d c b a))

(exit)

Happy Happy Joy Joy.











