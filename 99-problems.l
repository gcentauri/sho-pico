;; Testing "framework"
;; =================
(setq Tests '())

(de expect (Tst)
    (queue 'Tests Tst))

(de testrun (Tst)
    (let (Result (catch '("Undefined") (eval Tst)))
      (cond
        ((= Result "Undefined") "")
        (Result "")
        "")))

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

;; 08 Eliminate consecutive duplicates of list elements.
(expect '(= '(a b c d e) (compress '(a a a b b c c c d a a e e e e))))

(de compress (Lst)
    (recur (Lst Acc)
           (cond ((not Lst) Acc)
                 ((member (car Lst) Acc) (recurse (cdr Lst) Acc))
                 (T (recurse (cdr Lst) (append Acc (list (car Lst))))))))

;; 09 Pack consecutive duplicates of list elements into sublists.
(expect '(=
          (dupack '(a a a a b c c a a d e e e e))
          '((a a a a) (b) (c c) (a a) (d) (e e e e))))

(de dupack (Lst)
    (recur (Lst Acc Out)
           (let (Rst (cdr Lst) AddAcc (cons (car Lst) Acc))
             (cond
               ((not Lst) (reverse (cons Acc Out)))
               ((not Acc) (recurse Rst AddAcc Out))
               ((member (car Lst) Acc) (recurse Rst AddAcc Out))
               (T (recurse Rst (list (car Lst)) (cons Acc Out)))))))

;; 10 Run-length encoding of a list.
(expect '(= (encode '(a a a a b c c a a d e e e e))
           '((4 A) (1 B) (2 C) (2 A) (1 D)(4 E))))
