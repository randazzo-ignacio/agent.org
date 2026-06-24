;; -*- lexical-binding: t; -*-

;; Emacboros --- Agent orchestration in Emacs
;; Copyright (C) 2026 Ignacio Agustín Randazzo
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.


(defun my-gptel--fs-replace (path search-text replace-text)
  "Find SEARCH-TEXT in PATH and replace it with REPLACE-TEXT.
SEARCH-TEXT is matched exactly as provided -- whitespace is significant."
  (condition-case err
      (with-temp-buffer
        (insert-file-contents path)
        (goto-char (point-min))
        (if (search-forward search-text nil t)
            (progn
              ;; Move point to start of match before replacing
              (replace-match replace-text t t)
              ;; Atomic write: write to temp file, then rename
              (let ((tmp-file (concat path ".tmp")))
                (write-region (point-min) (point-max) tmp-file nil 'silent)
                (rename-file tmp-file path t))
              (format "SUCCESS: Replaced text in %s" path))
          (format "ERROR: Target string not found in %s" path)))
    (error (format "Error: Could not modify file '%s'. Reason: %s"
                   path (error-message-string err)))))

(defun ouroboros-replace-in-file (path search-text replace-text)
  "Backward-compatible alias for `my-gptel--fs-replace'."
  (my-gptel--fs-replace path search-text replace-text))

(add-to-list 'gptel-tools
 (gptel-make-tool
  :name "replace_in_file"
  :description "Surgically replace a specific block of text in an existing file."
  :args (list '(:name "path" :type "string")
              '(:name "search_text" :type "string")
              '(:name "replace_text" :type "string"))
  :function #'my-gptel--fs-replace))

(provide 'replacement_tool)
