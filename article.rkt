#lang racket

(require "util.rkt")
(require racket/format)

(define-namespace-anchor art-ns-anchor)
(define art-ns (namespace-anchor->namespace art-ns-anchor))

; macros used inside articles
(define-syntax-rule ($article config . content)
  (cons (dict (quasiquote config)) (cons 'article (quasiquote content))))
(define-syntax-rule ($link url . content)
  (cons `(a (href . ,(format "~a" (quasiquote url)))) (quasiquote content)))
(define-syntax-rule ($img url . content)
  (cons `(img (src . ,(format "~a" (quasiquote url)))) (quasiquote content)))
(define-syntax-rule ($code lang content)
  (list 'pre (list `(code (class . ,(format "lang-~a" (quasiquote lang)))) 
                   (string-trim content "\n"))))
(define-syntax-rule ($math . content)
  (cons `(script (type . "math/tex")) (quasiquote content)))
(define-syntax-rule ($math-block . content)
  (cons `(script (type . "math/tex; mode=display")) (quasiquote content)))

(define (parse-raw-string str)
  (define (list-take-first eq a p)
    (if (and (not (null? a)) (eq (car a) p)) 
      (let-values ([(lh rh) (list-take-first eq (cdr a) p)])
        [values (cons (car a) lh) rh])
      [values '() a]))
  (define (list-is-prefix eq a b)
    (if (null? b) #t 
      (and (not (null? a)) (eq (car a) (car b)) (list-is-prefix eq (cdr a) (cdr b)))))
  (define (list-search eq a b)
    (if (null? a) [values '() '()]
      (if (list-is-prefix eq a b) 
        [values '() (list-tail a (length b))]
        (let-values ([(lhs rhs) (list-search eq (cdr a) b)]) 
          [values (cons (car a) lhs) rhs]))))
  (define (parse last cur in-quote)
    (define (shift) (set! last (cons (car cur) last)) (set! cur (cdr cur)))
    (define (next) (parse last cur in-quote))
    (cond
      [(null? cur) (reverse last)]
      [(and (not in-quote) (eqv? (car last) #\`))
       (if (eqv? (car cur) #\`) 
         (begin (shift) (next))
         (let*-values ([(sp rem) (list-take-first eqv? last #\`)]
                       [(lh rh) (list-search eqv? cur sp)]
                       [(raw) (format "~v" (list->string lh))])
           (parse (cons raw rem) rh #f)))]
      [(and in-quote (eqv? #\\ (car cur))) 
       (begin (shift) (shift) (next))]
      [(eqv? #\" (car cur)) 
       (begin (set! in-quote (not in-quote)) (shift) (next))]
      [#t (begin (shift) (next))]))
  (apply string-append (map ~a (parse '("") (string->list str) #f))))

(define ($load-article filename)
  (define port (open-input-file filename))
  (define result-string (parse-raw-string (port->string port)))
  (define result-port (open-input-string result-string))
  (define result (read result-port))
  (close-input-port port)
  (close-input-port result-port)
  (eval result art-ns))

(provide $load-article)
(provide parse-raw-string)
