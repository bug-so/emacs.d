;; tabbar
(use-package tabbar
  :config
  (tabbar-mode 1)
  ;; マウスホイール無効化
  (tabbar-mwheel-mode nil)
  ;; グループ分けしない
  (setq tabbar-buffer-groups-function nil)
  ;; タブに表示させるバッファの設定
  (defvar my-tabbar-displayed-buffers
    '("scratch*" "*Messages*" "*Colors*" "*Faces*" "*vc-")
    "*Regexps matches buffer names always included tabs.")
  (defun my-tabbar-buffer-list ()
    "Return the list of buffers to show in tabs.
Exclude buffers whose name starts with a space or an asterisk.
The current buffer and buffers matches `my-tabbar-displayed-buffers'
are always included."
    (let* ((hides (list ?\ ?\*))
           (re (regexp-opt my-tabbar-displayed-buffers))
           (cur-buf (current-buffer))
           (tabs (delq nil
                       (mapcar (lambda (buf)
                                 (let ((name (buffer-name buf)))
                                   (when (or (string-match re name)
                                             (not (memq (aref name 0) hides)))
                                     buf)))
                               (buffer-list)))))
      ;; Always include the current buffer.
      (if (memq cur-buf tabs)
          tabs
        (cons cur-buf tabs))))
  (setq tabbar-buffer-list-function 'my-tabbar-buffer-list)

  ;; タブのボタンを消す
  (dolist (btn '(tabbar-buffer-home-button
                 tabbar-scroll-left-button
                 tabbar-scroll-right-button))
    (set btn (cons (cons "" nil)
                   (cons "" nil))))
  )


;; 現在未使用
(provide 'tabbar-config)
