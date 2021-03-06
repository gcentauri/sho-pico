## Testing "framework"
## =================
(setq *Problems '())

(de problem P
   (queue '*Problems P))

(de check (P)
   (let (Result (catch '("Undefined") (eval P)))
      (cond
        ((= Result "Undefined") "")
        (Result "")
        "" ) ) )

(de go ()
   (for P *Problems (prinl (glue " " (list (check (cadr P)) (car P))))) )
## ===================================

## 99 Problems, but a lisp ain't one

(problem "01 Find last cell of a list" (= '(d) (my-last '(a b c d))))

(de my-last (Lst)
   (ifn (cdr Lst) Lst (my-last (cdr Lst))) )

(problem "02 Find the last but one cell of a list" (= '(c d) (my-but-last '(a b c d))))

(de my-but-last (Lst)
   (ifn (cddr Lst) Lst (my-but-last (cdr Lst))) )

(problem "03 Find the K'th element of a list." (= 'c (element-at '(a b c d e) 3)))

(de element-at (Lst Idx)
    (if (= 1 Idx)
        (car Lst)
        (element-at (cdr Lst) (- Idx 1)) ) )

(problem "04 Find the number of elements in a list" (= 5 (my-length '(1 2 3 4 5))))

(de my-length (Lst)
   (sum '((X) (if X 1 0)) Lst) )

(problem "05 Reverse a list" (= '(d c b a) (my-reverse '(a b c d))))

(de my-reverse @
   (let (Lst (arg 1) Acc (arg 2))
      (ifn Lst
         Acc
         (my-reverse (cdr Lst) (cons (car Lst) Acc)) ) ) )

(problem "06 Detect a palindrome list" (palindrome? '(x a n a x)))

(de palindrome? (Lst)
   (= Lst (my-reverse Lst)) )

(problem "07 Flatten a nested list structure."
   (= '(a b c d e) (my-flatten '(a (b (c d) e)))) )

## (fish 'fun 'any) -> lst
(de my-flatten (Alol)
   (cond
      ((= '() Alol) '())
      ((atom (car Alol)) (cons (car Alol)
                            (my-flatten (cdr Alol)) ) )
      ((lst? (car Alol)) (append (my-flatten (car Alol))
                            (my-flatten (cdr Alol)) ) ) ) )

(problem "08 Eliminate consecutive duplicates of list elements."
   (= '(a b c d a e) (compress '(a a a b b c c c d a a e e e e))) )

(de compress (Lst)
   (cond ((or (not Lst) (not (cdr Lst))) Lst)
      ((= (car Lst) (cadr Lst)) (compress (cdr Lst)))
      (T (cons (car Lst) (compress (cdr Lst)))) ) )

(problem "09 Pack consecutive duplicates of list elements into sublists."
   (= (dupack '(a a a a b c c a a d e e e e))
       '((a a a a) (b) (c c) (a a) (d) (e e e e)) ) )

(de dupack (Lst)
   (recur (Lst Acc Out)
      (let (Rst (cdr Lst) AddAcc (cons (car Lst) Acc))
         (cond
            ((not Lst) (reverse (cons Acc Out)))
            ((not Acc) (recurse Rst AddAcc Out))
            ((member (car Lst) Acc) (recurse Rst AddAcc Out))
            (T (recurse Rst (list (car Lst)) (cons Acc Out))) ) ) ) )

(problem "10 Run-length encoding of a list."
   (= (encode '(a a a a b c c a a d e e e e))
      '((4 a) (1 b) (2 c) (2 a) (1 d)(4 e)) ) )

(de encode (Lst)
   (mapcar '((L) (list (my-length L) (car L))) (dupack Lst)) )

(problem "11 Modified run-length encoding."
   (= (encode-modified '(a a a a b c c a a d e e e e))
      '((4 a) b (2 c) (2 a) d (4 e))) )

(de encode-modified (Lst)
   (mapcar '((L) (if (= 1 (my-length L))
                    (car L)
                    (list (my-length L) (car L)) ) )
      (dupack Lst) ) )

(problem "12 Decode a run-length encoded list."
   (= (decode '((4 a) b (2 c) (2 a) d (4 e)))
      '(a a a a b c c a a d e e e e) ) )

(de decode (Lst)
   (cond
      ((not Lst) '())
      ((atom (car Lst)) (cons (car Lst) (decode (cdr Lst))))
      ((lst? (car Lst)) (append (need (car (car Lst)) (cadr (car Lst))) (decode (cdr Lst)))) ) )

(problem "13 Run-length encoding of a list (direct solution)."
   ## Don't build sub-lists of duplicates, just count them.
   (= (encode-direct '(a a a a b c c a a d e e e e))
      '((4 a) b (2 c) (2 a) d (4 e)) ) )

## Solution from PicoLisp By Example Book
## I wanted to see the idiomatic way to iteratively build lists
(de encode-direct (Lst)
   (make
      (while Lst
         (let (N 1 X)
            (while (= (setq X (pop 'Lst)) (car Lst))
               (inc 'N) )
            (link (if (= 1 N) X (list N X))) ) ) ) )

(problem "14 Duplicate the elements of a list."
   (= (dupli '(a b c c d))
      '(a a b b c c c c d d) ) )

(de dupli (Lst)
   (make
      (while Lst (let (E (pop 'Lst)) (link E E) ) ) ) )

(problem "15 Replicate the elements of a list a given number of times."
   (= (repli '(a b c) 3)
      '(a a a b b b c c c) ) )

(de repli (Lst N)
   (make
      (while Lst (let (E (pop 'Lst)) (do N (link E)))) ) )

(problem "16 Drop every N'th element from a list"
   (= (drop '(a b c d e f g h i j k) 3)
      '(a b d e g h j k) ) )

(de drop (Lst N)
   (let (Cnt N)
      (make
         (while Lst
            (let (E (pop 'Lst))
               (dec 'Cnt)
               (if (> Cnt 0) (link E) (setq Cnt N)) ) ) ) ) )

(problem "17 Split a list into two parts; the length of the first part is given"
   (= (my-split '(a b c d e f g h i k) 3)
      '((a b c) (d e f g h i k)) ) )

(de my-split (Lst N)
   (let (Fnt '())
      (while (> N 0) (queue 'Fnt (pop 'Lst)) (dec 'N))
      (list Fnt Lst) ) )

(de my-split2 (Lst N)
   (list (cut N 'Lst) Lst))

(problem "18 Extract a slice from a list."
   (= (slice '(a b c d e f g h i k) 3 7)
      '(c d e f g) ) )

(de slice (Lst I K)
   (head (inc (- K I)) (nth Lst I)) )

(problem "19-a Rotate a list N places to the left."
   (= (rotate '(a b c d e f g h) 3)
      '(d e f g h a b c) ) )

(problem "19-b Rotate a list -N places to the left."
   (= (rotate '(a b c d e f g h) -2)
      '(g h a b c d e f) ) )

(de rotate (Lst N)
   (let (N (- (length Lst) N))
      (do N (rot Lst)) ) )

(problem "20 Remove the K'th element from a list."
   (= (remove-at '(a b c d) 2)
      '(a c d) ) )

(de remove-at (Lst K)
   (remove K Lst) )

(problem "21")

(go)
