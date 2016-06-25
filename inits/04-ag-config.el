(el-get 'sync 'ag)
(use-package ag
  :commands (ag)
  :config
  (custom-set-variables
   '(ag-highlight-search t)  ; 検索結果の中の検索語をハイライトする
   '(ag-reuse-window 'nil)   ; 現在のウィンドウを検索結果表示に使う
   '(ag-reuse-buffers 'nil)) ; 現在のバッファを検索結果表示に使う
  (define-key ag-mode-map (kbd "r") 'wgrep-change-to-wgrep-mode)
  (add-to-list 'ag-arguments "-u")
  )

(use-package wgrep-ag
  :commands (wgrep-ag-setup)
  )

(add-hook 'ag-mode-hook 'wgrep-ag-setup)
;; agの検索結果バッファで"r"で編集モードに。
;; C-x C-sで保存して終了、C-x C-kで保存せずに終了
;; キーバインドを適当につけておくと便利。"\C-xg"とか
