;;;package---Summary

;; (autoload 'flymake "flymake" "mode for flymake" nil t)
;; (autoload 'flymake-easy "flymake-easy" "mode for flymake-easy" nil t)

;; flymake c++
;;; Code:
(defun flymake-cpp-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "g++" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))



;; flymake c
(defun flymake-c-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "gcc" (list "-Wall" "-Wextra" "-fsyntax-only" local-file))))
(defvar flymake-auto-popup-timer nil)

(use-package flymake
  :commands (flymake-mode)
  :config
  (add-hook 'c++-mode-hook
            '(lambda ()
               (flymake-mode t)))

  (add-hook 'c-mode-hook
            '(lambda ()
               (flymake-mode t)
               (unless flymake-auto-popup-timer
                 (setq flymake-auto-popup-timer (run-with-idle-timer 1 t 'my-flymake-display-err-popup.el-for-current-line))
                 )))
  (push '("\\.cpp$" flymake-cpp-init) flymake-allowed-file-name-masks)
  (push '("\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
  (delete '("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup) flymake-allowed-file-name-masks)
  )
(autoload 'flymake-shell "flymake-shell" "flymake for shell script mode" nil t)
(add-hook 'sh-mode-hook
          '(lambda ()
             (flymake-shell-load)))

;; ポップアップが重複する原因不明の現象が怒るので苦肉の策
(defvar prevent-duplicate-flag nil)
;; エラー行で実行するとエラーの内容を表示してくれる
(defun my-flymake-display-err-popup.el-for-current-line ()
  "Display a menu with errors/warnings for current line if it has errors and/or warnings."
  (interactive)
  (let* ((line-no (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data (flymake-make-err-menu-data line-no line-err-info-list)))
    (setq prevent-duplicate-flag (not prevent-duplicate-flag))
    (if (and menu-data prevent-duplicate-flag)
        (popup-tip (mapconcat '(lambda (e) (nth 0 e))
                              (nth 1 menu-data)
                              "\n")))
    )
  )
(define-key global-map (kbd "M-RET") 'my-flymake-display-err-popup.el-for-current-line)

(custom-set-faces
 '(flymake-errline ((((class color)) (:background "darkred"))))
 '(flymake-warnline ((((class color)) (:background "yellow4")))))



;; (use-package flycheck)
;; ;;; Code:
;; (global-flycheck-mode)

;; ;; ;; (add-hook 'after-init-hook #'global-flycheck-mode)
;; ;; (add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; ;; (use-package flycheck-color-mode-line)
;; (eval-after-load "flycheck"
;;   '(add-hook 'flycheck-mode-hook 'flycheck-color-mode-line-mode))
;; (defvar flycheck-mode-hooks '(ruby-mode-hook sh-mode-hook js2-mode-hook))
;; (mapc (lambda (mode-hook)
;;      (add-hook mode-hook 'flycheck-mode))
;;       flycheck-mode-hooks)
;; ;; エラーメッセージの表示方法をポップアップに
;; (eval-after-load 'flycheck
;;   '(custom-set-variables
;;     '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages)))

;; ;; ;; エラーメッセージ表示までの時間を変更
;; (setq flycheck-display-errors-delay 0.3)

(provide '25-flymake)
;;; 25-flymake.el ends here
