(defun perl2python-regexp-search-replace (&optional start end replace-fn)
  "A rough-cut conversion of common Perl strings to
corresponding Python strings"
  (dolist (args '(

		  ;; Nuke these. Should come before general "use" translation.
		  ("use strict;" "")
		  ("use warnings;" "")
		  ("use constant \\(.+\\) => \\(.+\\);"
		   "\\1 = \\2")

		  ("use \\(.+\\);"     "import \\1")

		  ;; "new" custom cases come before general cases
		  ("sub new\\([ 	].*\\){" "def __init__(self):")
		  ("sub new \\(.*\\){" "def __init__ \\1:")
		  ("sub new \\(.*\\){" "def __init__ \\1:")
		  ("sub \\(.+\\){"     "def \\1:")

		  ("^=head[1-4]"      "'''")
		  ("^=cut"            "'''")
		  ("^=pod"            "'''")

		  ("use strict;" "")
		  ("unless (caller) {"  "if __name__=='__main__'")

		  ("\\([ 	]+\\)last;" "\\1break")
		  ;; Not quite right, but we should have something else
		  ;; to convert break if.
		  ("\\([ 	]+\\)last if" "\\1break if")

		  ;; It is presumed that this after an new/__init__
		  ("my $class = shift;" "")


		  ;; Should come before general arrow (->) handling
		  ("->new"  "")

		  ;; Should come before handling colon (:)
		  ("\\([ 	(]+\\)defined \\(.+\\)\\([ 	)]+\\)"
		   "\\1\\2\\3is not None")
		  ("\\([ 	(]+\\)defined(\\(.+\\))"
		   "\\1\\2 is not None")

		  ;; custom cases before general cases
		  ("} elsif (\\(.+\\)) {"  "elif \\1:")
		  ("elsif (\\(.+\\)) {"  "elif \\1:")
		  ("} else {"  "else:")
		  ("else {"  "else:")

		  ("if (\\(.+\\)) {"  "if \\1:")
		  ("unless[ 	]*(\\(.+\\)) {"  "if not \\1:")

		  (" && "  " and ")
		  (" eq "  " == ")
		  (" ne "  " != ")
		  ("->"  ".")
		  ("\\([ 	]\\)+undef"  "\\1None")

		  ("[ 	]+=> "  ": ")

		  ("^1;$"      "")

		  ("\\$self"  "self")

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

(defun perl2python-rough ()
  "A rough-cut conversion of common Perl lingo to the
corresponding Python lingo."
  (interactive "")
  (let* ((orig-name (buffer-name))
	 (python-name (concat (file-name-sans-extension orig-name) ".py")))
    (set-visited-file-name python-name)
    (python-mode)
    (perl2python-regexp-search-replace (point-min))
    ))

(defun perl2python-buffer-rough (buffer)
  (interactive "b")
  (with-current-buffer buffer
    (perl2python-regexp-search-replace)
    )
)

(defun perl2python-region-rough (from to)
  (interactive "r")
  (perl2python-regexp-search-replace from to)
)
