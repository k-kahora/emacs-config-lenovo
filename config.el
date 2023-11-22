(set-register ?i '(file . "/home/malcolm/.emacs.d/config.org"))
(set-register ?p '(file . "/home/malcolm/Projects"))
(set-register ?c '(file . "/home/malcolm/clones"))
(set-register ?s '(file . "/home/malcolm/Pictures/screenshots"))
;; Temorary todo list for <2023-04-09 Sun>
(set-register ?t '(file . "/home/malcolm/notes/todo.org"))

(setq-default header-line-format nil)

  (defvar-local hidden-mode-line-mode nil)

  (define-minor-mode hidden-mode-line-mode
    "Minor mode to hide the mode-line in the current buffer."
    :init-value nil
    :global t
    :variable hidden-mode-line-mode
    :group 'editing-basics
    (if hidden-mode-line-mode
	(setq hide-mode-line mode-line-format
	      mode-line-format nil)
      (setq mode-line-format hide-mode-line
	    hide-mode-line nil))
    (force-mode-line-update)
    ;; Apparently force-mode-line-update is not always enough to
    ;; redisplay the mode-line
    (redraw-display)
    (when (and (called-interactively-p 'interactive)
	       hidden-mode-line-mode)
      (run-with-idle-timer
       0 nil 'message
       (concat "Hidden Mode Line Mode enabled.  "
	       "Use M-x hidden-mode-line-mode to make the mode-line appear."))))


  (define-globalized-minor-mode global-hidden-modeline hidden-mode-line-mode
  (lambda () (hidden-mode-line-mode 1)))

(global-hidden-modeline 0)

  ;; If you want to hide the mode-line in every buffer by default
  ;; (add-hook 'after-change-major-mode-hook 'hidden-mode-line-mode)

(defun fk/async-process (command &optional name filter)
  "Start an async process by running the COMMAND string with bash. Return the
process object for it.

NAME is name for the process. Default is \"async-process\".

FILTER is function that runs after the process is finished, its args should be
\"(process output)\". Default is just messages the output."
  (make-process
   :command `("bash" "-c" ,command)
   :name (if name name
	   "async-process")
   :filter (if filter filter
	     (lambda (process output) (message (s-trim output))))))

	(menu-bar-mode -1)
	(tool-bar-mode -1)
	(scroll-bar-mode -1)

    (setq-default left-margin-width 2 right-margin-width 1)
      ;; For a particular buffer
      ;; (set-window-margins (selected-window) 3 1)
  (set-frame-parameter (selected-frame) 'alpha '(95 . 50))
   (add-to-list 'default-frame-alist '(alpha . (60 . 50)))

(setq shell-command-prompt-show-cwd t)

(setq native-comp-async-report-warnings-error nil)

(server-start)

(defvar bootstrap-version)
(let ((bootstrap-file
      (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
	(url-retrieve-synchronously
	"https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
	'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-enable-at-startup nil)

(straight-use-package '( vertico :files (:defaults "extensions/*")
                       :includes (vertico-buffer
                                  vertico-directory
                                  vertico-flat
                                  vertico-indexed
                                  vertico-mouse
                                  vertico-quick
                                  vertico-repeat
                                  vertico-reverse)))

(straight-use-package 'use-package)

(setq straight-use-package-by-default t)

(use-package org :straight (:type built-in)
		     :config 
	    (setq org-agenda-include-diary t)
		      (setq org-agenda-files '("/home/malcolm/Sync/agenda"))
		      (setq org-directory "/home/malcolm/Sync")

		      (setq org-default-notes-files (concat org-directory "/notes.org"))
	  ; C-c C-x C-c to see the coloumn
	  (setq org-columns-default-format "%40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM")
      ;; This is good as you can add custom filters to the agenda this is so much better than manually typing in each one
	      ;; '(("x" agenda)
	      ;;   ("y" agenda*)
	      ;;   ("w" todo "WAITING")
	      ;;   ("W" todo-tree "WAITING")
	      ;;   ("u" tags "+boss-urgent")
	      ;;   ("v" tags-todo "+boss-urgent")
	      ;;   ("U" tags-tree "+boss-urgent")
	      ;;   ("f" occur-tree "\\<FIXME\\>")
	      ;;   ("h" . "HOME+Name tags searches") ;description for "h" prefix
	      ;;   ("hl" tags "+home+Lisa")
	      ;;   ("hp" tags "+home+Peter")
	; My actual ones
	(setq org-agenda-custom-commands 
      '(("j" tags "+personal_project")
      ("g" tags "computer_graphics|programming_languages|research|black_class")
      ("v" tags-todo "computer_graphics|programming_languages|research|black_class")
      ("hh" tags "=0:30")
		("hp" tags "+home+Peter")
		("hk" tags "+home+Kim")))

	  (setq org-tag-alist '((:startgroup . nil)
				("computer_graphics" . ?g) ("research" . ?r)
				("programming_languages" . ?p)
				("black_class" . ?b)
				(:endgroup . nil)
				("mtss" . ?m) ("career" .?l) ("") ("cooking" . ?c) ("school" . ?s) ("personal_project" . ?j)))
	  (setq org-fast-tag-selection-single-key t)
(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/Sync/test.org" "Tasks")
	 "* TODO %?\n  %i\n  %a")
;; I need applications to inclued the following
;; 1.) Company name
;; 2.) Date and time app started
;; 3.) Add a TODO item to my calander that makes me follow up in two weeks

	("a" "Applications" entry (file "~/Sync/internships/applications.org")
	 "* TODO %^{Company}\nSCHEDULED: %^t DEADLINE: %^t\nJob Title: %^{Job Title}" :clock-in t :clock-keep t)
	("s" "School" entry (file "~/Sync/agenda/Todo.org")
	 "* %^{Assignment} %^g%?\nDEADLINE: %^T\n%^{effort}p")
	("i" "Interview Question" entry (file "~/Sync/crack-coding/code-logs.org") "* %^{Question Title} %^g\n- First Attempt %U\n- [[%^{Question Link}][Link]]\n%^{difficulty}p%?" :clock-in t :clock-keep t)))

	  (setq org-log-done 'time))



    ;; This is dope
    (define-key minibuffer-local-map (kbd "<f6>") 'help-for-help)
  (let ((map minibuffer-local-map))
    (define-key map (kbd "C-n")   'next-history-element)
    (define-key map  (kbd "C-p")   'previous-history-element))



(use-package org-roam
:straight t
  )

;; Default user when logging into tramp
(setq tramp-completion-reread-directory-timeout nil)
  (setq tramp-default-user-alist
	(quote (("173.72.18.23#2222" "malcolm"))))

;; doom-henna is my favorite
(use-package doom-themes
  :straight t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  (load-theme 'ef-bio t nil))
;; :init (load-theme 'doom-palenight t nil))

(use-package gruber-darker-theme
  :straight t
  :init (load-theme 'gruber-darker t t))

(use-package ef-themes
  :straight t)
  ;; :init (load-theme 'ef-dark t nil))

(use-package which-key
  :straight t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package vterm
     :straight t
     :config
     (setq vterm-tramp-shells '(("ssh" "/bin/bash")
 )))

(use-package vterm-toggle
  :straight t
  :config (setq vterm-toggle-reset-window-configration-after-exit t))



(use-package evil
    :straight t
    :config
    (evil-mode 1)
    (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
    (evil-global-set-key 'motion "j" 'evil-next-visual-line)
    (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
    )

  (use-package evil-collection
    :straight t
    :config (evil-collection-init))

  ;; Expand this further ^^
(use-package evil-org
  :straight t
  ;; :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

  (use-package evil-easymotion
    :straight t
    :config
;; Set this to space
(setq evilem-keys '(?r ?s ?t ?h ?d ?m ?n ?a ?i ?o))
    (evilem-default-keybindings "SPC"))


  (use-package evil-goggles
    :straight t
    :config
    (evil-goggles-mode)

    ;; optionally use diff-mode's faces; as a result, deleted text
    ;; some red color (as defined by the color theme)
    ;; other faces such as `diff-added` will be used for other actions
    (evil-goggles-use-diff-faces))

  (use-package evil-snipe
    :straight t
    :config
    (evil-snipe-mode +1)
    (evil-snipe-override-mode 1)
    ;; causes errors in magit-mode
    (add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode))

  (use-package evil-commentary
    :straight t
    :config
    (evil-commentary-mode))

(use-package general
   :config
   (general-evil-setup t)


;; Figure out a way to get this to work in insert mode
   (general-create-definer mk/leader-keys
     :keymaps '(normal visual emacs insert)
 :prefix "C-SPC"
 :global-prefix "C-SPC"))


 ;;  (general-unbind '(insert normal visual emacs)
 ;; "SPC" 
 ;; "C-SPC"
;; )
 (mk/leader-keys "o" '(:ignore t :which-key "open something") "t"
   '(:ignore t :which-key "toggles")
;; Single key triggers are for the most used commands like find-file
   "."  '(find-file  :which-key "find file")
   ","  '(switch-to-buffer :which-key "frog jump buffer")
   ";"  '(org-agenda :which-key "org-agenda")
   "tt" '(load-theme :which-key "choose theme"))

   (general-define-key "C-M-j" 'switch-to-buffer)


     ;; could get annoying with vim escape
     (global-set-key (kbd "C-u" ) 'evil-scroll-up)
     (global-set-key (kbd "<escape>" ) 'keyboard-escape-quit)
     (global-set-key (kbd "<escape>" ) 'keyboard-escape-quit)

(global-set-key (kbd "C-S-n") 'other-window)

      ;; to do make f P for private config
    (defun tramp-server ()
      "Find file for tramp"
  (interactive)
(find-file "/ssh:173.72.18.23#2222:")    )

      ;; This is for file management
      (mk/leader-keys
    ;; r s t h n a i o
	"/" '(:ignore t :which-key "file management" )
	"/k" '(delete-cur-file :which-key "delete file")
	"/a" '(save-buffer :which-key "save file")
	"/e" '(make-empty-file :which-key "empty file")
	"/i" '(insert-file :which-key "inser file into buffer")
	"/s" '(tramp-server :which-key "tramp server")
	"/o" '(rename-file :which-key "rename file")
	"/." '(jump-to-register :which-key "Jump to register" ))
    ;; Expand this further ^^
      (mk/leader-keys
	"n" '(:ignore t :which-key "window management" )
	"nr" '(split-window-right :which-key "vertical split" )
	"ns" '(split-window-below :which-key "horizontal-split" )
	"nk" '(delete-window :which-key "remove window from view")
    ;; C-n o is good for EXWM
	"ne" '(delete-other-windows :which-key "remove all windows but current"))

      ;; THis is for buffer management
    ;; Like C-M-j find a simalar binding for buffer switcing it is simply to good

    ;; This is for project related commands
  ;; TODO Eldoc buffer bind this
      (mk/leader-keys
	"p" '(:ignore t :which-key "project based cmd's" )
	"pg" '(projectile-ripgrep :which-key "project rip-grep" )
	"pe" '(projectile-switch-project :which-key "projectile swith project's" )
	"pj" '(projectile-run-project :which-key "project run" )
	"p." '(projectile-find-file :which-key "Find file in project" )
	"p&" '(async-shell-command :which-key "async shell commands" )
	"pr" '(projectile-run-project :which-key "Run project" )
	"p," '(projectile-switch-to-buffer :which-key "Switch to buffer in project" ))

  ;; Org mode 

      ;; 
      (mk/leader-keys
	"s" '(:ignore t :which-key "lsp commands" )
	"sd" '(lsp-describe-session :which-key "describe all lsp sessions" )
	"sr" '(lsp-find-references :which-key "lsp find references" )
	"sk" '(lsp-workspace-folders-remove :which-key "kill the lsp for the current workspace" )
	"sx" '(lsp-ui-peek-find-references :which-key "referencs at point" )
	"st" '(:ignore t :which-key "lsp treemacs")
	"sts" '(lsp-treemacs-symbols :which-key "treemacs symobls for file" )
	"stp" '(treemacs :which-key "treemacs for project" ))

      (mk/leader-keys
	"r" '(:ignore t :which-key "Registers" ))


      (mk/leader-keys
	"g" '(:ignore t :which-key "project based cmd's" )
	"gc" '(magit-clone :which-key "magit clone" ))
      ;; Opener's 

      (mk/leader-keys
	"o" '(:ignore t :which-key "launch programs" )
	"of" '(mk/launch-firefox  :which-key "firefox" )
	"og" '(magit :which-key "Open magit" )
	"ot" '(vterm-toggle :which-key "vterm popper")
	"om" '(multi-vterm :which-key "new vterm buffer")
	"oe" '(mk/launch-epiphany :which-key "epiphany" )
	"od" '(docker :which-key "docker" ))

      ;; org roam
      (mk/leader-keys
	"r" '(:ignore t :which-key "org roam" )
	"rg" '(org-roam-graph :which-key "org roam graph" )
	"rf" '(org-roam-node-find :which-key "find roam node" )
	"rc" '(org-roam-capture :which-key "org roam capture" )
	"ri" '(org-roam-node-insert :which-key "insert a new node" ))

      (mk/leader-keys
	"u" '(:ignore t :which-key "buffer managment" )
	"ui" '(insert-buffer :which-key "insert buffer" )
	"uk" '(kill-buffer :which-key "kill buffer" )
	"ua" '(org-switchb :which-key "Org buffer" )
	"ui" '(ibuffer :which-key "ibuffer" ))


      (mk/leader-keys
	"e" '(:ignore t :which-key "elsip evaluations" )
	"ep" '(eval-last-sexp :which-key "eval at point" )
	"ee" '(eval-expression  :which-key "eval expression" )
	"ed" '(eval-defun :which-key "eval defun" )
	"eb" '(eval-buffer :which-key "eval buffer" )
  ;; Make a package for a toggleabl ielm
	"em" '(ielm :which-key "elisp repl" ))
  ;; (+ 40 32)

      (mk/leader-keys
	"l" '(:ignore t :which-key "Latex" )
	"lt" '(org-latex-preview :which-key "ln line latex" )
	"ls" '(org-export-dispatch :which-key "ln line latex" ))



      (mk/leader-keys
	"a" '(:ignore t :which-key "Org agenda" )
	"af" '(org-agenda-file-to-front :which-key "Add file to the org agenda tracker" )
	"ar" '(org-remove-file :which-key "Remove file from the org agenda tracker" )
	"at" '(org-set-tags-command :which-key "Add a tag to the org heading" )
	"ai" '(org-clock-in-last :which-key "Clock in on the last task" )
	"ao" '(org-clock-out :which-key "Clock out of the current task" )
	"ae" '(org-capture :which-key "org capture" )
	"au" '(org-clock-update-time-maybe :which-key "Update clock in time" )
	"al" '(org-store-link :which-key "org store link" )
	"ac" '(hydra-org-agenda-cycle-files/body :which-key "Cycle through all the org agenda files" ))

(use-package hydra
      :straight t)


  (defhydra hydra-org-agenda-cycle-files (:timeout 4)
    "Cycle through all org agenda cycles"
    ("c" org-cycle-agenda-files "next")
    ("k" nil "finished" :exit t))


    (defhydra hydra-text-scale (:timeout 4)
      "scale text"
      ("s" text-scale-increase "in")
      ("t" text-scale-decrease "out")
      ("r" text-scale-set "Equalize")
      ("k" nil "finished" :exit t))


    (defhydra hydra-shape-screen (:timeout 4)

;;  <"h" shrink-window-horizontally "out">
      "adjust window"
      ("l" enlarge-window-horizontally "in")
      ("h" shrink-window-horizontally "out")
      ("k" enlarge-window "up")
      ("j" (enlarge-window -1) "down")
      ("d" balance-windows "equalize")
      ("e" nil "finished" :exit t))

    ;; enlarge-window-horizontallyST

    (mk/leader-keys
      "ts" '(hydra-text-scale/body :which-key "scale-text")
      "tw" '(hydra-shape-screen/body :which-key "size-screen"))

    ;; todo add modifiers so like sftp or ssh

      ;; "ot" '(mk/ssh-team :which-key "terminal for team vm")
      ;; "oi" '(mk/ssh-individual :which-key "terminal for indiviudal vm")
      ;; "on" '(multi-vterm :which-key "create a new vterm")
;;      ("os" (enlarge-window -1) "down"))

(use-package doom-modeline
      :straight t
      :init (setq doom-modeline-height 20)
    (setq doom-modeline-hud nil)
  (setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-minor-modes nil)

     :hook (after-init . doom-modeline-mode))

(use-package all-the-icons
  :straight t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :straight t
  :config
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

(use-package vertico
    :straight t
  :bind (:map vertico-map
	 ("C-n" . vertico-next)
	 ("C-p" . vertico-previous)
	 ("C-f" . vertico-exit)
	 :map minibuffer-local-map
	 ("M-h" . backward-kill-word))
  :custom
  (vertico-cycle t)
    :init
  (vertico-mode))

(use-package vertico-directory
  :after vertico
  :straight t 
  ;; More convenient directory navigation commands
  :bind (:map vertico-map
	      ("TAB" . vertico-directory-enter)
	      ("DEL" . vertico-directory-delete-char))
	      ;; Currentyl do not have accesible Meta Key
	      ;; "M-DEL" . vertico-directory-delete-word
  ;; Tidy shadowed file names
  :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))



;; (use-package vertico-flat
;;   :after vertico
;;   :straight t 
;;   :init
;; (vertico-flat-mode)
;;   ;; More convenient directory navigation commands
;;  )

(use-package orderless
  :straight t
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(orderless basic)
	completion-category-defaults nil
	completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :after vertico
  :straight t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package docker
  :straight t)

(use-package magit
    :straight t
    ; replace current window with magit
    :custom (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
    :bind (("C-x g" . magit)))

;; this causes serious lag if you do not ignore the venv directory for python

;;   (use-package magit-todos
;;     :straight t
;; :init (magit-todos-mode))

(defalias 'yes-or-no-p 'y-or-n-p)

(use-package dmenu :ensure t :bind ("s-SPC" . 'dmenu))

(defun exwm-async-run (name)
    (interactive)
    (start-process name nil name))

  (defun mk/launch-epiphany ()
    (interactive)
    (exwm-async-run "epiphany"))

  (defun mk/lock-screen ()
    (interactive)
    (exwm-async-run "slock"))

  (defun mk/shutdown ()
    (interactive)
    (start-process "halt" nil "sudo" "halt"))

(defun mk/launch-firefox ()
  (interactive)
  (async-shell-command "flatpak run org.mozilla.firefox"))

(global-set-key (kbd "s-f") 'mk/launch-firefox)
(global-set-key (kbd "<s-e>") 'mk/launch-epiphany)
(global-set-key (kbd "<XF86Favorites>") 'mk/lock-screen)
(global-set-key (kbd "<XF86Tools>") 'mk/shutdown)

(defconst volumeModifier "4")

(defun audio/mute ()
  (interactive)
  (start-process "audio-mute" nil "pulseaudio" "--toggle-mute"))

(defun audio/raise-volume ()
  (interactive)
  (start-process "raise-volume" nil "pulseaudio" "--change-volume" (concat "+" volumeModifier)))

(defun audio/lower-volume ()
  (interactive)
  (start-process "lower-volume" nil "pulseaudio" "--change-volume" (concat "-" volumeModifier)))

(global-set-key (kbd "<XF86AudioMute>") 'audio/mute)
(global-set-key (kbd "<XF86AudioRaiseVolume>") 'audio/raise-volume)
(global-set-key (kbd "<XF86AudioLowerVolume>") 'audio/lower-volume)

(use-package org-bullets
  :straight t
  :hook (org-mode . org-bullets-mode)
  :custom (org-bullets-bullet-list '("♱" "⚉" "⚇" "⚉" "⚇" "⚉" "⚇")))

(setq powerline-default-separator nil)

(setq display-time-24hr-format t)
  (setq display-time-format "%H:%M - %d %B %Y")
(display-time-mode 1)

(use-package fancy-battery
  :straight t
  :config
    (setq fancy-battery-show-percentage t)
    (setq battery-update-interval 15)
    (if window-system
      (fancy-battery-mode)
      (display-battery-mode)))

(setq scroll-conservatively 100)

(use-package swiper
  :straight t
  :bind (("C-s" . 'swiper)
  :map ivy-minibuffer-map
    ("C-j" . 'ivy-next-line)
    ("C-k" . 'ivy-previous-line)
  )
)

(global-set-key (kbd "C-x b") 'ibuffer)

(use-package frog-jump-buffer :straight t
:config
(setq frog-jump-buffer-include-current-buffer nil)
(setq frog-jump-buffer-default-filter 'frog-jump-buffer-filter-file-buffers)

  (setq frog-jump-buffer-use-all-the-icons-ivy t))

(defun config-reload ()
  "Reloads ~/.emacs.d/config.org at runtime"
  (interactive)
  (org-babel-load-file (expand-file-name "~/.emacs.d/literal-config.org")))
(global-set-key (kbd "C-c r") 'config-reload)

(setq electric-pair-pairs '(
			     (?\{ . ?\})
			     (?\( . ?\))
			     (?\[ . ?\])
			     (?\" . ?\")
			     ))
(electric-pair-mode t)

(use-package beacon
  :straight t
  :config
    (beacon-mode 1))

(use-package sudo-edit
  :straight t
  :bind
    ("s-e" . sudo-edit))

(org-babel-do-load-languages
  'org-babel-load-languages
  '((emacs-lisp . t)
    (python . t)))

(push '("conf-unix" . conf-unix) org-src-lang-modes)

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("n" . "name" ))

   (with-eval-after-load 'org
     (org-babel-do-load-languages
         'org-babel-load-languages
         '((emacs-lisp . t)
         (python . t) (C . t)  (shell . t) (scheme . t))))

(set-frame-parameter (selected-frame) 'alpha '(85 . 70))
 (add-to-list 'default-frame-alist '(alpha . (85 . 70)))
 (set-frame-parameter (selected-frame) 'fullscreen 'maximized)
 (add-to-list 'default-frame-alist '(fullscreen . maximized))

 (defun mk/set-wallpaper ()
   "Sets a random wallpaper on reload"
   (interactive)
   (async-shell-command "compton")
   (start-process-shell-command
   "feh" nil "feh --bg-scale /home/malcolm/Downloads/Backgrounds/kirby-yarn.jpg"))

(use-package flatui-theme
  :straight t)

; custom themes
(add-to-list 'custom-theme-load-path "/home/malcolm/.emacs.d/custom-themes")

(use-package helpful
      :straight t
      :config

    (global-set-key (kbd "C-h v") #'helpful-variable)
    (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h f") #'helpful-callable)
    ;; Lookup the current symbol at point. C-c C-d is a common keybinding
;; for this in lisp modes.
(global-set-key (kbd "C-M-d") #'helpful-at-point)

;; Look up *F*unctions (excludes macros).
;;
;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
;; already links to the manual, if a function is referenced there.
(global-set-key (kbd "C-h F") #'helpful-function)

;; Look up *C*ommands.
;;
;; By default, C-h C is bound to describe `describe-coding-system'. I
;; don't find this very useful, but it's frequently useful to only
;; look at interactive functions.
(global-set-key (kbd "C-h C") #'helpful-command))

(use-package multi-vterm
	:config
	(add-hook 'vterm-mode-hook
			(lambda ()
			(setq-local evil-insert-state-cursor 'box)
			(evil-insert-state)))
	(define-key vterm-mode-map [return]                      #'vterm-send-return))

	;(setq vterm-keymap-exceptions nil)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
	;(define-key vterm-mode-map (kbd "C-M-j") #'switch-to-buffer)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
	;(evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
	;(evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
	;(evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-vterm)
	;(evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-vterm-next)
	;(evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-vterm-prev)
	;(evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
	;(evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
	;(evil-define-key 'normal vterm-mode-map (kbd "p")        #'vterm-yank)
	;(evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume))

(set-face-attribute 'default nil :family "Iosevka Extended" :height 150)

(use-package desktop-environment
      :straight t
      :after exwm
      :config (desktop-environment-mode)
  (setenv "GPG_AGENT_INFO" nil)
(setq epa-pinentry-mode 'loopback))

(use-package projectile
    :straight t
    :init
    (projectile-mode 1)
    :config

    (projectile-register-project-type 'ruby-raw '("Gemfile" "main.rb")
				    :project-file "Gemfile"
				    :compile "bundle exec rake"
				    :src-dir "./"
				    :test "bundle exec rspec"
				    :test-dir "spec/"
				    :run "ruby main.rb"
				    :test-suffix "_spec")

    (setq projectile-project-search-path '(("~/Development/" . 3) "~/clones/" ))
    :bind (:map projectile-mode-map
    ; I don't know what keu vinfing I like I want to test out what key bindings feel best
      ("s-p" . projectile-command-map)
      ("C-c p" . projectile-command-map)))
(use-package projectile-ripgrep
  :straight t
  :after projectile
  :config
  (evil-collection-ripgrep-setup))

(setq org-todo-keywords
    '((sequence "TODO" "REVISIT" "SHAKY" "|" "DONE" "REVISITED" "SOLID")
      (sequence "BUG(b)" "FEATURE(r)" "KNOW BUG(k)" "|" "FIXED(f)")))

(use-package org-roam
  :straight nil
  :custom
  (org-roam-directory (file-truename "~/Notes/Roam"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  ;; If you're using a vertical completion framework, you might want a more informative completion interface
  (setq org-roam-node-display-template (concat "${title:*} " (propertize "${tags:10}" 'face 'org-tag)))
  (org-roam-db-autosync-mode)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol))

(use-package lsp-mode
		    :straight t
		    :commands (lsp lsp-deferred)
		    :custom
		    ;; what to use when checking on-save. "check" is default, I prefer clippy
		    (lsp-rust-analyzer-cargo-watch-command "clippy")
		    (lsp-eldoc-render-all t)
		    (lsp-idle-delay 0.6)
		    ;; enable / disable the hints as you prefer:
		    (lsp-rust-analyzer-server-display-inlay-hints t)
		    (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
		    (lsp-rust-analyzer-display-chaining-hints t)
		    (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
		    (lsp-rust-analyzer-display-closure-return-type-hints t)
		    (lsp-rust-analyzer-display-parameter-hints nil)
		    (lsp-rust-analyzer-display-reborrow-hints nil)
		    :config
		    (add-hook 'lsp-mode-hook 'lsp-ui-mode)
		    (setq lsp-keymap-prefix "C-SPC x")
		    :hook
	      (python-mode . lsp))
		    ;; optionally
		    (use-package lsp-ui
		      :hook (lsp-mode . lsp-ui-mode)
		      :commands lsp-ui-mode
		    :custom
		    (lsp-ui-peek-always-show t)
		    (lsp-ui-sideline-show-hover t)
		    (lsp-ui-doc-enable t))
      (use-package lsp-treemacs
    :after lsp)
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Start LSP Mode and YASnippet mode
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'go-mode-hook #'yas-minor-mode)

  (add-hook 'go-mode-hook #'lsp)
      ;;   (define-key lsp-ui-mode-map [remap xref-next-line] #'lsp-ui-peek--select-next)

      ;; (define-key lsp-ui-mode-map (kbd "C-j") #'xref-next-line)

		    ;; if you are helm user
		    ;; if you are ivy user

		    ;; optionally if you want to use debugger

		    ;; (use-package dap-mode)

		    ;; (use-package dap-LANGUAGE) to load the dap adapter for your language

		    ;; optional if you want which-key integration
		    ;; (use-package which-key
		    ;;     :config
		    ;;     (which-key-mode))

(use-package lsp-pyright
  :after lsp-mode
  :custom
  (lsp-pyright-auto-import-completions nil)
  (lsp-pyright-typechecking-mode "off")
  :config
  (fk/async-process
   "npm outdated -g | grep pyright | wc -l" nil
   (lambda (process output)
     (pcase output
       ("0\n" (message "Pyright is up to date."))
       ("1\n" (message "A pyright update is available."))))))    ; or lsp-deferred

(use-package company
  :straight t
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
	 ("<tab>" . company-complete-selection))
	(:map lsp-mode-map
	 ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-tooltip-align-annotations nil)
  (company-idle-delay 0.0))

(use-package company-box
  :straight t
  :hook (company-mode . company-box-mode))

(use-package pdf-tools
  :straight t)

(use-package pulseaudio-control
  :straight t
  :bind (("<XF86AudioRaiseVolume>" . pulseaudio-control-increase-volume)
	 ("<XF86AudioLowerVolume>" . pulseaudio-control-decrease-volume)
	 ("<XF86AudioMute>" . pulseaudio-control-toggle-current-sink-mute)
	 ("C-c v" . hydra-pulseaudio-control/body)
	 :map exwm-mode-map
	 ("<XF86AudioRaiseVolume>" . pulseaudio-control-increase-volume)
	 ("<XF86AudioLowerVolume>" . pulseaudio-control-decrease-volume)
	 ("<XF86AudioMute>" . pulseaudio-control-toggle-current-sink-mute))
  ;;:bind-keymap ("C-c v" . pulseaudio-control-map)
  :config
  ;; XXX: Maybe -set-volume (1-9 keys sets 10%, 20% etc)?
  ;;      Maybe show selected sink and volume
  (defhydra hydra-pulseaudio-control (:hint nil)
    "Pulseaudio Control"
    ("+" pulseaudio-control-increase-volume "Increase Volume")
    ("i" pulseaudio-control-increase-volume "Increase Volume")
    ("-" pulseaudio-control-decrease-volume "Decrease Volume")
    ("d" pulseaudio-control-decrease-volume "Decrease Volume")
    ("m" pulseaudio-control-toggle-current-sink-mute "Toggle Mute")
    ("s" pulseaudio-control-select-sink-by-name "Select Sink")
    ("q" nil "quit"))
  (setq pulseaudio-control-volume-step "5%"))

(defun vterm-ssh (host)
    (vterm)
    (vterm-send-string (concat "ssh " host "\n")))

  (defun vterm-ssh-office ()
      (interactive)
      (vterm-ssh "sysadmin@csc415-team12.hpc.tcnj.edu"))

  (defun mk/ssh-nixos()
    (interactive)
    (let ((default-directory "/ssh:malcolm@192.168.1.216:"))
      (multi-vterm)))

  (defun mk/ssh-big-black-brick()
    (interactive)
    (let ((default-directory "/ssh:malcolm@bigblackbrick:"))
      (multi-vterm)))

  (defun mk/ssh-pi-black()
    (interactive)
    (let ((default-directory "/ssh:pi@192.168.1.214:"))
      (multi-vterm)))

  (defun mk/ssh-individual()
    (interactive)
    (let ((default-directory "/ssh:student1@csc415-server05.hpc.tcnj.edu:"))
      (vterm-toggle)))

(define-key vterm-mode-map [(control tab)]   #'vterm-toggle-insert-cd)

(use-package simple-httpd
  :straight t)

(use-package toml-mode)

(use-package rust-mode
  :hook (rust-mode . lsp))

;; Add keybindings for interacting with Cargo
(use-package cargo
  :hook (rust-mode . cargo-minor-mode))

(use-package flycheck-rust
  :config (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(use-package go-mode
    :straight t)


(add-hook 'before-save-hook 'gofmt-before-save)

    (add-hook 'go-mode-hook (lambda ()
      (setq tab-width 4)))
(setenv "PATH" (concat (getenv "PATH") ":/usr/bin/go"))

(use-package rustic
  :straight t
  :bind (:map rustic-mode-map
	      ("C-S-e" . lsp-ui-imenu)
	      ("C-c C-c ?" . lsp-find-references)
	      ("C-c C-c l" . flycheck-list-errors)
	      ("C-c C-c a" . lsp-execute-code-action)
	      ("C-c C-c r" . lsp-rename)
	      ("C-c C-c q" . lsp-workspace-restart)
	      ("C-c C-c Q" . lsp-workspace-shutdown)
	      ("C-c C-c s" . lsp-rust-analyzer-status))
 :config (setq rustic-format-on-save t))

(use-package ox-moderncv
    :straight nil
    :load-path "/home/malcolm/.emacs.d/org-cv"
    :init (require 'ox-moderncv))

(use-package exec-path-from-shell
	:straight t)
  ;; Do this when I have a daemon running aka emacs server
  (when (daemonp)
    (exec-path-from-shell-initialize))
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(use-package yasnippet
  :straight t
  :config
  (add-hook 'prog-mode-hook 'yas-minor-mode)
  (add-hook 'text-mode-hook 'yas-minor-mode)
  (yas-global-mode 1))

(defun async-shell-to-buffer (cmd)
  (interactive "sCall command: ")
  (let ((output-buffer (generate-new-buffer (format "*async:%s*" cmd)))
        (error-buffer  (generate-new-buffer (format "*error:%s*" cmd))))
    (async-shell-command cmd output-buffer error-buffer)))

(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-api-url-base "http://localhost:3000")
   (chatgpt-shell-openai-key
    (lambda ()
      ;; Here the openai-key should be the proxy service key.
      (auth-source-pass-get 'secret "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")))))
;; (setq chatgpt-shell-openai-key
;;       (lambda ()
;; 	(auth-source-pick-first-password :host "api.openai.com")))

(use-package envrc
:straight t)
(envrc-global-mode)

(setq initial-scratch-message
        "



                       ;▓█████ ██▒   █▓ ██▓ ██▓
                       ;▓█   ▀▓██░   █▒▓██▒▓██▒
                       ;▒███   ▓██  █▒░▒██▒▒██░
                       ;▒▓█  ▄  ▒██ █░░░██░▒██░
                       ;░▒████▒  ▒▀█░  ░██░░██████▒
                       ;░░ ▒░ ░  ░ ▐░  ░▓  ░ ▒░▓  ░
                        ;░ ░  ░  ░ ░░   ▒ ░░ ░ ▒  ░
                          ;░       ░░   ▒ ░  ░ ░  ░
                          ;░  ░     ░   ░      ░
                                  ;░



               \"█████  ███▄ ▄███▓ ▄▄▄       ▄████▄    ██████
               ▓█   ▀ ▓██▒▀█▀ ██▒▒████▄    ▒██▀ ▀█  ▒██    ░
               ▒███   ▓██    ▓██░▒██  ▀█▄  ▒▓█    ▄ ░ ▓██▄▄
               ▒▓█  ▄ ▒██    ▒██ ░██▄▄▄▄██ ▒▓▓▄ ▄██▒  ▒   ██▒
               ░▒████▒▒██▒   ░██▒ ▓█   ▓██▒▒ ▓███▀ ░▒██████▒▒
               ░░ ▒░ ░░ ▒░   ░  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▓▒ ▒ ░
                ░ ░  ░░  ░      ░  ▒   ▒▒ ░  ░  ▒   ░ ░▒  ░ ░
                  ░   ░      ░     ░   ▒   ░        ░  ░  ░
                  ░  ░       ░         ░  ░░ ░            ░
                                           \"")

(use-package typescript-mode
:mode "\\.ts\\'"
:hook (typescript-mode . lsp-deferred)
:config
(setq typescript-indent-level 2))

(use-package pyvenv
:straight t
:config
;; (setq pyvenv-workon "emacs")  ; Default venv
(pyvenv-tracking-mode 1))

(use-package ada-mode
:straight t)

(use-package tree-sitter-langs
  :straight t)
(use-package tree-sitter
  :straight t)

;; Major mode for editing Dune project files
(use-package dune
  :ensure t)

;; Merlin provides advanced IDE features
(use-package merlin
  :straight t
  :config
  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'merlin-mode-hook #'company-mode)
  ;; we're using flycheck instead
  (setq merlin-error-after-save nil))

(use-package merlin-eldoc
  :straight t
  :hook ((tuareg-mode) . merlin-eldoc-setup))

;; This uses Merlin internally
(use-package flycheck-ocaml
  :straight t
  :config
  (flycheck-ocaml-setup))

  (add-hook 'tuareg-mode-hook #'merlin-mode)
  (add-hook 'caml-mode-hook #'merlin-mode)

(use-package utop
  :straight t
  :config
(add-hook 'tuareg-mode-hook #'utop-minor-mode))
