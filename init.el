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


(add-to-list 'load-path (expand-file-name "init.d" user-emacs-directory))

;; Package manager setup
(load "package_setup.el")

;; UI cleanup
(load "ui_cleanup.el")

;; Evil mode setup
(load "evil_mode.el")

;; GPTEL backend configuration
(load "gptel_setup.el")

;; Native filesystem tools for gptel
(load "fs_tools.el")
;; Local code execution tools for gptel
(load "code_tools.el")

;; Replacement utility tool
(load "replacement_tool.el")

;; Dynamic agent loader
(load "agent_loader.el")

;; Multi-agent delegation tool
(load "delegate_tool.el")

;; Reload tools (reload_os, reload_agent)
(load "reload_tools.el")

;; Memory summarization tool (C-c m in gptel-mode)
(load "memory_tools.el")

;; Elisp syntax checker tool
(load "check_elisp_tool.el")

;; Task reader and unified history tools
(load "task_tools.el")

;; Session persistence (save/restore gptel chat sessions)
(load "session_persistence.el")
