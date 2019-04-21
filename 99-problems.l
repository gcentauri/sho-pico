;; Testing "framework"
;; =================
(setq Tests '())

(de expect (Tst)
    (queue 'Tests Tst))

(de testrun (Tst)
    (let (Result (catch '("Undefined") (eval Tst)))
      (cond
        ((= Result "Undefined") "_")
        (Result ".")
        "F")))

(de main ()
    (prinl (mapcar testrun Tests))
    (prinl "[done]")
    (bye))
;; ===================================

;; 99 Problems, but a lisp ain't one

;; 01 Find last "box" of a list
(expect '(= '(d) (my-last '(a b c d))))

(de my-last (Lst)
    (ifn (cdr Lst) Lst (my-last (cdr Lst))))

;; 02 Find the last but one box of a list
(expect '(= '(c d) (my-but-last '(a b c d))))

(de my-but-last (Lst)
    (ifn (cddr Lst) Lst (my-but-last (cdr Lst))))

;; 03 Find the K'th element of a list.
;; The first element in the list is number 1.
(expect '(= 'c (element-at '(a b c d e) 3)))

(de element-at (Lst Idx)
    (if (= 1 Idx)
        (car Lst)
        (element-at (cdr Lst) (- Idx 1))))

;; 04 Find the number of elements in a list
(expect '(= 5 (my-length '(1 2 3 4 5))))

(de my-length (Lst)
    (sum '((X) (if X 1 0)) Lst))

;; 05 Reverse a list
(expect '(= '(d c b a) (my-reverse '(a b c d))))

(de my-reverse @
    (let (Lst (arg 1) Acc (arg 2))
      (ifn Lst
           Acc
           (my-reverse (cdr Lst) (cons (car Lst) Acc)))))

;; 06 Detect a palindrome list
(expect '(palindrome? '(x a n a x)))

(de palindrome? (Lst)
    (= Lst (my-reverse Lst)))

;; 07 Flatten a nested list structure.

(expect '(= '(a b c d e) (my-flatten '(a (b (c d) e)))))

(de my-flatten (Alol)
    (cond
      ((= '() Alol) '())
      ((atom (car Alol)) (cons (car Alol)
                               (my-flatten (cdr Alol))))
      ((lst? (car Alol)) (append (my-flatten (car Alol))
                                 (my-flatten (cdr Alol))))))
