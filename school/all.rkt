#!/usr/bin/env racket
#lang plt-web
(require racket/runtime-path
         "../identity.rkt"
         "../testing.rkt"
         "../www/resources.rkt"
         "../annual-utils.rkt")

(define school-site
  (site "school"
        #:url (rewrite-for-testing "https://school.racket-lang.org/")
        #:page-headers (identity-headers)
        #:share-from www-site))

(register-identity school-site)

(define-syntax-rule (copy-school-site! ARG ...)
  (copy-annual-site! school-site ARG ...))

;; 2019 
(define-runtime-path 2019-dir "2019")
(pollen-rebuild! 2019-dir)
(copy-school-site! 2019-dir 2019 #:current #t)

;; Redirect root index.html to 2019/index.html
;; (used only when placeholder page exists)
#;(void
 (symlink #:site school-site
          "2019/index.html"
          "index.html"))

(define-runtime-path current-school-index "2019/index.html")
(provide index)
(define index
  (page* #:site school-site
         #:link-title "Racket School" #:title "Racket School"
         #:id 'school
         @copyfile[#:site school-site current-school-index]))
