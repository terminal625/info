(defun ezp (path)
  (merge-pathnames path *load-truename*))

(load "~/quicklisp/setup.lisp")
(mapcar #'ql:quickload (list 
  "lispbuilder-sdl"
  "cl-opengl" 
  "cl-glu" ))
(mapcar #'load (list 
  (ezp "package.lisp")
  (ezp "render.lisp")
  (ezp "window.lisp")))

(use-package :render :window)

(defun myinit ()
  (window::myenter)
	(render::myenter)
  )

(defun myloop ()
  (render::draw))

(defun myexit ()
	(render::myleave)
  (window::myleave))

(window::start #'myinit #'myloop #'myexit)
