(use-package gud)

;;; 有用なバッファを開くモード
(setq gdb-many-windows t)
;;; 変数の上にマウスカーソルを置くと値を表示
(add-hook 'gdb-mode-hook '(lambda () (gud-tooltip-mode t)))

;;; I/O バッファを表示
(setq gdb-use-separate-io-buffer t)

;;; t にすると mini buffer に値が表示される
(setq gud-tooltip-echo-area nil)
(add-hook
 'gdb-mode-hook
 '(lambda ()
    (gud-tooltip-mode t)
    (gud-def gud-break-main "break main" nil "Set breakpoint at main.")
    ))
;; (setq gud-tooltip-echo-area nil)

(define-key gud-minor-mode-map (kbd "<f1>") 'gud-print)
(define-key gud-minor-mode-map (kbd "<S-f1>") 'gud-watch)
(define-key gud-minor-mode-map (kbd "<f2>") 'gud-refresh)
(define-key gud-minor-mode-map (kbd "<f5>") 'gud-cont)
(define-key gud-minor-mode-map (kbd "<S-f5>") 'gud-kill)
(define-key gud-minor-mode-map (kbd "<f6>") 'gud-until)
(define-key gud-minor-mode-map (kbd "<f9>") 'gdb-set-clear-breakpoint)
(define-key gud-minor-mode-map (kbd "<S-f9>") 'gud-break-main)
(define-key gud-minor-mode-map (kbd "<f10>") 'gud-next)
(define-key gud-minor-mode-map (kbd "<f11>") 'gud-step)
(define-key gud-minor-mode-map (kbd "<C-f10>") 'gud-until)
(define-key gud-minor-mode-map (kbd "<C-f11>") 'gud-finish)
(define-key gud-minor-mode-map (kbd "<S-f11>") 'gud-finish)

(defun gdb-set-clear-breakpoint ()
  (interactive)
  (if (or (buffer-file-name) (eq major-mode 'gdb-assembler-mode))
      (if (or
           (let ((start (- (line-beginning-position) 1))
                 (end (+ (line-end-position) 1)))
             (catch 'breakpoint
               (dolist (overlay (overlays-in start end))
                 (if (overlay-get overlay 'put-break)
                     (throw 'breakpoint t)))))
           (eq (car (fringe-bitmaps-at-pos)) 'breakpoint))
          (gud-remove nil)
        (gud-break nil))))

(defun gud-kill ()
  "Kill gdb process."
  (interactive)
  (with-current-buffer gud-comint-buffer (comint-skip-input))
  (kill-process (get-buffer-process gud-comint-buffer)))



(provide 'gdb-config)
