(el-get 'sync 'popwin)
(use-package popwin
  :config
  (setq special-display-function 'popwin:special-display-popup-window)
  (popwin-mode 1)
  (push '("*Completions*" :height 0.4) popwin:special-display-config)
  (push '("*compilation*" :height 0.3 :noselect t :stick t) popwin:special-display-config)
  (push '("*Shell Command Output*" :height 0.3 :noselect t) popwin:special-display-config)
  (push '("*YASnippet tables*" :height 0.4 :stick t) popwin:special-display-config)
  (push '("*RE-Builder*" :height 0.4 :stick t) popwin:special-display-config)
  (push '("*translated*" :height 0.4 :stick t) popwin:special-display-config)
  ;; (push '("*Moccur*" :height 0.4 :stick t) popwin:special-display-config)
  (push '("[*]git-gutter.*" :regexp t :height 0.4 :stick t) popwin:special-display-config)
  (push '("[*]Man.*" :regexp t :height 0.4 :stick t) popwin:special-display-config)
  (push '("[*]ag.*" :regexp t :height 0.4 :stick t :dedicated t) popwin:special-display-config)
  (push '(snippet-mode :height 0.4 :stick t) popwin:special-display-config)
  (push '("*new snippet*" :height 0.4 :stick t) popwin:special-display-config)
  (push '("*esup*" :height 0.4 :stick t) popwin:special-display-config)
  (push '(snippet-mode :height 0.4 :stick t) popwin:special-display-config)
  (push '(dired-mode :position top :height 0.6) popwin:special-display-config)
  ;; (push '(direx:direx-mode :position top) popwin:special-display-config)
  (push '(direx:direx-mode :position left :width 25) popwin:special-display-config)
  )

;; 複数の矩形を選択
(el-get 'sync 'multiple-cursors)
(use-package multiple-cursors
  ;; :commands (mc/mark-next-like-this mc/mark-previous-like-this mc/mark-all-dwim)
  :config
  (el-get 'sync 'phi-search)
  (use-package phi-search
    :config
    (bind-keys :map mc/keymap
               ("C-s" . phi-search)
               ("C-r" . phi-search)
               )
    )
  )

;; トークンごとの選択
(el-get 'sync 'expand-region)
(use-package expand-region
  :commands (er/expand-region)
  :bind (("C-:" . er/expand-region)
         ("C-M-:" . er/contract-region))
  :config
  (custom-set-variables
   '(expand-region-reset-fast-key "")
   '(expand-region-contract-fast-key "")
   )
  )

;; (use-package tabbar-config)
;; 今はtabbar-configを使ってる
(use-package tab-group-config)

(defun my-color-setting ()
  (interactive)
  (color-theme-charcoal-black)
  ;; (when (use-package color-theme-tango)
  ;;   (color-theme-tango))
  ;; コメントの色だけ変更
  (set-face-foreground 'font-lock-comment-face "SeaGreen3")
  (set-face-foreground 'font-lock-comment-delimiter-face "SeaGreen3")
  )
;; 配色設定
(use-package color-theme
  :config
  (color-theme-initialize)
  (my-color-setting)
  )

;; rubyの正規表現を使う
;; (use-package foreign-regexp)
;; (custom-set-variables
;;  '(foreign-regexp/regexp-type 'ruby)
;;  ;; '(reb-re-syntax 'foreign-regexp)
;;  )

;; ファイル名の文字化けを修正
(use-package ucs-normalize
  :config
  (set-file-name-coding-system 'utf-8-hfs)
  )

(el-get 'sync 'smartparens)
(use-package smartparens
  :config
  ;; カッコやダブルクォートの自動補完
  (setq electric-pair-mode nil)
  (smartparens-global-mode t)
  (use-package smartparens-config)
  (set-face-attribute 'show-paren-match-face nil
                      :background nil :foreground nil
                      ;; :box nil;; (:line-width 1 :color "#ffff00")
                      :underline "#ffff00" :weight 'extra-bold)
  )

(use-package fuzzy-format
  :commands (fuzzy-format-indent)
  :config
  (global-fuzzy-format-mode t)
  )

;; (use-package dired+

;;   )

(use-package dired-x
  :bind (("C-x C-j" . dired-jump-other-window)
         ("C-x j" . dired-jump)
         )
  :commands (dired-jump-other-window)
  :config
  ;; (bind-keys :map global-map
  ;;            ("C-x C-j" . dired-jump-other-window)
  ;;            )
  )

;; ;; 置換
;; (use-package color-moccur
;;   :config
;;   (setq moccur-split-word t)
;;   )
;; ;; grepの結果を編集
;; (use-package moccur-edit)

;; (use-package highlight-symbol
;;   (setq highlight-symbol-colors '("DarkOrange" "DodgerBlue1" "DeepPink1"))
;;   (setq highlight-symbol-timer 1)
;;   )


(use-package auto-highlight-symbol
  :commands (auto-highlight-symbol-mode)
  :config
  ;; (global-auto-highlight-symbol-mode t)
  )


;; ;; プロジェクトツリーのようなもの
;; (use-package sr-speedbar nil t)
;; (setq sr-speedbar-width-x 40)
;; (setq sr-speedbar-width-console 24)
;; (setq sr-speedbar-delete-windows nil)
;; (define-key global-map (kbd "C-^") 'sr-speedbar-toggle)
;; (define-key speedbar-mode-map (kbd "TAB") 'speedbar-toggle-line-expansion)
;; ;; デフォルトでは前回の動作が残るので，カレントディレクトリに合わせて自動的にキャッシュをクリア
;; (setq sr-speedbar-auto-refresh t)
;; (setq speedbar-use-images nil)
;; (setq speedbar-frame-parameters '((minibuffer)
;;                                   (width . 30)
;;                                   (border-width . 0)
;;                                   (menu-bar-lines . 0)
;;                                   (tool-bar-lines . 0)
;;                                   (unsplittable . t)
;;                                   (left-fringe . 0)))
;; (setq speedbar-default-position 'left-right)
;; (setq speedbar-hide-button-brackets-flag t)
;; (setq sr-speedbar-right-side nil)
;; (setq speedbar-show-unknown-files t)

;; gistクライアント
;; (use-package yagist)
;; (setq yagist-github-token '310e788cbe7e4fcc12380d37ae2cb21d04930b67)

;; undo yankなどをハイライト
(el-get 'sync 'volatile-highlights)
(use-package volatile-highlights
  :config
  (volatile-highlights-mode t)
  )


(use-package migemo
  :if (executable-find "cmigemo")
  ;; :commands (isearch-forward migemo-isearch-toggle-migemo helm-migemize-command)
  :config
  (setq migemo-options '("-q" "--emacs"))
  (setq migemo-user-dictionary nil)
  (setq migemo-regex-dictionary nil)
  (setq migemo-coding-system 'utf-8-unix)
  (setq migemo-command "cmigemo")
  (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")
  (setq migemo-isearch-min-length 1)
  (migemo-init)
  (migemo-isearch-toggle-migemo)        ; 必要なときにあれば良いから最初はオフ
  ;; (add-hook 'minibuffer-setup-hook 'ibus-disable)
  ;; (add-hook 'isearch-mode-hook 'ibus-disable)
  (add-hook 'minibuffer-setup-hook 'my-active)
  (add-hook 'isearch-mode-hook 'my-deactive)

  (setq migemo-isearch-min-length 2)
  ;; (defun toggle-migemo-isearch-length ()
  ;;   (interactive)
  ;;   (if (> 1 migemo-isearch-min-length)
  ;;       (setq migemo-isearch-min-length 1)
  ;;     (setq migemo-isearch-min-length 2))
  ;;   )
  )


;; gitクライアント
(el-get 'sync 'magit)
(use-package magit
  :commands (magit-status)
  :config
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))

  (defun my/magit-quit-session ()
    (interactive)
    (kill-buffer)
    (jump-to-register :magit-fullscreen))

  (bind-keys :map magit-status-mode-map
             ("q" . my/magit-quit-session)
             )

  (defadvice git-commit-commit (after move-to-magit-buffer activate)
    (delete-window))
  )

(eval-after-load "git-commit-mode"
  '(progn
     (add-hook 'git-commit-mode-hook 'flyspell-mode)
     (bind-keys :map git-commit-mode-map
                ("<up>" . git-commit-prev-message)
                ("<down>" . git-commit-next-message)
                )
     ))

(el-get 'sync 'git-gutter+)
(use-package git-gutter+
  :commands (toggle-git-gutter+)
  :config
  (el-get 'sync 'git-gutter-fringe+))
(use-package git-gutter-fringe+)

(defun toggle-git-gutter+ ()
  "toggle git-gutter+-mode"
  (interactive)
  (when (and (use-package magit nil t) (use-package git-gutter+))
    (if (magit-get-top-dir)
        (if git-gutter+-mode
            (git-gutter+-mode -1)
          (git-gutter+-mode 1)))))

;; 最後の編集地点へ戻る
(el-get 'sync 'goto-last-change)
(use-package goto-last-change
  :commands (goto-last-change)
  )

;;(use-package adaptive-wrap)

;; isearchの強化
(el-get 'sync 'anzu)
(use-package anzu
  :config
  (global-anzu-mode t)
  (custom-set-variables
   '(anzu-mode-lighter "")
   '(anzu-deactivate-region t)
   '(anzu-search-threshold 1000)
   '(anzu-use-migemo t)
   '(anzu-replace-to-string-separator " => ")
   )
  (bind-keys :map global-map
             ([remap query-replace] . anzu-query-replace)
             ([remap query-replace-regexp] . anzu-query-replace-regexp)
             )
  )

(el-get 'sync 'iedit)
(use-package iedit
  :commands (iedit-mode)
  :config
  (bind-keys :map global-map
             ("C-;" . helm-imenu)
             ("C-M-;" . comment-dwim)
             )
  )

;; 起動速度計測
(use-package esup
  :commands (esup)
  )

;; プロジェクト管理
(use-package projectile
  :commands (helm-projectile)
  :bind (("C-t C-p" . helm-projectile)
         )
  :config
  (projectile-global-mode)
  (add-to-list 'projectile-project-root-files-bottom-up "init.el")
  )
;; (use-package projectile)
;; (add-to-list 'projectile-project-root-files-bottom-up "init.el")

;; google翻訳に突っ込む。英語→日本語以外はほとんど使わないので、固定
(use-package google-translate
  :commands (google-translate-at-point)
  :config
  (custom-set-variables
   ttert   '(google-translate-default-source-language "en")
   '(google-translate-default-target-language "ja")
   )
  )

;; なぜか使えないので(el-get 'sync )バインドだけ設定。
(el-get 'sync 'undo-tree)
(use-package undo-tree
  :commands (undo-tree-visualize)
  :bind (("C-x u" . undo-tree-visualize)
         ;; ("C-?" . undo-tree-redo)
         )
  :config
  (bind-keys :map undo-tree-visualizer-mode-map
             ("RET" . undo-tree-visualizer-quit) ; quit by enter
             )
  )

(use-package smart-compile
  :commands (smart-compile)
  ;; :bind (("C-q C-c" . smart-compile)
  ;;        )
  :config
  ;; (setq compilation-window-height 15)
  )

;; (use-package direx
;;   :commands (direx:jump-to-directory-other-window direx:find-directory)
;;   :bind (("C-x C-j" . direx:jump-to-directory-other-window)
;;          ("C-x j" . direx:find-directory)
;;          )
;;   :config
;;   (setq direx:leaf-icon "  "
;;         direx:open-icon "▾ "
;;         direx:closed-icon "▸ ")
;;   )

(use-package google-this
  ;; (defun google-this-url () "URL for google searches."
  ;;   (concat google-this-base-url google-this-location-suffix
  ;;           "/search?q=%s&hl=ja&num=10&as_qdr=y5&lr=lang_ja"))
  :commands (google-this)
  :bind (("C-c g" . google-this))
  :config
  (setq google-this-location-suffix "co.jp")
  )
