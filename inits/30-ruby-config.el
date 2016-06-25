;; (use-package enh-ruby-mode
;;   :interpreter (("ruby"    . enh-ruby-mode)
;;                 ("rbx"     . enh-ruby-mode)
;;                 ("jruby"   . enh-ruby-mode)
;;                 ("ruby1.9" . enh-ruby-mode)
;;                 ("ruby1.8" . enh-ruby-mode))
;;   :config
;;   ;; enh-ruby-modeの設定
;;   )

;; rubyの環境設定ruby
;; enh-ruby-mode

(autoload 'rspec-mode "rspec-mode"
  "Mode for editing rspec source files" t)

(autoload 'rhtml-mode "rhtml-mode"
  "mode for erb" t)
(add-to-list 'auto-mode-alist '("\\.erb$" . rhtml-mode))

(autoload 'rinari-launch "rinari"
  "Mode for ediging rails project" t)

(use-package projectile-rails
  :commands (projectile-rails-on)
  :init
  (add-hook 'projectile-mode-hook 'projectile-rails-on)
  ;; (add-hook 'projectile-mode-hook (lambda () (guide-key/add-local-guide-key-sequence "C-c r")))
  )

(el-get 'sync 'enh-ruby-mode)
(use-package enh-ruby-mode
  :mode (("\\.rb$" . enh-ruby-mode)
         ("Capfile#" . enh-ruby-mode)
         ("Gemfile$" . enh-ruby-mode)
         )
  ;; :disabled
  :config
  ;; (robe-mode-setup)
  (rcodetools-init)
  (add-hook 'enh-ruby-mode-hook
            (lambda ()
              (setq local-reindent-ignore-function 'in-regexp)
              (setq local-reindent-function 'my-ruby-formatter)
              ))

  (setq ruby-electric-expand-delimiters-list nil)
  ;; ruby-block
  (use-package ruby-block
    :config
    (ruby-block-mode t)
    (setq ruby-block-highlight-toggle t)
    )
  ;; (use-package ruby-refactor
  ;;   :config
  ;;   (add-hook 'enh-ruby-mode-hook 'ruby-refactor-mode-launch))
  )

(defun my-ruby-formatter ()
  ;; TODO 正規表現などの情報を省けない
  (replace-regexp-except-string-comment ",\\([^ ]\\)" ", \\1" (point-min) (point-max) 'in-regexp)
  (replace-regexp-except-string-comment "\\(,\\)\\( \\{2,\\}\\([^ ]\\)\\)" ", \\3" (point-min) (point-max) 'in-regexp))

(use-package inf-ruby
  :commands (inf-ruby)
  :config
  (setq inf-ruby-buffer "*pry*")
  (add-to-list 'inf-ruby-implementations '("pry" . "pry"))
  (setq inf-ruby-default-implementation "pry")
  (setq inf-ruby-eval-binding "Pry.toplevel_binding")
  (add-hook 'inf-enh-ruby-mode-hook 'ansi-color-for-comint-mode-on)
  (use-package pry
    :config
    )
  )

(defun robe-mode-setup ()
  (interactive)
  (save-window-excursion (inf-ruby "pry"))    ;実行後にフォーカスが言ってしまうのでwindowを記録
  (robe-start)
  (robe-mode)
  )

(defun rcodetools-init ()
  ;; rcodetools
  (use-package rcodetools
    :config
    (setq rct-find-tag-if-available nil)
    (bind-keys :map enh-ruby-mode-map
               ;; ("C-M-SPC"  . rct-complete-symbol)
               ;; ("\C-c\C-t" . ruby-toggle-buffer)
               ("C-c C-d" . xmp)
               ;; ("\C-c\C-f" . rct-ri)
               )

    ;; enf-rubyだとコメントアウトの矢印が出せないので上書き
    (defadvice comment-dwim (around rct-hack activate)
      "If comment-dwim is successively called, add => mark."
      (if (and (or (eq major-mode 'enh-ruby-mode) (eq major-mode 'enh-ruby-mode))
               (eq last-command 'comment-dwim)
               ;; TODO =>check
               )
          (insert "=>")
        ad-do-it))

    )
  )

(use-package robe
  :commands (robe-start)
  :config
  (bind-keys :map robe-mode-map
             ("C-c C-d" . nil)
             ("M-." . nil)
             )
  (bind-keys :map enh-ruby-mode-map
             ("C-c C-f" . robe-doc)
             )
  (add-hook 'robe-mode-hook 'ac-robe-setup)

  (use-package helm-robe
    :config
    (custom-set-variables
     '(robe-completing-read-func 'helm-robe-completing-read))
    )
  )

(defun in-regexp ()
  (let ((m (match-data))
        (flg (evenp (count-regexp-except-string-comment "/" (point-min) (point)))))
    (set-match-data m)
    flg
    )
  )



(use-package yari
  :commands (yari-helm)

  )
;; (eval-after-load "enh-ruby-mode"
(add-hook 'enh-ruby-mode-hook
          (lambda ()
            (add-to-list 'ac-sources 'ac-source-yasnippet)
            ;; (robe-mode-setup)

            (local-set-key [f1] 'yari-helm)
            ;; (rinari-launch)
            ;; (yard-mode)
            ;; (eldoc-mode)
            ))

;; ;; rsense-setup
;; (add-hook 'enh-ruby-mode-hook
;;           '(lambda ()
;;              (setq rsense-home (expand-file-name "~/.emacs.d/el-get/rsense-0.3"))
;;              (add-to-list 'load-path (concat rsense-home "/etc"))
;;              (use-package rsense)
;;              (add-to-list 'ac-sources 'ac-source-rsense-method)
;;              (add-to-list 'ac-sources 'ac-source-rsense-constant)
;;              ))

(defadvice ruby-indent-line (after unindent-closing-paren activate)
  (let ((column (current-column))
        indent offset)
    (save-excursion
      (back-to-indentation)
      (let ((state (syntax-ppss)))
        (setq offset (- column (current-column)))
        (when (and (eq (char-after) ?\))
                   (not (zerop (car state))))
          (goto-char (cadr state))
          (setq indent (current-indentation)))))
    (when indent
      (indent-line-to indent)
      (when (> offset 0) (forward-char offset)))))

(setq ruby-deep-indent-paren-style nil)



;; imenuの改造
;;;###autoload
(defun ruby-imenu-create-index-in-block (prefix beg end)
  (let ((index-alist '()) (case-fold-search nil)
        name next pos decl sing)
    (goto-char beg)
    (while (re-search-forward "^\\s *\\(\\(class\\s +\\|\\(class\\s *<<\\s *\\)\\|module\\s +\\)\\([^\(<\n ]+\\)\\|\\(def\\|alias\\|get\\|post\\|describe\\|context\\)\\s +\\([^\(\n]+\\)\\)" end t)
      (setq sing (match-beginning 3))
      (setq decl (match-string 5))
      (setq next (match-end 0))
      (setq name (or (match-string 4) (match-string 6)))
      (setq pos (match-beginning 0))
      (cond
       ((or (string= "get" decl) (string= "post" decl)
            (string= "context" decl) (string= "describe" decl))
        (setq name (concat decl " " (replace-regexp-in-string "['\"]" "" name)))
        (if prefix (setq name (concat prefix name)))
        (push (cons name pos) index-alist))
       ((string= "alias" decl)
        (if prefix (setq name (concat prefix name)))
        (push (cons name pos) index-alist))
       ((string= "def" decl)
        (if prefix
            (setq name
                  (cond
                   ((string-match "^self\." name)
                    (concat (substring prefix 0 -1) (substring name 4)))
                   (t (concat prefix name)))))
        (push (cons name pos) index-alist)
        (ruby-accurate-end-of-block end))
       (t
        (if (string= "self" name)
            (if prefix (setq name (substring prefix 0 -1)))
          (if prefix (setq name (concat (substring prefix 0 -1) "::" name)))
          (push (cons name pos) index-alist))
        (ruby-accurate-end-of-block end)
        (setq beg (point))
        (setq index-alist
              (nconc (ruby-imenu-create-index-in-block
                      (concat name (if sing "." "#"))
                      next beg) index-alist))
        (goto-char beg))))
    index-alist))
