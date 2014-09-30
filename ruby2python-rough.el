(defun ruby2python-rough ()
  "A rough-cut conversion of common python lingo to the
corresponding ruby lingo. This should be done after adding Ruby
end's to the python code"
  (interactive "")
  (let* ((orig-name (buffer-name))
	 (python-name (concat (file-name-sans-extension orig-name) ".py")))
    (set-visited-file-name python-name)
    (dolist (tuple '(
		     ("elsif \\(.*\\):" "elif \\1") ;; has to come before "if"
		     ("#!/usr/bin/env ruby" "#!/usr/bin/env python")
		     ("^\\([:blank:]\\)if \\(.*\\)$" "\\1if \\2:")
		     ("\\([:blank:]\\)else$" "\\1else:")
		     ("^\\([:blank:]*\\)unless\\([:blank:]*\\)" "\\1if not\\2")
		     ("String" "basestring")
		     (".downcase" ".lower")
		     ("end"       "pass")
		     (".upcase"   ".upper" )
		     ("nil"        "None" ) ("true" "True") ("false" "False")
		     ("begin$"     "try:" )
		     ("require '\\(.+\\)'"  "import \\1")
		     ("exit[ 	]*\\(\\(?:[0-9]+\\)\\)$"
		      "import sys\nsys.exit(\\1)")

		     ;; Nuke ".new in Object creation.
		     ("\\(.+\\).new(\\(.+\\))"  "\\1(\\2)")

		     ("puts[:blank:]*\\(.*\\)$" "print(\\1)")

		     ;; The following is just for the SolveBio API.
		     ;; It does no harm otherwise.
		     ("SolveBio::" "solvebio.")
		     ))
      (goto-char (point-min))
      (query-replace-regexp (car tuple) (cdr tuple))
      )))
