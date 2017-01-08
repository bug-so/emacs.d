;;; -*- coding: utf-8; lexical-binding: t -*

(defmacro delay (f)
  `(lambda () f))

(defalias 'force 'funcall)

(setq deactivate-mark nil)
(defun insert-string-region-exec (begin end begin-str end-str)
  ;; 空のマーカーを作成し，eをマーカーにセットする
  (setq end (set-marker (make-marker) end))
  (goto-char begin)
  (insert begin-str)
  (goto-char end)
  (insert end-str))

(defun insert-string-region (begin end begin-str end-str)
  (if mark-active
      (insert-string-region-exec begin end begin-str end-str)
    (insert-string-region-exec (point) (point) end-str begin-str)))

;; ディスプレイサイズに合わせたウインドウの分割
(defun split-window-vertically-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-vertically)
    (progn
      (split-window-vertically
       (- (window-height) (/ (window-height) num_wins)))
      (split-window-vertically-n (- num_wins 1)))))
(defun split-window-horizontally-n (num_wins)
  (interactive "p")
  (if (= num_wins 2)
      (split-window-horizontally)
    (progn
      (split-window-horizontally
       (- (window-width) (/ (window-width) num_wins)))
      (split-window-horizontally-n (- num_wins 1)))))

(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (if (>= (window-body-width) 270)
        (split-window-horizontally-n 3)
      (split-window-horizontally)))
  (other-window 1))
(defun other-window-or-split ()
  (interactive)
  (when (one-window-p)
    (split-window-horizontally))
  (other-window 1))


(defun goto-index ()
  "jump to inputed index"
  (interactive)
  (let ((n (read-from-minibuffer "input index :")))
    ;; (my-register-set)
    (goto-char (string-to-int n))
    )
  )
(define-key global-map (kbd "C-x C-M-j") 'goto-char)

;; C-aで行頭と最初の文字を行ったり来たり
(defun my-backward-indent ()
  "backward to beginning of the line, otherwise backward to beginning of the indent"
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (move-beginning-of-line nil)))

;; C-eで行末と真ん中を行ったり来たり
(defun my-forward-indent ()
  "forward to end of the line, otherwise backward to half of the line"
  (interactive)
  (if (eolp)
      ((lambda ()
         (backward-char (/ (h-count-line) 2))))
    (move-end-of-line nil)))

(defun h-count-line ()
  "count words and lines in region"
  (save-excursion
    (beginning-of-line)
    (let ((s (point))
          (e nil))
      (end-of-line)
      (setq e (point))
      (- e s))))

(defun replace-thesis-to-general ()
  "replace comma and period to kutouten"
  (interactive)
  (replace-comma-to-touten)
  (replace-period-to-kuten)
  )

(defun replace-general-to-thesis ()
  "replace comma and period to kutouten"
  (interactive)
  (replace-touten-to-comma)
  (replace-kuten-to-period)
  )

(defun replace-comma-to-touten ()
  "replace ， to ，"
  (interactive)
  (replace-regexp-except-string-comment "，" "、" (point-min)))

(defun replace-touten-to-comma ()
  "replace ，，"
  (interactive)
  (replace-regexp-except-string-comment "、" "，" (point-min)))
(defun replace-kuten-to-period ()
  "replace ． to ."
  (interactive)
  (replace-regexp-except-string-comment "。" "．" (point-min)))

(defun replace-period-to-kuten ()
  "replace ．to ．)"
  (interactive)
  (replace-regexp-except-string-comment)"．" "。" (point-min))

(defun all-replace (regex replace)
  (goto-char 1)
  (if (re-search-forward regex nil t nil)
      (progn
        (buffer-substring (match-beginning 0) (match-end 0))
        (replace-match replace)
        (all-replace regex replace)
        ) regex replace)
  )

;; 自動インデントの時に末尾の空白削除
(defadvice fuzzy-format-indent (before remove-end-blank activate)
  (save-excursion
    ;; (all-replace "[ ]+$" "")
    (whitespace-cleanup)
    (remove-space-before-paren)
    (replace-regexp-except-string-comment "\\_> \\{2,\\}\\_<" " " (point-min))
    ;; (remove-space-unused)
    ;; (remove-space-after-comma)
    )
  )
(defvar-local local-reindent-ignore-function nil)
(defvar-local local-reindent-function nil)
(defun my-reindent ()
  (interactive)
  (whitespace-cleanup)
  (remove-space-before-paren)
  (replace-regexp-except-string-comment "\\_> \\{2,\\}\\_<" " " (point-min) (point-max) local-reindent-ignore-function)
  (indent-region (point-min) (point-max))
  (if local-reindent-function
      (funcall local-reindent-function))
  )

(defun remove-space-before-paren ()
  (replace-regexp-except-string-comment "\\([^; \n]+\\) +\)" "\\1)" (point-min) (point-max) local-reindent-ignore-function))

(defun remove-space-unused ()
  (replace-regexp-except-string-comment "\\([^\n ]\\) \\{2,\\}\\([^ ]\\)" "\\1 \\2" (point-min) (point-max) local-reindent-ignore-function))

(defun remove-space-after-comma ()
  ;; (replace-regexp-except-string-comment "\\(,\\)\\([^ ]\\| \\{2,\\}[^ ]\\)" ", \\3" (point-min) (point-max) local-reindent-ignore-function)
  (replace-regexp-except-string-comment "\\([,]\\)\\([^ \n]\\)" "\\1 \\2" (point-min) (point-max) local-reindent-ignore-function)
  )

;; 全角数字から半角数字へ置換
(defun hankaku-num (begin end)
  (interactive "r")
  (let ((zenkaku-numbers '(("０"."0") ("１"."1") ("２"."2") ("３"."3") ("４"."4") ("５"."5") ("６"."6") ("７"."7") ("８"."8") ("９"."9"))))
    (save-excursion
      (mapc (lambda (zenkaku)
              (replace-regexp-except-string-comment (car zenkaku) (cdr zenkaku))
              )
            zenkaku-numbers)))
  )

;; "/"以外を見つけるまでdeleteしていく
(defun delete-line ()
  (if (equal (string (preceding-char)) "/")
      t
    (progn
      (delete-char -1)
      (if (minibuffer-existp)
          (delete-line))
      )
    )
  )

(defun minibuffer-existp ()
  (> (length (minibuffer-contents)) 0))

(defun open-from-find-files ()
  (interactive)
  (let ((file (minibuffer-contents)))
    (if (file-exists-p file)
        (progn
          (open-default-file file)
          ;; (minibuffer-keyboard-quit)
          )
      )
    ))

(defun up-directory ()
  "ミニバッファ上でディレクトリを一つ上に行く"
  (interactive)
  (end-of-line)
  (if (string-match "^~?/$" (minibuffer-contents))
      nil
    (if (minibuffer-existp)
        (progn
          (delete-char -1)
          (delete-line)
          ))
    ))
(define-key minibuffer-local-map (kbd "C-l") 'up-directory)
(define-key minibuffer-local-map (kbd "C-o") 'open-from-find-files)

(defun my-helm-jump-back-config ()
  ;; helmで移動等のアクションを起こす前にマーカーの位置を記録
  (add-hook 'helm-before-action-hook
            (lambda ()
              (ring-insert find-tag-marker-ring (point-marker))
              ))
  ;; kill-buffer等の時は記録する必要は無いので、全く動いてない場合は削除
  (add-hook 'helm-after-action-hook
            (lambda ()
              (if (equal (point-marker) (ring-ref find-tag-marker-ring 0))
                  (ring-remove find-tag-marker-ring 0)
                ))
            )
  )
(my-helm-jump-back-config)

;; TODO lexical-letは24以降ではつかわない
(defun my-register-back-setup ()
  (let ((jump-register-counter 0))
    (defun my-register-back ()
      (interactive)
      (if (> jump-register-counter 0)
          (let ((pre (- jump-register-counter 1)))
            (jump-to-register pre)
            (setq jump-register-counter pre)
            ;; (message "pop %d" jump-register-counter)
            )
        (message "last register")
        )
      )

    (defun my-register-set ()
      (interactive)
      (point-to-register jump-register-counter)
      (setq jump-register-counter (+ jump-register-counter 1))
      )
    )
  )
(my-register-back-setup)


;; unused
(defun my-register-setup ()
  (let ((registers '()))
    (defun my-register-back ()
      (interactive)
      (if (null? registers)
          (message "last register")
        (let ((jump (car registers)))
          (jump-to-register jump)
          )))
    )
  )

;; (add-hook 'helm-goto-line-before-hook (lambda () (my-register-set)))

(defun undo-all ()
  "Undo all edits."
  (interactive)
  (when (listp pending-undo-list)
    (undo))
  (while (listp pending-undo-list)
    (undo-more 1))
  (message "Buffer was completely undone"))

;; 文字列やコメント以外を置換する関数
(defun replace-regexp-except-string-comment (regexp replace &optional begin end condition)
  (save-excursion
    (if begin (goto-char begin))
    (while (and (re-search-forward regexp nil t) (check-end end))
      (if (and (check-replace-condition condition) (not (in-string-or-comment-p (- (point) 1))))
          (progn
            (replace-match replace)
            (forward-char 1)
            )
        ;; (_replace-except-string-comment replace (parse-partial-sexp (point-min) (- (point) 1)))
        (forward-char 1)
        )
      )))

(defun count-regexp-except-string-comment (regexp &optional begin end condition)
  (save-excursion
    (if begin (goto-char begin))
    (let (matches '())
      (while (and (check-end end) (save-excursion (_search-regexp-except-string-comment regexp begin end condition)))
        (let ((result (_search-regexp-except-string-comment regexp begin end condition)))
          (push result matches))
        )
      (length matches)
      )
    )
  )

(defun _search-regexp-except-string-comment (regexp &optional begin end condition)
  (let ((continuep t))
    (while continuep
      (let ((match (re-search-forward regexp nil t))
            (conditionp (check-replace-condition condition))
            (in-stringp (in-string-or-comment-p (point))))
        (if (and match conditionp (not in-stringp))
            (setq continuep nil))
        (if (or (not match) (not (check-end end)))
            (progn
              (setq continuep nil)
              (set-match-data nil)))
        )
      )
    )
  (match-data)
  )

(defun check-replace-condition (condition)
  (if condition
      (funcall condition)
    t
    ))
(defun check-end (end)
  (cond ((not end) t)
        ((< (point) end) t)
        (t nil)))

(defun in-string-or-comment-p (point)
  (let* ((state (parse-partial-sexp (point-min) point))
         (in_string (nth 3 state))
         (in_comment (nth 4 state)))
    (cond
     (in_string 'string)
     (in_comment 'comment)
     )
    ))
;; ;; 自作helm試作中
;; (helm :sources '((name . "aiueo")
;;                  (candidates-in-buffer)
;;                  ;; (candidates . '("aiueo" "abcde" "osaki"))
;;                  (action . (lambda (e) (message "%s" e)))
;;                  (init . (lambda () (helm-init-candidates-in-buffer 'global '("aiueo" "abcde"))))
;;                  ))

;; obarrayすべて表示
(defun helm-all ()
  (interactive)
  (helm-comp-read "M-x " obarray)
  )

(defun get-file-name-except-extension ()
  (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))
  )
(defvar zenkaku-regexp "[^\x01-\x7E]")


;; 最近閉じたファイルを開きたいが、kill-bufferが頻繁に呼び出されているため使えそうにない
;;;###autoload
(defcustom my-marker-ring-length 16
  "Length of marker rings `my-marker-ring'."
  :group 'my-lisp
  :type 'integer
  :version "1")

