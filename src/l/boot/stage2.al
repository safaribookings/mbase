;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   OpenMBase
;;
;; Copyright 2005-2014, Meta Alternative Ltd. All rights reserved.
;; This file is distributed under the terms of the Q Public License version 1.0.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-
;- \section{Stage 2 --- compiling the core library}
;-

(_Clean_Deps)
(include "../options.al")

(ctimex (println "Bootstrap stage: 2"))

(define ENV (cc:newenv))
(cc:env:defmodule ENV "boot2c" 'dll)

(define compiled-environment #t)

;;(define debug-compiler-drivertop #t)

(begin
  (cc:toplevel-devour ENV '(top-begin
			     (include "../boot/boot.al")
			     (include "../boot/initlib.al")
			     (include "../boot/dotnetlib.al")
			     (include "../boot/common.al")
                             (define core-environment-compiled #t)
                             ))
  )
(cc:dump-module ENV)
