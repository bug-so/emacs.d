;; unset unused key
(global-unset-key "\C-t")
(global-unset-key "\C-q")

(bind-keys :map global-map
           ;; 誤爆するのでC-xC-cを殺しとく
           ("C-x C-c" . (lambda () (interactive) (message "m9(^Д^)ﾌﾟｷﾞｬｰ")))
           ("C-x C-M-c" . save-buffers-kill-emacs)
           ;; 確認なしで全てのバッファーを保存
           ("C-x s" . save-all-buffer-without-confirm)
           ;; コメントアウト
           ("C-M-;" . comment-dwim)
           ;; helm-imenu
           ("C-;" . helm-imenu)
           ;; コンパイル
           ([C-M-S-return] . compile)
           ;; リコンパイル
           ([C-M-return] . recompile)

           ("C-z" . helm-resume)
           ("C-x C-^" . shell-command)
           ;; 次のウィンドウへ移動
           ("M-n" . tabbar-forward)
           ;; 前のウィンドウへ移動
           ("M-p" . tabbar-backward)
           ("C-x C-b" . helm-mini)
           ("C-q b" . helm-filtered-bookmarks)

           ;; フレームウインドウ周り
           ("C-1" . delete-other-windows)
           ("C-4" . make-frame)
           ("C-5" . delete-frame)


           ;; reindent
           ("C-x C-SPC" . my-reindent)
           ;; ウインドウの分割，移動
           ([C-tab] . other-window-or-split)
           ;; 行頭とインデントに移動した位置へ交互に移動する
           ([remap move-beginning-of-line] . my-backward-indent)

           ("C-."  . find-tag)
           ("M-."  . pop-tag-mark)

           ;; (define-key global-map (kbd "C-x g") 'moccur-grep-find)
           ("C-x g"  . ag)

           ;; C-hでBackSpace
           ;; (keyboard-translate ?\C-h ?\C-?)

           ;; テキスト翻訳
           ("C-x C-t"  . google-translate-at-point)
           ("M-x"  . helm-M-x)

           ;; helm-desbinding
           ("C-h C-b"  . helm-descbinds)

           ;; insertキーでoverwriteになるのは鬱陶しいので消す
           ([insert] nil)

           ;; C-x C-fがあれば十分なので消す
           ("C-x C-d"  . il)

           ("C-q C-q"  . quoted-insert)
           ("C-q C-w"  . delete-other-windows)
           ("C-q w"  . delete-window)
           ;; ("C-q C-k"  . kill-buffer-and-window)
           ("C-q C-f"  . helm-find-files)
           ("C-q f"  . delete-frame)
           ("C-q C-l"  . goto-last-change)
           ("C-q C-x C-f"  . ido-find-file)
           ("C-q C-g"  . helm-ls-git-ls)
           ("C-q C-m"  . magit-status)
           ;; ("C-q C-p"  . helm-projectile)
           ("C-q C-;"  . iedit-mode)
           ("C-x C-a"  . align-regexp)
           ("C-q C-k"  . kill-current-buffer)
           ("C-q C-k"  . kill-and-back-to-last-buffer)
           ("C-q C-t"  . popup-recently-closed-buffer)
           ("C-q C-b"  . back-to-last-buffer)

           ;; helm-occur
           ("C-q C-o"  . helm-swoop)
           ;; ("C-q C-o"  . helm-occur)
           ;; ("C-x M-o"  . occur-by-moccur)

           ;; ペアとなる括弧やクォートも削除
           ("C-q C-d"  . delete-pair)
           )

;; 連続操作のキーバインド操作
(el-get 'sync 'smartrep)
(use-package smartrep
  :config
  )
(smartrep-define-key global-map "<C-henkan>"
  '(("f" . forward-word)
    ("b" . backward-word)
    ))

(smartrep-define-key global-map "<C-muhenkan>"
  '(("p" . sfp-page-up)
    ("n" . sfp-page-down)
    ("k" . previous-line)
    ("j" . next-line)
    ("h" . tab-group:prev)
    ("l" . tab-group:next)
    ("K" . kill-current-buffer)
    ))

(eval-after-load "reb-mode"
  '(progn
     (smartrep-define-key reb-mode-map "C-c"
       '(("C-s" . reb-next-match)
         ("C-r" . reb-prev-match)
         ))
     ))
(smartrep-define-key global-map "C-q m"
  '(("m" . git-gutter+-mode)
    ("n" . git-gutter+-next-hunk)
    ("p" . git-gutter+-previous-hunk)
    ("d" . git-gutter+-show-hunk)
    ))
(smartrep-define-key global-map "C-q"
  '(("l" . goto-last-change)
    ))
;; TODO previous not work.
(smartrep-define-key global-map "C-q"
  '(("C-n" . 'my-mc/mark-next-and-cycle-forward)
    ("n" . 'my-mc/skip-to-next-like-this)
    ("C-p" . 'my-mc/mark-previous-and-cycle-backward)
    ("p" . 'my-mc/skip-to-previous-like-this)
    ("C-v" . 'mc/cycle-forward)
    ("M-v" . 'mc/cycle-forward)
    ))
(bind-key  (kbd "C-q C-a") 'mc/mark-all-dwim global-map)

;; TODO 最初に戻る方法を考える
(defun my-mc/mark-next-and-cycle-forward (arg)
  (interactive "p")
  (progn
    (mc/mark-next-like-this arg)
    (my-mc/cycle-forward-if-not-visible)))
(defun my-mc/skip-to-next-like-this ()
  (interactive)
  (progn
    (mc/skip-to-next-like-this)
    (my-mc/cycle-forward-if-not-visible)))
(defun my-mc/cycle-forward-if-not-visible ()
  (if (my-mc/cursor-is-not-visible)
      (mc/cycle-forward)))

(defun my-mc/cursor-is-not-visible ()
  (let ((cursor (mc/furthest-cursor-after-point)))
    (if (not (pos-visible-in-window-p (overlay-start cursor)))
        t
      nil)
    )
  )
(defun my-mc/cursor-is-not-visible-backward ()
  (let ((cursor (mc/furthest-cursor-before-point)))
    (if (not (pos-visible-in-window-p (overlay-start cursor)))
        t
      nil)
    )
  )
(defun my-mc/mark-previous-and-cycle-backward (arg)
  (interactive "p")
  (progn
    (mc/mark-previous-like-this arg)
    (my-mc/cycle-backward-if-not-visible)
    )
  )
(defun my-mc/skip-to-previous-like-this ()
  (interactive)
  (progn
    (mc/skip-to-previous-like-this)
    (my-mc/cycle-backward-if-not-visible)
    )
  )
(defun my-mc/cycle-backward-if-not-visible ()
  (if (my-mc/cursor-is-not-visible-backward)
      (mc/cycle-backward)))

(smartrep-define-key global-map "C-x"
  '(("C-M-k" . 'kill-current-buffer)
    ))
(smartrep-define-key global-map "C-t"
  '((">" . 'tab-group:move-tab-right)
    ("<" . 'tab-group:move-tab-left)
    ))
(smartrep-define-key global-map "C-x"
  '(("{" . 'shrink-window-horizontally)
    ("}" . 'enlarge-window-horizontally)
    ("-" . 'shrink-window)
    ("^" . 'enlarge-window)))
