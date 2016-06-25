(el-get 'sync 'js2-mode)
(use-package js2-mode
  :mode (("\\.js$" . js2-mode)
         ("\\.jsm$" . js2-mode)
         )
  :config
  (use-package flymake-jshint
    :config
    (add-hook 'js2-mode-hook
              (lambda ()
                (flymake-jshint-init)
                (flymake-mode t)))
    )
  (el-get 'sync 'js2-refactor)
  (use-package js2-refactor
    :config
    (js2r-add-keybindings-with-prefix "C-c C-m")
    )
  )

(el-get 'sync 'json-mode)
(use-package json-mode
  :mode (("\\.json$" . json-mode))
  :config
  (add-to-list 'ac-dictionary-files (expand-file-name "~/.emacs.d/el-get/auto-complete/dict/js2-mode"))
  (define-key json-mode-map (kbd "C-x C-SPC") 'my-reformat)
  )

(el-get 'sync 'json-reformat)
(use-package json-reformat
  :commands (json-reformat)
  )

;;;###autoload
(defun my-reformat ()
  (interactive)
  (json-reformat-region (point-min) (point-max))
  )
