(pool "usergroups.db")

# MODELS
(class +User +Entity)
(rel nr (+Key +Number))
(rel nm (+Idx +String))
(rel mshp (+List +Joint) user (+Mshp))

(dm url> (Tab)
   (list "!user" '*ID This) )

(class +Group +Entity)
(rel nm (+Idx +String))
(rel mshp (+List +Joint) group (+Mshp))

(class +Mshp +Entity)
(rel role (+Ref +String))
(rel user (+Joint) mshp (+User))
(rel group (+Joint) mshp (+Group))

# INIT
(obj ((+User) nr 1 nm "Grant"))
(obj ((+Group) nm "Go Club"))
(obj ((+Mshp) role "Organizer")
      user `(db 'nr '+User 1)
      group `(db 'nm '+Group "Go Club") )

(commit)

(html 0 "Hello Web" "@lib.css" NIL
   (<h1> NIL "Hello, web")
   (<p> NIL
      "This is my first PicoLisp website ..." ) )
