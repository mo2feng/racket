#lang racket/base

(provide report-configuration?
         current-report-configuration)

(define (report-configuration? v)
  (define (procedure1? key)
    (define p (hash-ref v key #f))
    (and (procedure? p) (procedure-arity-includes? p 1)))
  (and (hash? v)
       (immutable? v)
       (procedure1? 'literal-to-what)
       (procedure1? 'literal-to-string)
       (procedure1? 'datum-to-what)
       (procedure1? 'datum-to-string)))

(define current-report-configuration
  (make-parameter (hasheq 'literal-to-what (lambda (v)
                                             '("identifier" "identifiers"))
                          'literal-to-string (lambda (v)
                                               (format "`~s'" (if (syntax? v)
                                                                  (syntax-e v)
                                                                  v)))
                          'datum-to-what (lambda (v)
                                           (if (symbol? v)
                                               '("literal symbol" "literal symbols")
                                               '("literal" "literals")))
                          'datum-to-string (lambda (v)
                                             (if (symbol? v)
                                                 (format "`~s'" v)
                                                 (format "~s" v))))
                  (lambda (v)
                    (unless (report-configuration? v)
                      (raise-argument-error 'current-report-configuration "report-configuration?" v))
                    v)))