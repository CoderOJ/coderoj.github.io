#lang racket

(require "../util.rkt")
(require "../html.rkt")
(require "../article.rkt")
(require "components.rkt")

(define conf (dict ($open "source/config.ss")))

(define (init)
  ($exec "rm -r public")
  ($exec "cp -r theme/static public"))

(define (parse-art title)
  (printf "parsing ~v\n" title)
  (cons title ($load-article (format "source/articles/~a/index.ss" title))))

(define (gen-art art)
  (printf "generate ~v\n" (car art))
  (define src-dir (format "source/articles/~a/" (car art)))
  (define dest-dir (format "public/articles/~a/" (car art)))
  (make-directory* dest-dir)
  (when (not (assv 'password (cadr art)))
    ($exec (format "cp -r ~a* ~a" src-dir dest-dir)))
  ($write (format "~aindex.html" dest-dir) ($html (@/articles/title conf (cdr art)))))

(define (gen-single title)
  (define art (parse-art title))
  (gen-art art))

(define (gen)
  (define arts
    (map parse-art (cdr (assv 'articles conf))))

  (init)
  (make-directory* "public/articles")
  ($write "public/index.html" ($html (@/home conf)))
  ($write "public/articles/index.html" ($html (@/articles conf arts)))
  (map gen-art arts)
  (displayln "finish"))

(define ($entry argv)
  (match argv
    ['#() (gen)]
    [`#("gen" ,title) (gen-single title)]
    ['#("gen") (gen)]
    ['#("init") (init)]
    [else (printf "error: unkown command ~a\n" argv)]))

(provide $entry)
