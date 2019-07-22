(default *Bounds '(1 . 100))

(de small ()
   (car *Bounds) )

(de big ()
   (cdr *Bounds) )

(de guess-my-number ()
   (if (> (small) (big))
      (msg "cheat")
      (/ (+ (small) (big)) 2) ) )

(de smaller ()
   (set '*Bounds (cons (small) (dec (guess-my-number))))
   (guess-my-number) )

(de bigger ()
   (set '*Bounds (cons (inc (guess-my-number)) (big)))
   (guess-my-number) )

#-----
(app)
(default *Guess (guess-my-number))

(action
   (html 0 "Guess My Number" "@lib.css" NIL
      (form NIL
         (<div> 'main
            (gui '(+Style +Var +TextField) "guess" '*Guess)
            (<div> 'buttons
               (gui '(+JS +Button) "Smaller" '(setq *Guess (smaller)))
               (gui '(+JS +Button) "Bigger" '(setq *Guess (bigger))) ) ) ) ) )
      