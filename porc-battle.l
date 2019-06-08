(setq *PlayerHealth NIL)
(setq *PlayerAgility NIL)
(setq *PlayerStrength NIL)

(setq *Monsters NIL)
(setq *MonsterBuilders NIL)
(setq *MonsterNum 6)

(de main ()
   (init-monsters)
   (init-player)
   (game-loop)
   (when (dead?> *Player)
      (prinl "You have been killed. Game over!") )
   (when (not (living-monsters))
      (prinl "Congratulations! You have slain all the porc!") )
   (bye) )

(de game-loop ()
   (unless (or (dead?> *Player) (not (living-monsters)))
      (show> *Player)
      (do (inc (/ (max 0 (get *Player 'agility)) 15) )
         (when (living-monsters)
            (show-monsters)
            (atk> *Player) ) )
      (prinl)
      (mapcar
         '((M) (or (dead?> M) (atk> M)))
         *Monsters )
      (game-loop) ) )

(de init-player ()
   (setq *PlayerHealth 30)
   (setq *PlayerAgility 30)
   (setq *PlayerStrength 30)
   (setq *Player (new '(+Knight))) )

(de init-monsters ()
   (do *MonsterNum
      (push '*Monsters (eval (get *MonsterBuilders (rand 1 (length *MonsterBuilders))))) ) )

(de show-monsters ()
   (prinl "The monsters gather near!")
   (for (I . M) *Monsters (prin I ": ") (show> M)) )

(de living-monsters ()
   (filter 'alive?> *Monsters) )

(de pick-monster ()
   (prin "Which monster to attack? ")
   (get *Monsters (read)) )

(de random-monster ()
   (get (living-monsters) (rand 1 (length (living-monsters)))) )

(de roll-die (Sides) (rand 1 Sides))

(class +being)
# health
(dm alive?> () (> (: health) 0))
(dm dead?> () (<= (: health) 0))
(dm hit> (Dmg) (dec (:: health) Dmg))
(dm kill> () (=: health 0))

(class +Knight +being)
(dm T ()
   (=: health *PlayerHealth)
   (=: strength *PlayerStrength)
   (=: agility *PlayerAgility) )

(dm show> ()
   (prinl)
   (prinl
      "You are a valiant knight with a health of " (: health) ", "
      "an agility of " (: agility) ", "
      "and a strength of " (: strength) ) )

(dm atk> ()
   (prinl)
   (prin "Attack style: [s]tab [d]ouble swing [r]oundhouse: ")
   (case (read)
      (s (hit> (pick-monster) (+ 2 (rand 0 (>> 1 (: strength))))))
      (d (let (X (rand 0 (/ (: strength) 6)))
            (prinl "Your double swing has a strength of " X)
            (prinl)
            (hit> (pick-monster) X)
            (when (living-monsters) (hit> (pick-monster) X)) ) )
      (T (do (+ 1 (rand 0 (/ (: strength) 3)))
            (when (living-monsters)
               (hit> (random-monster) 1) ) ) ) ) )

(class +Monster +being)
# health desc
(dm T () (=: health (rand 1 10)))

(dm show> ()
   (prinl (if (dead?> This)
             (text "dead @1" (: desc))
             (: desc) ) ) )

(dm hit> (Dmg)
   (super)
   (if (dead?> This)
      (prinl (text "You killed the @1" (: desc)))
      (prinl (text "You hit the @1 for @2 health!" (: desc) Dmg)) ) )

(class +Porc +Monster)
(dm T ()
   (=: club-level (rand 1 8))
   (=: desc (text "wicked orc with a level @1 club" (: club-level)))
   (super) )

(dm atk> ()
   (let (X (rand 1 (: club-level)))
      (prinl "An orc swings xer club at you and knocks off " X " of your health points.")
      (hit> *Player X) ) )

(push '*MonsterBuilders '(new '(+Porc)))

(class +Slime +Monster)
(dm T ()
   (=: desc "gooey slime") (super)
   (=: sliminess (roll-die 5)) )

(dm atk> ()
   (prin "it goos all over you! ")
   (let (X (roll-die (: sliminess)))
      (prin "Your agility is lowered by " X "! ")
      (with *Player (dec (:: agility) X))
      (when (rand T)
         (prin "The goo burns you and you lose " 1  "health!") ) ) )

(push '*MonsterBuilders '(new '(+Slime)))

(de drn ()
   (let (Rolls '() Current (rand 1 6))
      (loop
         (push 'Rolls (if (= Current 6) 5 Current))
         (setq Current (rand 1 6))
         (NIL (= 6 Current) (sum + Rolls)) ) ) )

(de DRN () (+ (drn) (drn)))
