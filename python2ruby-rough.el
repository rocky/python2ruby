(defun python2ruby-rough ()
  "A rough-cut conversion of common python lingo to the
corresponding ruby lingo. This should be done after adding Ruby
end's to the python code"
  (interactive "")
  (let* ((orig-name (buffer-name))
	 (ruby-name (concat (file-name-sans-extension orig-name) ".rb")))
    (set-visited-file-name ruby-name)
    (dolist (tuple '(
		     ("len(\\(.*\\))" "\\1.size")
		     ("isinstance(\\(.*\\),[ ]*\\(.*\\))"
		      "\\1.kind_of?(\\2)")
		     ("re.sub(\\(.*\\),[ ]*\\(.*\\),[ ]*\\(.*\\))"
		      "\\3.gsub(\\1, \\2)")
		     ("re.match(\\(.*\\),[ ]*\\(.*\\))" "\\1.match(\\2)")
		     ("r'\\(.*\\)'" "%r{\\1}")
		     ("r\"\\(.*\\)\"" "%r{\\1}")
		     ("import re$" "#uses regexps")
		     ("import urllib" "require 'uri'")
		     ("import \\(.*\\)$" "require '\\1'")
		     ("class \\(.*\\)(\\(.*\\)):$" "class \\1 < \\2")
		     ("class \\(.*\\):$" "class \\1") ;; has to come after above
		     ("def __repr__(self):$" "def inspect")
		     ("def __str__(self):$" "def str")
		     ("def __init__(self\\(.*\\)):$" "def initialize(\\1")

		     ("def \\(.*\\)(\\(.*\\)[*][*]\\(.*\\)):$" "def \\1(\\2\\3={}):")

		     ("def \\(.*\\)(self, \\(.*\\)):$" "def \\1(\\2)")
		     ("def \\(.*\\)(self):$" "def \\1")
		     ("elif \\(.*\\):" "elsif \\1") ;; has to come before "if"
		     ("if \\(.*\\):" "if \\1")
		     ("except \\(.*\\) as \\(.*\\):" "rescue \\1 => \\2")
		     ("except \\(.*\\):" "rescue \\1")
		     ("except:" "rescue")
		     ("else:" "else")
		     ("continue" "next")
		     ("basestring" "String")
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
