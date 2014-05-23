;; -- emacs 24, kubuntu


;; (defvar scrumdo-username "shm" "Scrumdo user (set it for automatic login)")
;; (defvar scrumdo-password "jukilo90" "Scrumdo password (set it for automatic login)")
;; (defvar scrumdo-organization '("dbc" "Dansk BiblioteksCenter") "Scrumdo default organization (set it for automatic login)")
;; (defvar scrumdo-project '("opensearch" "Search") "Scrumdo default project (set it for automatic login)")
;; (defvar scrumdo-backlog '(1105 "Backlog") "Scrumdo default backlog (set it for automatic login)")

;; (add-to-list 'load-path "/home/user/.emacs.d/scrumdo/")
;; (defvar scrumdo-home "/home/user/.emacs.d/scrumdo/")
;; (require 'scrumdo-mode)

;;------------------------------------------------------------------------------
;;  Load Paths
;;------------------------------------------------------------------------------
(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/my-code/3rdParty")
(add-to-list 'load-path "~/.emacs.d/my-code/base-0.1")
(add-to-list 'load-path "~/.emacs.d/my-code/pybuilder-0.1/")

;;------------------------------------------------------------------------------
;; Package archives
;;------------------------------------------------------------------------------
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;;------------------------------------------------------------------------------
;; Settings
;;------------------------------------------------------------------------------
(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)

;; -- Looks
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))           ;; No scrollbar
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))               ;; No toolbar
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))               ;; No menubar
(if (fboundp 'blink-cursor-mode) (blink-cursor-mode 0))        ;; Stop cursor from blinking
(column-number-mode t)                                         ;; Turn on column numbering in status line
(setq display-time-format "%R %d-%m-%y")                       ;; Show time on status bar
(display-time)
(show-paren-mode t)                                            ;; Show parenthesis
'(blink-matching-paren-on-screen t)

;; -- General behaviour
(fset 'yes-or-no-p 'y-or-n-p)                                  ;; Make the y or n suffice for a yes or no question
(setq next-line-add-newlines nil)                              ;; Stop "down"-arrow from adding CR to end of file
(mouse-avoidance-mode (quote exile))                           ;; Moves mouse pointer when cursor is near
(setq inhibit-startup-message t)                               ;; This is to not display the initial message.
(setq visible-bell t)                                          ;; Visible bell instead of beeping hell
(setq shift-select-mode t)                                     ;; Use shift select
(setq font-lock-maximum-size 1256000)                          ;; Increase the maximum size on buffers that should be fontified
(setq-default ispell-program-name "aspell")                    ;; Choose aspell instead of ispell
(setq-default indent-tabs-mode nil)                            ;; Use spaces instead of tabs
(setq-default tab-width 4)
(setq undo-strong-limit 150000)                                ;; Enlarge bytes for undo's (from 20000)
(setq undo-limit 100000)
(global-hl-line-mode 1)                                        ;; Highlight line
(set-face-foreground 'hl-line nil)
(add-hook 'after-init-hook (lambda () (dark-theme)))           ;; Set default theme
(add-hook 'after-init-hook (lambda () (yas-global-mode 1)))    ;; setup yasnippet

;;------------------------------------------------------------------------------
;; Files
;;------------------------------------------------------------------------------
(defun my-make-auto-save-file-name ()
  " Puts all autosave files in one folder "
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

(defun my-auto-save-file-name-p (filename)
  " my-auto-save-file-name-p recognizes my-make-auto-save-file-name filename format"
  (string-match "^#.*#$" (file-name-nondirectory filename)))

;; -- Enviroment Variables - dertermine where custom file and backup/autosace files and up
(defvar my-customize-file "~/.emacs.d/custom.el")
(defvar autosave-dir (concat "~/.emacs.d/backups/"))
(defvar backup-dir (concat "~/.emacs.d/backups/"))


;; -- Initialization
(setq custom-file my-customize-file) ;; No more customize cruft at the end of .emacs
(load custom-file 'noerror)

(make-directory autosave-dir t) ;; Put autosave files (ie #foo#) in one place.
(setq auto-save-file-name-p 'my-auto-save-file-name-p)
(setq make-auto-save-file-name 'my-make-auto-save-file-name)

(setq backup-directory-alist (list (cons "." backup-dir))) ;; Put backup files (ie foo~) in one place too.

;;Don’t bother entering search and replace args if the buffer is read-only
(defadvice query-replace-read-args (before barf-if-buffer-read-only activate)
  "Signal a `buffer-read-only' error if the current buffer is read-only."
  (barf-if-buffer-read-only))

(add-hook 'after-save-hook '(lambda () "Automatic reloading of .emacs changes"
                              (and (equal (expand-file-name "~/.emacs") buffer-file-name)
                                   (load-file (expand-file-name "~/.emacs")))))

;;------------------------------------------------------------------------------
;; Modes and packages
;;------------------------------------------------------------------------------
(require 'windmove) ;; Move between windows with designated keys
(require 'ido) ;; Interactively do things with buffers and files.
(ido-mode t)
(require 'redo+) ;;redo - Handy little redo function
(require 'recentf) ;;recent visited buffers
(recentf-mode 1)
(setq recentf-max-saved-items 500)
(setq recentf-max-menu-items 60)
(require 'revive) ;; resume emacs session
(require 'linum) ;; display line numbers
(require 'compile) ;; integrating source code compilation result
(require 'uniquify) ;; uniqify buffer name
(setq uniquify-buffer-name-style 'forward)
(require 'psvn) ;; svn integration

;; -- My general packages
(require 'yic) ;; functions for cycling through buffers
(require 'isearch++) ;; extra functionality tor isearch
(require 'buffer-jumper) ;; makes it easy to jump to a specifc named buffer and back
(require 'nav) ;; Handy navigation functions
(require 'editor-functions) ;; Handy editor functions
(require 'display-functions) ;; Handy display functions
(require 'print-functions) ;; Handy print functions
(require 'describe-keybindings) ;; keybinding documentation functions

;; -- Keybindings
(require 'default-keybindings)
(default-keybindings)

;;------------------------------------------------------------------------------
;; Language Packages
;;------------------------------------------------------------------------------

;; -- Groovy
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

;; -- Latex
(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)
(add-hook 'LaTeX-mode-hook 'visual-line-mode)
;;(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)
(add-hook 'Latex-mode-hook 'turn-on-auto-fill)
(add-hook 'tex-mode-hook 'turn-on-auto-fill)

;; -- Perl
(add-to-list 'auto-mode-alist '("\\.\\([pP][Llm]\\|al\\)\\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))

;; -- Python
(setq py-install-directory "/home/shm/.emacs.d/python-mode.el-6.1.1")
(add-to-list 'load-path py-install-directory)
(require 'python-mode)

(defvar pybuilder-home "/home/shm/.emacs.d/my-code/pybuilder-0.1/")
(add-hook 'after-init-hook (lambda () (require 'pybuilder-mode)
                             (pybuilder-mode 0)))
(add-hook 'python-mode-hook 'pybuilder-mode)
(add-hook 'python-mode-hook 'pyfly-toggle)
(add-hook 'python-mode-hook 'jedi:setup)

;; -- Twiki Markup
(require 'erin) ;; works with itsalltext (firefox-plugin)
(setq auto-mode-alist (cons '(".mozilla/firefox/.*/itsalltext/wiki.dbc.dk.*\\.txt$" . erin-mode) auto-mode-alist))

;; -- Rst
(require 'rst+)
(add-hook 'rst-mode-hook 'rst+-keymap)

;; -- Octave
(autoload 'octave-mod "octave-mode" "Loading octave-mode" t)
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))


;; -- org-mode
(add-to-list 'load-path "~/.emacs.d/org-mode/contrib/lisp" t)

;; -- org2blog

(setq load-path (cons "~/.emacs.d/org2blog/" load-path))
(require 'org2blog-autoloads)

(setq org2blog/wp-blog-alist
      '(("wordpress"
         :url "http://uqbar.dk/clojure-junta/xmlrpc.php"
         :username "shm"

         :default-title "New Entry"
         :default-categories (nil
         :tags-as-categories nil)
        ("clojure-junta"

         :url "http://uqbar.dk/clojure-junta/xmlrpc.php"
         :username "admin"))))
