; A very basic infinite stream, notice the co-recursive nature of the definition 
(define ones (cons-stream 1 ones))

; This is what you get when you try to display ones:
ones
;Value 9: (1 . #[promise 3])

; An infinite stream that is not just a circular list
(define (nums-from n) (cons-stream n (nums-from (+ n 1))))
(define naturals (nums-from 1))

; Some functions to display parts of a stream
(define (show-nth n s) (if (= n 1) (head s) (show-nth (- n 1) (tail s))))
(define (prefix n s) (if (= n 0) '() (cons (head s)
                                           (prefix (- n 1) (tail s)))))


; Some basic stream operations using recursion
(define (filter test s)
  (if (empty-stream? s)
      the-empty-stream
      (if (test (head s)) 
          (cons-stream (head s) (filter test (tail s)))
          (filter test (tail s)))))

; Actually both this and filter are predefined in Scheme     
(define (map-stream f s)
  (if (empty-stream? s)
      the-empty-stream
      (cons-stream (f (head s)) (map-stream f (tail s)))))

; The sieve of Eratosthenes
(define (divides? n m) (= 0 (modulo m n)))

(define (sieve s) 
  (cons-stream 
    (head s)
    (sieve (filter (lambda (x) (not (divides? (head s) x))) (tail s)))))

(define primes (sieve (nums-from 2)))

; Stream binary operation
(define (addstreams s1 s2) (cons-stream (+ (head s1) (head s2))
                                        (addstreams (tail s1)
                                                    (tail s2))))
; A typical co-recursive program
(define (psums s)
  (cons-stream (head s) (addstreams (psums s) (tail s))))

; Another co-recursive program
(define fib (cons-stream 1 (cons-stream 1 (addstreams fib (tail fib)))))

; Pascal's triangle as a stream of streams
(define pascal (cons-stream ones (stream-map psums pascal)))

(define row3 (show-nth 3 pascal))

; The stream of twin primes.  We do not know if it is infinite
(define twin-primes (scan-for-twins primes))

(define (scan-for-twins str)
  (define (iter current str)
    (if (empty-stream? str)
	the-empty-stream
	(let ((next (head str)))
	  (if (= (+ current 2) next)
	      (cons-stream (list current next)
			   (iter next (tail str)))
	      (iter next (tail str))))))
  (if (empty-stream? str)
      the-empty-stream
      (iter (head str) (tail str))))



;; The Ramanujan numbers

(define (merge-wt s1 s2 f)
  (let ((h1 (head s1)) (h2 (head s2)))
    (if (<= (f h1) (f h2))
        (cons-stream h1 (merge-wt (tail s1) s2 f))
        (cons-stream h2 (merge-wt s1 (tail s2) f)))))

(define (wt-pairs s1 s2 wtfun)
  (cons-stream (list (head s1) (head s2))
               (merge-wt (map-stream (lambda (x) (list (head s1) x))
                                     (tail s2))
                         (wt-pairs (tail s1) (tail s2) wtfun)
                         wtfun)))

(define (combine-same-weight s wf)
  (define (csw s l wf wt)
    (cond ((empty-stream? s) the-empty-stream)
          ((= (wf (head s)) wt) (csw (tail s) (cons (head s) l) wf wt))
          (else (cons-stream (cons wt l)
                             (csw s '() wf (wf (head s)))))))
  (csw s '() wf (wf (head s))))

(define allnums (nums-from 1))
(define (sotc p)
  (let ((x (car p)) (y (cadr p))) 
    (+ (* x x x) (* y y y))))

(define allsotc (wt-pairs allnums allnums sotc))
(define rawram (combine-same-weight allsotc sotc))
(define ramnums (filter (lambda (l) (> (length (cdr l)) 1)) rawram))



;; The Hamming-Dijkstra numbers

(define first head)

(define (om s1 s2 s3)
  (cond ((and (= (first s1) (first s2)) (= (first s2) (first s3)))
         (cons-stream (first s1) (om (tail s1) (tail s2) (tail s3))))
        ((and (= (first s1) (first s2)) (< (first s1) (first s3)))
         (cons-stream (first s1) (om (tail s1) (tail s2) s3)))
        ((and (= (first s1) (first s3)) (< (first s1) (first s2)))
         (cons-stream (first s1) (om (tail s1) s2 (tail s3))))
        ((and (= (first s3) (first s2)) (< (first s2) (first s1)))
         (cons-stream (first s2) (om s1 (tail s2) (tail s3))))
        ((and (< (first s1) (first s2)) (< (first s1) (first s3)))
         (cons-stream (first s1) (om (tail s1) s2 s3)))
        ((and (< (first s2) (first s1)) (< (first s2) (first s3)))
         (cons-stream (first s2) (om s1 (tail s2) s3)))
        ((and (< (first s3) (first s1)) (< (first s3) (first s2)))
         (cons-stream (first s3) (om s1 s2 (tail s3))))))

(define (zap n s) (map-stream (lambda (x) (* n x)) s))

(define ham (cons-stream 1 (om (zap 2 ham) (zap 3 ham) (zap 5 ham))))
