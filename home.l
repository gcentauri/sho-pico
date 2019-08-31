(load "@lib/http.l" "@lib/xhtml.l")

(de home ()
   (html 0 "Hello Web" "@lib.css" NIL
      (<h1> NIL "Hello, web")
      (<p> NIL
         "This is my first PicoLisp website ..." )
      (<href> "Guessing Game" "/guess") ) )

(de go ()
   (server 4000 "!home") )