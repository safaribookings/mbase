;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;   OpenMBase
;;
;; Copyright 2005-2014, Meta Alternative Ltd. All rights reserved.
;; This file is distributed under the terms of the Q Public License version 1.0.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;-
;- \subsection{An internal AST for PEGs}
;-

(def:ast packrat ()
  (*TOP* <ntexprs>)

  (ntexprs <*ntexpr:es>)

  (ntexpr
   (| 
      (terminal <id:ttype> <id:name> <expr:value> 
                <dualcode:constr> . <*report:r>)
      (binaries <id:ttype> <id:name> <expr:lr>
               <*binvar:vs> . <*report:r>)
      (with-ignore <id:igname>)
      (define <id:name> <*id:argnames> <expr:e> <dualcode:constr> . <*report:r>)
      (rule <id:name> <expr:e> <dualcode:constr>)
      (dynahook <id:name>)
      ;; syntax sugar to be expanded into binaries
      (src-binaries <id:ttype> <id:name>
		    <*srcbinvar:vs> . <*report:r>)
      
      ))

  (dualcode (<annot:a> <code:c>))
  (binvar (<number:prec> <assoctp:assoc> <expr:op> <dualcode:constr> . <*report:r>))
  (srcbinvar (| (simple <expr:e>)
		(binary <number:prec> <assocptl:assoc> <expr:e>
			<dualcode:constr>)))
  (code
   (|
      (var <id:name>)
      (const <id:s>)
      (fcall <id:fname> . <*code:ars>)
      (constr <id:cname> . <*carg:ars>)
      (action <lisp:code>) ;; USE WITH CAUTION
      (auto . <*id:tagname>) ;; to be replaced with an automatically inferred code
      (nop)
      ))
  (carg
   (| (set <id:var> <code:val>)
      (append <id:var> <code:val>)
      ))
  
  (expr
   (| (seq . <*expr:es>)   ; E1 E2 ...
      (palt . <*expr:es>)  ; E1 / E2 ...
      (pdalt . <*expr:es>)  ; E1 / E2 ...

      (merge . <*expr:es>) ; merge alternative branches

      (andp <expr:e>)    ; & E
      (notp <expr:e>)    ; ! E
      (plus <expr:e>)    ; E +
      (star <expr:e>)    ; E *
      (maybe <expr:e>)   ; E ?
      (trivial <pred:p>) ; trivial recognisers (characters, strings, ...)
      (withignore <id:terms> <expr:e>)

      (withfilter <any:f> <expr:e>)

      (bind-terminal <id:fname> <id:tname> . <*id:rec>)
      (bind <id:name> <expr:e>)
      (terminal <id:name> . <*id:rec>)
      (simple   <id:name>)
      (lift <expr:e> <dualcode:c> . <*report:r>)
      (rule <id:name> <str:body>)
      (macroapp <id:name> . <*expr:args>)

      (action <id:name> <any:args>) ; Action over environment,
                                    ; does not affect parsing

      (highorder <*id:args> <id:maker>)
      (check <id:name>)
      (hint <id:name> <*any:args>)  ; backend-specific hint, ignored by parser
      )))

(def:ast pktrivial ()
  (*TOP* <pred>)
  (pred
   (| (char <int:chr>)
      (anychar)
      (range <int:from> <int:to>)
      (or . <*pred:ps>)
      (string . <lstring:str>)
      (sstring <string:str>)
      (fail) ; always fails
      )))

