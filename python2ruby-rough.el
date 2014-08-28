(defun python2ruby-rough ()
  "A rough-cut conversion of common python lingo to the
corresponding ruby lingo. This should be done after adding Ruby
end's to the python code"
  (interactive "")
  (let* ((orig-name (buffer-name))
	 (ruby-name (concat (file-name-sans-extension orig-name) ".rb")))
    (set-visited-file-name ruby-name)
    (dolist (tuple '(
		     ("class \\(.*\\)(\\(.*\\)):$" "class \\1 < \\2")
		     ("class \\(.*\\):$" "class \\1") ;; has to come after above
		     ("def __repr__(self):$" "def inspect")
		     ("def __str__(self):$" "def str")
		     ("def __init__(self\\(.*\\)):$" "def initialize(\\1")

		     ;; Not complete to Ruby. Below regexps finish the job
		     ("def \\(.*\\)(\\(.*\\)[*][*]\\(.*\\)):$" "def \\1(\\2\\3={}):")

		     ("def \\(.*\\)(self, \\(.*\\)):$" "def \\1(\\2)")
		     ("def \\(.*\\)(self):$" "def \\1")
		     ("elif \\(.*\\):" "elsif \\1") ;; has to come before "if"
		     ("if \\(.*\\):" "if \\1")
		     ("except \\(.*\\) as \\(.*\\):" "rescue \\1 => \\2")
		     ("except \\(.*\\):" "rescue \\1")
		     ("except:" "rescue")
		     ("else:" "else")
		     ("if not" "unless")
		     (".lower" ".downcase")
		     (".upper" ".upcase")
		     ("def \\(.*\\)):$" "def \\1)")
		     ("None" "nil") ("True" "true") ("False" "false")
		     ("try:" "begin")
		     ))
      (goto-char (point-min))
      (query-replace-regexp (car tuple) (cdr tuple))
      )))
