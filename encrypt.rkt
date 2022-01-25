#lang racket

(require crypto)
(require crypto/libcrypto)
(require base64)
(crypto-factories (list libcrypto-factory))

(define ($encrypt pass str)
  (define key (digest 'sha256 (format "~a" pass)))
  (define iv (subbytes key 0 16))
  (base64-encode (encrypt '(aes cbc) key iv str)))

(provide $encrypt)