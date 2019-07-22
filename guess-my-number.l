(set '*Bounds '(1 . 100))

(de small ()
   (car *Bounds) )

(de big ()
   (cdr *Bounds) )

(de guess-my-number ()
   (if (> (small) (big))
      (cheater)
      (>> 1 (+ (small) (big))) ) )

(de smaller ()
   (set '*Bounds (cons (small) (dec (guess-my-number))))
   (guess-my-number) )

(de bigger ()
   (set '*Bounds (cons (inc (guess-my-number)) (big)))
   (guess-my-number) )

(de cheater ()
   (prinl '(You " " cheated!))
   (bye) )

(de go ()
   (prinl (text "Think of a number between @1 and @2!" (small) (big)))
   (wait 2000)
   (prinl "Here we go! My first guess is... ")
   (guess-my-number) )