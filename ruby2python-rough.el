(defun ruby2python-regexp-search-replace (&optional start end replace-fn)
  "A rough-cut conversion of common Python strings to
corresponding Ruby strings"
    (dolist (args '(
		    ("class \\(\\w+\\) < \\(.+\\)" "class \\1(\\2):")

		    ("puts[ \t]+\\(.*\\)" "print(\\1)")

		    ("elsif \\(.*\\):" "elif \\1") ;; has to come before "if"
		    ("#!/usr/bin/env ruby" "#!/usr/bin/env python")
		    ("^\\([ 	]*\\)if \\(.*\\)$" "\\1if \\2:")
		    ("\\([ 	]*\\)else$" "\\1else:")
		    ("^\\([ 	]*\\)unless\\([ \t]*.*$\\)" "\\1if not\\2:")
		    ("String" "basestring")
		    (".downcase" ".lower")
		    ("end"       "pass")
		    (".upcase"   ".upper" )

		    ("\\.merge!(" ".update(")
		    ("\\.merge(" ".update(")

		    ("assert_equal" "self.assertEqual")
		    ("assert_raise" "self.assertRaises")

		    ("Integer(\\(.*\\))" "int(\\1)")

		    ;; Note have to handle things like
		    ;; ... False,
		    ;; xxx=>true,
		    ;; So can't use delimited text, but should not
		    ;; use case folding
		    ("false"      "False" nil nil)
		    ("nil"        "None"  nil nil)
		    ("true"       "True"  nil nil)

		    ("begin$"     "try:" )

		    ("require ['\"]test/unit['\"]" "import unittest")
		    ("require '\\(.+\\)'"  "import \\1")

		    ;; exit 5 => import sys; sys.exit(5)
		    ("exit[ 	]*\\(\\(?:[0-9]+\\)\\)$"
		     "import sys\nsys.exit(\\1)")

		    ;; Nuke ".new in Object creation.
		    ("\\(.+\\).new(\\(.+\\))"  "\\1(\\2)")

		    ("Test::Unit::TestCase" "unittest.TestCase")
		    ("def setup" "def setUp(self):")
		    ("def teardown" "def tearDown(self):")

		    ("__FILE__" "__file__")
		    ("File\\.join" "os.path.join")
		    ("File\\.dirname" "os.path.dirname")

		    ("def setup" "def setUp(self):")
		    ("def teardown" "def tearDown(self):")

		    ;; The following is just for the SolveBio API.
		    ;; It does no harm otherwise.
		    ("SolveBio::" "solvebio.")
		    ("SolveBio." "solvebio.")
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

(defun ruby2python-rough ()
  "A rough-cut conversion of common Python lingo to the
corresponding Ruby lingo. This should be done after adding Ruby
end's to the python code"
  (interactive "")
  (let* ((orig-name (buffer-name))
	 (python-name (concat (file-name-sans-extension orig-name) ".py")))
    (set-visited-file-name python-name)
    (python-mode)
    (ruby2python-regexp-search-replace (point-min))
    ))

(defun ruby2python-buffer-rough (buffer)
  (interactive "b")
  (with-current-buffer buffer
    (ruby2python-regexp-search-replace)
    )
)

(defun ruby2python-region-rough (from to)
  (interactive "r")
  (ruby2python-regexp-search-replace from to)
)
