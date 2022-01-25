#lang racket

(define (dict assocs) assocs)
  ; (make-hasheqv
  ;   (map (lambda (x) (if (list? (cdr x)) (cons (car x) (dict (cdr x))) x)) assocs)))

(define ($open filename)
  (define port (open-input-file filename))
  (define result
    (let loop ()
      (let ([a (read port)]) 
        (if (eqv? a eof) '() (cons a (loop))))))
  (close-input-port port)
  result)

(define ($exec cmd)
  (define-values 
    (sp out in err) 
    (subprocess #f #f #f "/usr/bin/env" "bash" "-c" cmd))
  (define result (cons (port->string out) (port->string err)))
  (close-input-port out)
  (close-output-port in)
  (close-input-port err)
  (subprocess-wait sp)
  result)

(define ($write file str)
  (define port (open-output-file file #:mode 'text #:exists 'replace))
  (display str port)
  (close-output-port port))

(provide dict)
(provide $open)
(provide $exec)
(provide $write)
