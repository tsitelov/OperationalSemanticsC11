#lang racket
(require redex/reduction-semantics)
(require "../core/syntax.rkt")
(require "../core/coreLang.rkt")
(require "../core/coreUtils.rkt")
(require "../rules/postReadRules.rkt")
(require "../rules/rlxRules.rkt")
(require "../rules/relAcqRules.rkt")
(require "../rules/scRules.rkt")
(require "../core/langs.rkt")
(provide defaultState step)

(define-term defaultState (() (Read ()) (NA ()) (Write ()) (SC ()) (P ()) (R ())))
(define coreStep
  (extend-reduction-relation
   (define-coreStep defaultState spwST_2ψ_φ joinST_2ψ_φ isReadQueueEqualTo)
   etaPsi2SCpostLang #:domain ξ))
(define coreTest (define-coreTest coreStep defaultState))

(define postponedReadRules (define-postponedReadRules etaPsi2SCpostLang))
(define rlxWriteRules      (define-rlxWriteRules      etaPsi2SCpostLang
                             getWriteσ_2ψ isReadQueueEqualTo ιNotInReadQueue))
(define relAcqWriteRules   (define-relAcqWriteRules   etaPsi2SCpostLang
                             addReadNode_t
                             synchronizeWriteFront isReadQueueEqualTo
                             are∀PostReadsRlx ιNotInReadQueue 
                             addWriteNode_t))
(define scRules            (define-scRules            etaPsi2SCpostLang
                             getReadσ updateReadσ synchronizeWriteFront isReadQueueEqualTo
                             are∀PostReadsRlx ιNotInReadQueue))
(define step (union-reduction-relations
              coreStep
              postponedReadRules
              rlxWriteRules
              relAcqWriteRules
              scRules))