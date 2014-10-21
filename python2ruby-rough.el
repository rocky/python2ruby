(defun python2ruby-regexp-search-replace (&optional start end replace-fn)
  "A rough-cut conversion of common Python strings to
corresponding Ruby strings"
  (dolist (args '(

		  ;; Some unit testing things
		  ("import unitttest" "require 'test/unit'")
		  ;; Should come before True -> true
		  ("self.assertTrue" "assert")
		  ("self.assertEqual" "assert_equal")
		  ("unittest.skip" "skip")
		  ("unittest.TestCase" "Test::Unit::TestCase")

		  ;; Python's dictionary update is Ruby's Hash
		  ;; merge or merge!  We rely on interactive aspect
		  ;; to allow a person to determine which is
		  ;; applicable. So we put this first before the
		  ;; user gets tired.
		  ("\\.update(" ".merge!(")

		  ;; re.search(a, b) => a.match(b)
		  ("re\\.search\\(.*\\), [ ]*" "\\1.match(")

		  ("\\.replace(" ".gsub(")

		  ;; List comprehension
		  ;; [fn(x) for x in rows] =>
		  ;; rows.map{|x| fn(x)}
		  ("\\[\\(.+\\)[ ]+for \\(.+\\) in \\(.+\\)\\]"
		   "\\3.map{|\\2| \\1}")

		  ;; zip(cols, coltypes) => cols.zip(coltypes)
		  ("\\zip(\\([^*].*\\),[ ]*\\(.+\\))" "\\1.zip(\\2)")

		  ;; Quoted hash elements, e.g
		  ;; 'abc' => Def
		  ("\\('[^']+'\\):\\([ 	]\\)*\\(.+\\)$" ;; '
		   "\\1\\2 => \\3")
		  ("\\(\"[^\"]+\"\\):\\([ 	]\\)*\\(.+\\)$"
		   "\\1\\2 => \\3")

		  ("\\([ 	]\\|^\\)continue\\($\\|[ 	]\\)" "\\1next\\2")
		  ("\\([ 	]\\|^\\)if not\\([ 	]\\|$\\)" "\\1unless\\2")

		  ("#!/usr/bin/env python" "#!/usr/bin/env ruby")

		  (" is not None" "")
		  (" is None" ".nil?")
		  ("len(\\(.*\\))" "\\1.size")
		  ("repr(\\(.*\\))" "\\1.inspect")
		  ("str(\\(.*\\))" "\\1.to_s")

		  ;; isinstance(tablefmt, TableFormat) =>
		  ;; tablefmt.kind_of?(TableFormat)
		  ("isinstance(\\(.*\\),[ ]*\\(.*\\))"
		   "\\1.kind_of?(\\2)")

		  ("re.sub(\\(.*\\),[ ]*\\(.*\\),[ ]*\\(.*\\))"
		   "\\3.gsub(\\1, \\2)")
		  ("re.match(\\(.*\\),[ ]*\\(.*\\))" "\\1.match(\\2)")
		  ("r'\\(.*\\)'" "%r{\\1}")
		  ("r\"\\(.*\\)\"" "%r{\\1}")
		  ("import re$" "#uses regexps")
		  ("import[:blank]+ urllib" "require 'uri'")
		  ("import urllib" "require 'uri'")
		  ("import urllib" "require 'uri'")
		  ("import \\(.*\\)$" "require '\\1'")
		  ("class \\(.*\\)(\\(.*\\)):$" "class \\1 < \\2")
		  ("class \\(.*\\):$" "class \\1") ;; has to come after above
		  ("def __repr__(self):$" "def inspect")
		  ("def __str__(self):$" "def to_s")
		  ("def __init__(self, \\(.*\\)):$" "def initialize(\\1")
		  ("def __init__(self):$" "def initialize")

		  ("def \\(.*\\)(\\(.*\\)[*][*]\\(.*\\)):$" "def \\1(\\2\\3={})")

		  ("def \\(.*\\)(self, \\(.*\\)):$" "def \\1(\\2)")
		  ("def \\(.*\\)(self):$" "def \\1")
		  ("elif \\(.*\\):" "elsif \\1") ;; has to come before "if"
		  ("if \\(.*\\):" "if \\1")
		  ("except \\(.*\\) as \\(.*\\):" "rescue \\1 => \\2")
		  ("except \\(.*\\):" "rescue \\1")
		  ("except:" "rescue")
		  ("else:" "else")
		  ("basestring" "String")
		  (".lower" ".downcase")
		  (".upper" ".upcase")
		  ("def \\(.*\\)):$" "def \\1)")
		  ("None" "nil") ("True" "true") ("False" "false")
		  ("try:" "begin")

		  ("print[:blank:]+\\(.*\\)$" "puts \\1")

		  ;; The following is just for the SolveBio API.
		  ;; It does no harm otherwise.
		  ("SolveBio::" "solvebio.")
		  ))
      (let ((replace-fn (or replace-fn 'query-replace-regexp))
	    (regexp    (car args))
	    (to-string (cadr args))
	    (delimited nil)
	    (old-case-fold case-fold-search)
	    (case-fold nil)
	    )
	(setq args (cddr args))
	(when args
	  (setq delimited (car args))
	  (setq args (cdr args))
	  (when args
	    (setq case-fold (car args))))
	(setq case-fold-search case-fold)
 	(funcall replace-fn regexp to-string delimited start end)
	(setq case-fold-search old-case-fold)
      )))

(defun python2ruby-rough ()
  "A rough-cut conversion of common Ruby lingo to the
corresponding Python lingo."
  (interactive "")
  (let* ((orig-name (buffer-name))
	 (ruby-name (concat (file-name-sans-extension orig-name) ".rb")))
    (set-visited-file-name ruby-name)
    (ruby-mode)
    (python2ruby-regexp-search-replace (point-min) (point-max))
    ))

(defun python2ruby-buffer-rough (buffer)
  (interactive "b")
  (with-current-buffer buffer
    (python2ruby-regexp-search-replace)
    )
)

(defun python2ruby2-region-rough (from to)
  (interactive "r")
  (python2ruby-regexp-search-replace from to)
)
