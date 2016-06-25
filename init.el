;; GCのタイミングを決めるメモリを128Mに
(setq gc-cons-threshold 134217728)

;; el-getのディレクトリをpathに追加
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(add-to-list 'load-path "~/.emacs.d/elpa")
(add-to-list 'load-path "~/.emacs.d/elisp")



(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;; el-getがインストールされていなければインストール
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))

(defun elgp ()
  (interactive)
  (save-window-excursion
    (el-get-list-packages))
  (switch-to-buffer "*el-get packages*")
  )



;; あとで読み込む
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ag-highlight-search t)
 '(ag-reuse-buffers (quote nil))
 '(ag-reuse-window (quote nil))
 '(anzu-deactivate-region t)
 '(anzu-mode-lighter "")
 '(anzu-replace-to-string-separator " => ")
 '(anzu-search-threshold 1000)
 '(anzu-use-migemo t)
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(el-get-is-lazy t)
 '(google-translate-default-source-language "en")
 '(google-translate-default-target-language "ja")
 '(guide-key/idle-delay 0.1)
 '(guide-key/popup-window-position (quote bottom))
 '(guide-key/recursive-key-sequence-flag t)
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((eval font-lock-add-keywords nil (quote (("defexamples\\|def-example-group\\| => " (0 (quote font-lock-keyword-face)))))))))
 '(show-paren-mode t)
 '(tab-group:tab-separator " ")
 '(tool-bar-mode nil)
 '(xdvi-bin "pxdvi")
 '(yas-indent-line (quote fixed))
 '(yas-prompt-functions (quote (my-yas/prompt)))
 '(yas-trigger-key "TAB"))
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get/my-recipe")

;; lock the version of el-get packages
(el-get-bundle tarao/el-get-lock)
(el-get-lock)

;; 同期
(el-get 'sync)

(require 'use-package)
(require 'bind-key)

;; init-loaderを使って設定ファイルを分割
(require 'init-loader)
(init-loader-load "~/.emacs.d/inits")

;; 設定の読み込みでエラーが出れば教えてくれるように設定
(defun init-loader-re-load (re dir &optional sort)
  (let ((load-path (cons dir load-path)))
    (dolist (el (init-loader--re-load-files re dir sort))
      (condition-case e
          (let ((time (car (benchmark-run (load (file-name-sans-extension el))))))
            (init-loader-log (format "loaded %s. %s" (locate-library el) time)))
        (error
         ;; (init-loader-error-log (error-message-string e)) 削除
         (init-loader-error-log (format "%s. %s" (locate-library el) (error-message-string e))) ;追加
         )))))
(put 'erase-buffer 'disabled nil)



;; 初期化が終わったらgcのメモリを戻す
(setq gc-cons-threshold 400000)
(put 'narrow-to-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Ubuntu Mono" :foundry "unknown" :slant normal :weight normal :height 120 :width normal))))
 '(flymake-errline ((((class color)) (:background "darkred"))))
 '(flymake-warnline ((((class color)) (:background "yellow4")))))
