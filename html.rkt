#lang racket

(require racket/format)

(define self-closing
  '(br))

(define none-encode-list 
  '(script))

(define (child-insert-space lst)
  (match lst
    ['() '()]
    [(list a) (list a)]
    [(list a b ...)
     (if (and (string? a) (string? (car b)))
       (cons a (child-insert-space b))
       (cons a (cons " " (child-insert-space b))))]))


(define (dom->string tag props child)
  (if (memv tag self-closing)
    (format "<~a>" tag)
    (format 
      "<~a>~a</~a>" 
      (string-join
        (cons (~a tag)
              (map (lambda (p) (format "~s=~s" (car p) (cdr p))) props)))
      (string-join 
        (map 
          (lambda (s)
            (domtree->string s (not (memv tag none-encode-list))))
          (child-insert-space child)) 
        "")
      tag)))

(define (encode-text str)
  (apply string-append
    (map (lambda (c)
           (match c
             [#\< "&lt;"]
             [#\> "&gt;"]
             [#\& "&amp;"]
             [x (string x)]))
         (string->list str))))

(define (domtree->string tree encode)
  (match tree
    [(list '$inline (? list? child)) 
     (string-join 
       (map (lambda (input) (domtree->string input encode)) child) 
       " ")]
    [(list (list tag props ...) child ...) (dom->string tag props child)]
    [(list (? symbol? tag) child ...) (dom->string tag '() child)]
    [#t "true"] [#f "false"]
    [a (if encode (encode-text (~a a)) (~a a))]))

(define ($html input)
  (domtree->string input #t))

(provide $html)
