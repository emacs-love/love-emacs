;;; love-ui.el --- Configuration Themes for Emacs
;;
;; Author: Guilherme Guerra <guilherme.ga@gmail.com>
;;
;; Copyright (C) 2021  Guilherme Guerra
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;; Commentary:
;;
;; Setup to make emacs ui amazing
;;
;;; Code:

;; UI

(defun general ()
  "Setup theme."

  ;; Improve theme loading; from reddit (https://www.reddit.com/r/emacs/comments/4mzynd/what_emacs_theme_are_you_currently_using/d43c5cw)
  (defadvice load-theme (before clear-previous-themes activate)
    "Clear existing theme settings instead of layering them"
    (mapc #'disable-theme custom-enabled-themes))

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (use-package all-the-icons)

  ;;Enable icons on dired
  (use-package all-the-icons-dired
    :config
    (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))
  (use-package doom-themes
    :config
    (doom-themes-neotree-config)
    (set-face-attribute 'default nil :font "Noto Sans Mono 13")
    (set-face-attribute 'region nil :background "#000" :foreground "#ffffff")

    :init
    (setq selected-theme "doom-material")
    (load-theme (intern selected-theme) t)

    (defun switch-theme()
      (interactive)
      (let* ((theme selected-theme)
             (change (if (string= theme "doom-material") "doom-solarized-light" "doom-material")))
        (load-theme (intern change) t)
        (setq selected-theme change)
        (message "Theme switched from %s to %s" theme change)))
    (global-set-key (kbd "<f9>") 'switch-theme))

  (defun text-scale-twice ()(interactive)(progn(text-scale-adjust 0)(text-scale-decrease 2)))
  (add-hook 'neo-after-create-hook (lambda (_)(call-interactively 'text-scale-twice)))

  ;; Nyan Mode is an analog indicator of your position in the buffer.
  ;; The Cat should go from left to right in your mode-line, as you move your point from 0% to 100%.
  (use-package nyan-mode
    :init
    (nyan-mode t))



  ;;Visually highlight the selected buffer.
  (use-package dimmer
    :init
    (dimmer-mode t)
    :config
    (setq dimmer-fraction 0.5))

  ;; No bars. Doing this first to avoid showing/hidding delay on start
  ;; Makes emacs more minimalist
  (scroll-bar-mode 0)
  (menu-bar-mode 0)
  (tool-bar-mode 0)
  (setq ring-bell-function 'ignore) ;; No freaking bell
  (setq inhibit-splash-screen t)    ;; No splash screen
  (setq inhibit-startup-screen t)

  ;; Better config for columns
  (column-number-mode))

(defun fringe ()
  "Configure the Fringe area. Show indicator beside numbers"

  (use-package flycheck
    :init
    (global-flycheck-mode)
    :config
    (setq flycheck-emacs-lisp-load-path 'inherit))
  ;; Custom bitmap to be shown in the fringe area for lines with any
  ;; sort of linting issues
  (when (fboundp 'define-fringe-bitmap)
    (define-fringe-bitmap 'my-flycheck-fringe-indicator
      (vector #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00011100
              #b00111110
              #b00111110
              #b00111110
              #b00011100
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000)))

  (flycheck-define-error-level 'error
    :overlay-category 'flycheck-error-overlay
    :fringe-bitmap 'my-flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-error)
  (flycheck-define-error-level 'warning
    :overlay-category 'flycheck-warning-overlay
    :fringe-bitmap 'my-flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-warning)
  (flycheck-define-error-level 'info
    :overlay-category 'flycheck-info-overlay
    :fringe-bitmap 'my-flycheck-fringe-indicator
    :fringe-face 'flycheck-fringe-info)

  ;;Get rid of the background color in the Fringe area
  (set-face-attribute 'fringe nil
                      :foreground (face-foreground 'default)
                      :background (face-background 'default))
  (fringe-mode 15))

(defun modeline ()
  "Configuration for the doom-modeline."
  (use-package doom-modeline
    :config
    (setq doom-modeline-height 35)
    (set-face-background 'doom-modeline-bar (face-background 'mode-line))
    (setq doom-modeline-bar-width 1)
    (doom-modeline-mode 1)))

(defun love-ui ()
  "Entry point of UI configuration."
  (general)
  (fringe)
  (modeline))

(provide 'love-ui)

;;; gg-ui.el ends here
