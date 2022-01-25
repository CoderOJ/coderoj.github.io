#lang racket

(require "../article.rkt")
(require "../encrypt.rkt")
(require "../html.rkt")

(define (@head title . flags)
  `(head
    ((meta (charset . "UTF-8")))
    ((link (rel . "stylesheet") (type . "text/css") (href . "/css/main.css")))
    ((link (rel . "icon") (type . "images/png") (href . "/images/favicon.png")))
    ((script (src . "/js/element.js")))
    (title ,title)

    ($inline
     ,(if (memv 'article flags)
          `(((link (rel . "stylesheet") (type . "text/css") (href . "/css/art.css")))
            ((link (rel . "stylesheet") (href . "//cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.2.0/build/styles/atom-one-light.min.css")))
            ((script (src . "//cdn.jsdelivr.net/gh/highlightjs/cdn-release@11.2.0/build/highlight.min.js")))
            ((script (src . "/js/language.min.js")))
            ((script (src . "/js/crypto-js.min.js"))))
          '()))))


(define (@sidebar conf type)
  `((div (class . "sidebar") (id . "sidebar"))

    ((div (class . "sidebar-title"))
     ((p (style . "font-weight: bold; font-size: 24px;"))
      ,(cdr (assv 'title conf)))
     ((div (class . "saying") (id . "saying"))))

    ((div (class . "sidebar-body"))
     ((ul (class . "sidebar-menu"))
      ($inline
       ,(for/list ([url '("/" "/articles")]
                   [name '(Home Articles)])
          `((a (href . ,url))
            ((li (class . "list-item sidebar-menu-item")
                 (style . ,(if (eqv? type name) "background: #e5e5e5" ""))) ,name)))))

     ((div (class . "sidebar-about"))
      ((div (style ."text-align: center; font-size: 16px;")) About me)
      ((hr (align . "center")))
      ((div (class . "avatar-rotate") (style . "margin: 2 auto; width: min-content"))
       ((img (class . "avatar") (alt . "Jacder") (src . "/images/avatar.png"))))
      ((ul (class . "sidebar-links"))
       ($inline
        ,(let ([socials (cdr (assv 'me conf))])
           (for/list ([social socials])
             `((li (class . "sidebar-links-item"))
               ((a (class . "friend-link") (href . ,(cdr social))) ,(car social))))))))

     ((ul (class . "sidebar-links"))
      ((div (style . "text-align: center; font-size: 16px;")) links)
      ((hr (align . "center")))
      ($inline
       ,(let ([friends (cdr (assv 'friends conf))])
          (for/list ([friend friends])
            `((li (class . "sidebar-links-item"))
              ((a (class . "friend-link") (href . ,(cdr friend))) ,(car friend))))))))))


(define @footer
  ((lambda () 
     (let ([footer ($load-article "source/footer.ss")])
       (lambda () footer)))))


(define (@article art)
  (define passwd (assv 'password (car art)))
  `((div (class . "root"))
    ,(if passwd
         `(article
           ((div (id . "encrypt-content") (style . "display: none"))
            ,($encrypt
              (cdr (assv 'password (car art)))
              ($html (cdr art))))
           (h1 被加密的文章)
           ((form (onsubmit . "return verifyPassword()"))
            (span 输入密码以查看：)
            ((input (class . "underline-input") (id . "password") (type . "password")))
            ((input (class . "gradual-button") (value . "submit") (type . "submit")))
            (br)
            (span 提示：  ,(cdr (assv 'hint (car art)))))
           (script "verifyCachedPassword();"))
         (cdr art))
    ,(@footer)
    (script
     "hljs.configure({ tabReplace: '  ' }); 
      hljs.highlightAll(); 
      loadMath();")))


(define (@/home conf)
  `(html
    ,(@head (cdr (assv 'title conf)) 'article)
    (body
     ((div (class . "content"))
      ,(@sidebar conf 'Home)
      ,(@article ($load-article "source/index.ss"))))))


(define (@/articles conf arts)
  `(html
    ,(@head (cdr (assv 'title conf)))
    (body
     ((div (class . "content"))
      ,(@sidebar conf 'Articles)

      ((div (class . "root art-list-container"))
       ((ul (class . "art-list"))
        ($inline
         ,(for/list ([art arts])
            `((a (href . ,(format "/articles/~a/" (car art))))
              ((li (class . "list-item art-list-item"))
               ((div (class . "art-list-item-title")) ,(cdr (assv 'title (cadr art))))
               ,(cons `(div (class . "art-list-item-tag")) (cdr (assv 'tag (cadr art))))))))))))))


(define (@/articles/title conf art)
  `(html
    ,(@head
      (format "~a - ~a"
              (cdr (assv 'title (car art)))
              (cdr (assv 'title conf)))
      'article)
    (body
     ((div (class . "content"))
      ,(@sidebar conf 'Articles)
      ,(@article art)))))


(provide @/home)
(provide @/articles)
(provide @/articles/title)
