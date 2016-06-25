;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config for auto-complete begin ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get 'sync 'auto-complete)
(use-package auto-complete
  :config
  (use-package auto-complete-config)
  (setq ac-auto-start 2)  ;; n文字以上の単語の時に補完を開始
  (setq ac-delay 0.005)  ;; n秒後に補完開始
  (setq ac-use-fuzzy t)  ;; 曖昧マッチ有効
  (setq ac-use-comphist t)  ;; 補完推測機能有効
  (setq ac-auto-show-menu 0.005)  ;; n秒後に補完メニューを表示
  (setq ac-quick-help-delay 0.5)  ;; n秒後にクイックヘルプを表示
  (setq ac-ignore-case t)  ;; 大文字・小文字を区別する
  (setq ac-use-menu-map t) ;; C-n/C-pで候補選択可能
  (setq ac-dwim t)

  ;; デフォルトでauto-complete-modeにならないモードを手動で追加
  (defvar add-ac-list '(text-mode nxml-mode latex-mode sh-mode html-mode snippet-mode enh-ruby-mode prolog-mode))
  (setq ac-modes (append ac-modes add-ac-list))

  (defvar my-ac-dict "~/.emacs.d/auto-complete/ac-dict/")
  (add-to-list 'ac-dictionary-directories my-ac-dict)
  (ac-config-default)
  (global-auto-complete-mode t)
  (bind-keys :map ac-mode-map
             ("C-SPC" . auto-complete)
             ("C-o" . nil)
             )

  (add-hook 'auto-complete-mode-hook
            (lambda ()
              (add-to-list 'ac-sources 'ac-source-yasnippet)
              (add-to-list 'ac-sources 'ac-source-filename)))

  ;; auto-complete の候補に日本語を含む単語が含まれないようにする
  ;; http://d.hatena.ne.jp/IMAKADO/20090813/1250130343
  (defadvice ac-word-candidates (after remove-word-contain-japanese activate)
    (let ((contain-japanese (lambda (s) (string-match (rx (category japanese)) s))))
      (setq ad-return-value
            (remove-if contain-japanese ad-return-value))))
  )


;; 自分で定義した単語を辞書に登録する関数
;;;###autoload
(defun my-ac-add-dictionary (begin end)
  (interactive "r")
  (let* ((extension (file-name-extension buffer-file-name))
         (dictionary-file (concat my-ac-dict extension)))
    (message "%s" dictionary-file)
    (message "%s" (file-regular-p dictionary-file))
    (append-to-file begin end dictionary-file)
    (append-to-file "\n" nil dictionary-file)
    (ac-clear-dictionary-cache)
    )
  )

(el-get 'sync 'yasnippet)
(use-package yasnippet
  :config
  (setq yas-snippet-dirs
        '("~/.emacs.d/snippets" ;; 作成するスニペットはここに入る
          "~/.emacs.d/el-get/yasnippet/snippets" ;; 最初から入っていたスニペット(省略可能)
          ))
  (custom-set-variables
   ;; 単語展開キーバインド (ver8.0から明記しないと機能しない)
   ;; (setqだとtermなどで干渉問題ありでした)
   '(yas-trigger-key "TAB")
   ;; スニペットを挿入するときにインデントを揃える
   '(yas-indent-line 'fixed)
   )
  (yas-global-mode 1)
  (bind-keys :map yas-minor-mode-map
             ;; 既存スニペットを挿入する
             ;; ("C-c C-SPC" . yas-insert-snippet)
             ;; 新規スニペットを作成するバッファを用意する
             ("C-x i n" . my-yas-new-snippet)
             ;; 既存スニペットを閲覧・編集する
             ("C-x i v" . my-yas-visit-snippet-file)
             )

  (custom-set-variables '(yas-prompt-functions '(my-yas/prompt)))
  ;; スニペットの編集をpopwinで表示するための関数
  (defun my-switch-buffer-with-popwin (func)
    (save-window-excursion
      (funcall func))
    (popwin:display-buffer (nth 1 (buffer-list))))
  (defun my-yas-new-snippet ()
    (interactive)
    (my-switch-buffer-with-popwin (lambda () (yas-new-snippet t))))
  (defun my-yas-visit-snippet-file ()
    (interactive)
    (my-switch-buffer-with-popwin (lambda () (yas-visit-snippet-file))))
  )



;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config for helm start ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get 'sync 'helm)
(use-package helm
  :commands (helm helm-mini helm-M-x)
  :config
  (use-package helm-config)
  (el-get 'sync 'helm-descbinds)
  (use-package helm-descbinds
    :config
    (setq helm-descbinds-mode t)
    )
  ;; helm-findでパスを入力したいので変更
  (bind-keys :map global-map
             ([remap helm-find] . (lambda () (interactive) (helm-find t)))
             ("M-y" . helm-show-kill-ring)
             ;; initsディレクトリを開く
             ("C-q C-i" . (lambda ()
                            (interactive)
                            (helm-find-files-1 (expand-file-name "~/.emacs.d/inits/"))))
             )
  (bind-keys :map helm-map
             ("C-l" . helm-follow-mode)
             )
  (bind-keys :map isearch-mode-map
             ;; 検索wordをhelm-occurで一覧化してくれる設定。isearchの時にC-oを押すと一覧が出る。
             ("C-o" . helm-occur-from-isearch)
             )
  (bind-keys :map ac-completing-map
             ;; 検索wordをhelm-occurで一覧化してくれる設定。isearchの時にC-oを押すと一覧が出る。
             ("C-h" . ac-complete-with-helm)
             )
  (el-get 'sync 'helm-c-yasnippet)
  (use-package helm-c-yasnippet
    :config
    (setq helm-yas-space-match-any-greedy t) ;[default: nil]
    (bind-key (kbd "C-c C-SPC") 'helm-yas-complete yas-minor-mode-map)
    (yas-global-mode 1)
    ;; (yas-load-directory "<path>/<to>/snippets/")
    )
  )
(el-get 'sync 'ac-helm)
(use-package ac-helm
  :commands (ac-complete-with-helm)
  )

;;;###autoload
(defun my-yas/prompt (prompt choices &optional display-fn)
  (let* ((names (loop for choice in choices
                      collect (or (and display-fn (funcall display-fn choice))
                                  choice)))
         (selected (helm-other-buffer
                    `(((name . ,(format "%s" prompt))
                       (candidates . names)
                       (action . (("Insert snippet" . (lambda (arg) arg))))))
                    "*helm yas/prompt*")))
    (if selected
        (let ((n (position selected names :test 'equal)))
          (nth n choices))
      (signal 'quit "user quit!"))))

(el-get 'sync 'helm-swoop)
(use-package helm-swoop
  :commands (helm-swoop)
  )
(use-package helm-migemo
  :commands (helm-migemo helm-migemize-command)
  )

;;;;;;;;;;;;;;;;;;;;;;;;;
;; config for helm end ;;
;;;;;;;;;;;;;;;;;;;;;;;;;




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; config for auto-complete end ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(use-package ispell
  :defer t
  :config
  (add-to-list 'ispell-skip-region-alist '("[^\000-\3777]+"))
  (global-set-key (kbd "C-M-$") 'ispell-complete-word)
  (if (executable-find "aspell")
      (setq-default ispell-program-name "aspell"))
  )
