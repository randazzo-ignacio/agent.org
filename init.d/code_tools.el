;; -*- lexical-binding: t; -*-

;; Native Local Code Execution tool definition for gptel
(add-to-list 'gptel-tools
 (gptel-make-tool
  :name "execute_code_local"
  :description "Execute bash commands in the same container as the Emacs tools (has access to source code)."
  :args (list '(:name "command" :type "string" :description "The bash command to execute."))
  :function (lambda (command)
              (condition-case nil
                  (shell-command-to-string command)
                (error (format "Error: Failed to execute command: %s" command))))))