;;;###autoload
(defvar my-marker-ring (make-ring my-marker-ring-length)
  "Ring of markers which are locations from which \\[find-tag] was invoked.")

;;;###autoload
(defun pop-my-mark ()
  "Pop back to where \\[find-tag] was last invoked.

This is distinct from invoking \\[find-tag] with a negative argument
since that pops a stack of markers at which tags were found, not from
where they were found."
  (interactive)
  (if (ring-empty-p my-marker-ring)
      (message "No previous locations for find-tag invocation")
    (let ((buffer-name (ring-remove my-marker-ring 0)))
      (find-file buffer-name)
      )))

;;;###autoload
(defun save-all-buffer-without-confirm ()
  (interactive)
  (save-some-buffers t))

;; 関数の処理速度測定関数を作りたい
;;;###autoload
(defun measure-time (func)
  (let* ((begin (current-time)))
    (funcall func)
    (message "%s %s" begin (current-time))
    ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; defadviceを使った引数の変更例 ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (use-package c-formatter)
(defun get-background-color ()
  "get background color name"
  (face-attribute 'default :background))

(defun kill-current-buffer ()
  (interactive)
  (kill-and-back-to-last-buffer (buffer-name)))

;;;###autoload
(defun generate-provide (&optional buffer)
  (interactive)
  (save-excursion
    (if buffer
        (switch-to-buffer buffer))
    (let* ((name (replace-regexp-in-string "\.el$" "" (buffer-name)))
           )
      (save-excursion
        (goto-char (point-max))
        (insert (concat "(provide '" name ")"))
        )
      ))
  )

;; 文字数と行数を表示
(defun count-lines-and-chars ()
  (if mark-active
      (format "%d lines,%d chars "
              (count-lines (region-beginning) (region-end))
              (- (region-end) (region-beginning)))
    ;;(count-lines-region (region-beginning) (region-end)) ;; これだとｴｺｰｴﾘｱがﾁﾗつく
    ""))
(add-to-list 'default-mode-line-format
             '(:eval (count-lines-and-chars)))

;; #!があるファイルは自動的にchmodしてくれる
(defun make-file-executable ()
  "Make the file of this buffer executable, when it is a script source."
  (save-restriction
    (widen)
    (if (string= "#!" (buffer-substring-no-properties 1 (min 3 (point-max))))
        (let ((name (buffer-file-name)))
          (or (equal ?. (string-to-char (file-name-nondirectory name)))
              (let ((mode (file-modes name)))
                (set-file-modes name (logior mode (logand (/ mode 4) 73)))
                (message (concat "Wrote " name " (+x)"))))))))
(add-hook 'sh-mode
          (add-hook 'after-save-hook 'make-file-executable))

;; find-file したディレクトリが存在しなければ作成する
(defadvice find-file (before find-file-mkdir (file &optional WILDCARDS) activate)
  (let ((dirname (file-name-directory file)))
    (if (and dirname (not (file-directory-p dirname)) (not (string-match "/ssh:" dirname)))
        (if (not (= 0 (call-process "mkdir" nil nil nil "-p" (expand-file-name dirname))))
            (error "mkdir %s failed." dirname)))))

;;;###autoload
(defun jump-to-url ()
  (interactive)
  (if (re-search-forward "http" nil t)
      (message "jump to http")
    (message "not found url")
    )
  )
(define-key help-mode-map (kbd "j") 'jump-to-url)

(defvar recently-closed-file-ring (make-ring 10))

(defun popup-recently-closed-buffer ()
  (interactive)
  (let ((b (ring-remove recently-closed-file-ring 0)))
    (if b
        (find-file b))
    ))

(defun kill-and-back-to-last-buffer (&optional buffer)
  (interactive)
  (let ((kill-b (if buffer
                    buffer
                  (current-buffer)))
        )
    (ring-insert recently-closed-file-ring (buffer-file-name))
    (back-to-last-buffer)
    (save-window-excursion
      (kill-buffer kill-b))
    )
  )
(defun back-to-last-buffer ()
  (interactive)
  (switch-to-buffer (my-other-buffer)))

(defun make-buffer-list ()
  (let ((ido-process-ignore-lists t)
        ido-ignored-list
        ido-use-virtual-buffers)
    (ido-make-buffer-list nil)))

(defun filter (condp lst)
  (delq nil
        (mapcar (lambda (x) (and (funcall condp x) x)) lst)))

;; TODO よくわからん依存してるからちょっと考える。
(defun my-other-buffer ()
  (car (ignore-buffer
        (helm-buffer-list)))
  )

(defun ignore-buffer (list)
  (filter (lambda (buffer) (not (string-match "\\*.*" buffer)))
          list))

;; view-modeやdired-modeでqを押した時にbufferも消す．頭の悪い方法．他の方法を検討
(defun quit-window (&optional KILL WINDOW)
  (interactive)
  (kill-and-back-to-last-buffer (current-buffer))
  ;; (kill-buffer-and-window)
  )

(defun my-delete-pair ()
  (interactive)
  (save-excursion
    (ignore-errors (backward-sexp))
    (delete-pair))
  )

(defun rb ()
  (interactive)
  (revert-buffer nil t))

(defun reopen-with-sudo ()
  "Reopen current buffer-file with sudo using tramp."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (if file-name
        (find-alternate-file (concat "/sudo::" file-name))
      (error "Cannot get a file name"))))

(provide '40-my-lisp)
