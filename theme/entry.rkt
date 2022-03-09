#lang racket

(require "../util.rkt")
(require "../html.rkt")
(require "../article.rkt")
(require "components.rkt")

(define (art-changed name)
  (define src-dir (format "source/articles/~a/" name))
  (define dest-dir (format "public/articles/~a/" name))
  (if (directory-exists? dest-dir)
    (> (file-or-directory-modify-seconds src-dir)
       (file-or-directory-modify-seconds dest-dir))
    #t))

(define ($entry)
  (define conf (dict ($open "source/config.ss")))

  (define arts
    (map
     (lambda (title)
       (printf "parsing ~v\n" title)
       (cons title ($load-article (format "source/articles/~a/index.ss" title))))
     (filter art-changed
       (cdr (assv 'articles conf)))))

  ; ($exec "rm -r public")
  ; ($exec "cp -r theme/static public")
  (make-directory* "public/articles")
  ($write "public/index.html" ($html (@/home conf)))
  ($write "public/articles/index.html" ($html (@/articles conf arts)))
  (map
   (lambda (art)
     (printf "generate ~v\n" (car art))
     (define src-dir (format "source/articles/~a/" (car art)))
     (define dest-dir (format "public/articles/~a/" (car art)))
     (make-directory* dest-dir)
     (when (not (assv 'password (cadr art)))
       ($exec (format "cp -r ~a* ~a" src-dir dest-dir)))
     ($write (format "~aindex.html" dest-dir) ($html (@/articles/title conf (cdr art)))))
   arts)
  (displayln "finish"))

(provide $entry)
