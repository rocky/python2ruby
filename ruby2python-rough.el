(defun ruby2python-regexp-search-replace (start)
  "A rough-cut conversion of common Python strings to
corresponding Ruby strings"
    (dolist (tuple '(
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
		     ("nil"        "None" ) ("true" "True") ("false" "False")
		     ("begin$"     "try:" )

		     ("require ['\"]test/unit['\"]" "import unittest")
		     ("require '\\(.+\\)'"  "import \\1")

		     ("exit[ 	]*\\(\\(?:[0-9]+\\)\\)$"
		      "import sys\nsys.exit(\\1)")

		     ;; Nuke ".new in Object creation.
		     ("\\(.+\\).new(\\(.+\\))"  "\\1(\\2)")

		     ;; The following is just for the SolveBio API.
		     ;; It does no harm otherwise.
		     ("SolveBio::" "solvebio.")
		     ("SolveBio." "solvebio.")
		     ))
      (goto-char start)
      (query-replace-regexp (car tuple) (cdr tuple))
      ))

(defun ruby2python-rough ()
  "A rough-cut conversion of common python lingo to the
corresponding ruby lingo. This should be done after adding Ruby
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
    (ruby2python-regexp-search-replace (point-min))
    )
)

(defun ruby2python-region-rough (from)
  (interactive "m")
  (ruby2python-regexp-search-replace from)
)
