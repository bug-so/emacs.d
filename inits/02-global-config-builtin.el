;; 起動時にスタートページを表示しない
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))

;; スクロールバー消滅
(set-scroll-bar-mode nil)
;; 文字コード設定
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

;; コンパイル自動スクロール
(setq compilation-scroll-output t)
;; 外部からの編集を自動読み込み
(global-auto-revert-mode t)

;; (show-paren-mode 1)
;; (setq show-paren-delay 0)
;; (setq show-paren-style 'parenthesis)



;; :underline "#ffff00" :weight 'extra-bold)
(setq cursor-type 'box)
(setq cursor-in-non-selected-windows t)
;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)

;; Diredモードでのファイルサイズをわかりやすく
(setq find-ls-option '("-print0 | xargs -0 ls -alhd" . ""))
(setq dired-listing-switches "-alh")

;;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)

;; 選択範囲を上書き
(delete-selection-mode t)

;; hide menu bar
(menu-bar-mode -1)
;; ツールバーを非表示
(tool-bar-mode -1)

;; 自動インデント
(electric-indent-mode t)

;; diredを2つのウィンドウで開いている時に、デフォルトの移動orコピー先をもう一方のdiredで開いているディレクトリにする
(setq dired-dwim-target t)
;; ディレクトリを再帰的にコピーする
(setq dired-recursive-copies 'always)
;; diredバッファでC-sした時にファイル名だけにマッチするように
(setq dired-isearch-filenames t)

;; コントロール用のバッファを同一フレーム内に表示
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; diffのバッファを上下ではなく左右に並べる
(setq ediff-split-window-function 'split-window-horizontally)
;; (add-hook 'ediff-before-setup-hook 'make-frame)
;; (add-hook 'ediff-quit-hook 'delete-frame)


;; rktをscheme-modeとして開く
(add-to-list 'auto-mode-alist '("\\.rkt$" . scheme-mode))

;; C-x C-f を便利に
(ffap-bindings)

(use-package cl
  :config
  ;; 問い合わせを簡略化 yes/no を y/n
  (fset 'yes-or-no-p 'y-or-n-p)
  )

;; 同じファイルをディレクトリ名で区別
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets)
  )

;; 最近開いたファイルを記録
(use-package recentf
  :config
  (recentf-mode 1)
  (setq recentf-max-saved-items 10000)
  )

;; TAGSファイルの自動生成
(defadvice find-tag (before c-tag-file activate)
  "Automatically create tags file."
  (let ((tag-file (concat default-directory "TAGS")))
    (unless (file-exists-p tag-file)
      ;; (shell-command "ctags-exuberant -Re *.[ch] *.el .*.el -o TAGS 2>/dev/null"))
      (shell-command "ctags-exuberant -Re >/dev/null"))
    (visit-tags-table tag-file)))

;; カーソル位置を保存
(use-package saveplace
  :config
  (setq-default save-place t)
  (setq save-place-file "~/.emacs.d/.emacs-places")
  )

(ido-mode 1)
;; todo
;; (eval-after-load "ido-mode"
;;   '(progn
;;      (use-package ido-preview)
;;      (define-key ido-completion-map (kbd "C-M-p") (lookup-key ido-completion-map (kbd "C-p")))
;;      (define-key ido-completion-map (kbd "C-M-n") (lookup-key ido-completion-map (kbd "C-n"))) ; currently, this makes nothing. Maybe they'll make C-n key lately.
;;      (define-key ido-completion-map (kbd "C-p") 'ido-preview-backward)
;;      (define-key ido-completion-map (kbd "C-n") 'ido-preview-forward)
;;      ))

;; (setq frame-title-format (format "%s" (buffer-file-name)))
(setq frame-title-format
      '("emacs" emacs-version "  %S" (buffer-file-name "%f" (dired-directory dired-directory "%b"))))

(define-key dired-mode-map "o" 'dired-open-file)
;; (eval-after-load "dired-mode"
;;   '(progn
;;      ))
;;;###autoload
(defun dired-open-file ()
  "In dired, open the file named on this line."
  (interactive)
  (open-default-file (dired-get-filename)))

;;;###autoload
(defun open-default-file (file)
  (interactive)
  (message "Opening %s..." file)
  (call-process "gvfs-open" nil 0 nil (expand-file-name file))
  (message "Opening %s done" file))


;; vcを起動しないようにする
(custom-set-variables
 '(vc-handled-backends nil))
;; 不要なhookを外す
(remove-hook 'find-file-hook 'vc-find-file-hook)
(remove-hook 'kill-buffer-hook 'vc-kill-buffer-hook)


;;; 選択範囲をisearch
(defadvice isearch-mode (around isearch-mode-default-string (forward &optional regexp op-fun recursive-edit word-p) activate)
  (if (and transient-mark-mode mark-active (not (eq (mark) (point))))
      (progn
        (isearch-update-ring (buffer-substring-no-properties (mark) (point)))
        (deactivate-mark)
        ad-do-it
        (if (not forward)
            (isearch-repeat-backward)
          (goto-char (mark))
          (isearch-repeat-forward)))
    ad-do-it))
;; タブ１つ分の表示サイズを4にする
(setq-default tab-width 4)
(setq-default tab-always-indent nil)
(setq-default indent-tabs-mode nil)

;; フォント
(custom-set-faces
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 120 :width normal)))))
