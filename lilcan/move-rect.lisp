(load "~/quicklisp/setup.lisp")
(mapcar #'ql:quickload '("lispbuilder-sdl" "cl-opengl" "cl-glu"))

(defun terminal256 ()
  (sdl:with-init ()
    (sdl:window 720 480 :title-caption "a term made by terminal256" :flags '(sdl:sdl-opengl))

    ;; cl-opengl needs platform specific support to be able to load GL
    ;; extensions, so we need to tell it how to do so in lispbuilder-sdl
    (setf cl-opengl-bindings:*gl-get-proc-address* #'sdl-cffi::sdl-gl-get-proc-address)

    (setf (sdl:frame-rate) 2)
    (sdl:with-events ()
      (:quit-event () t)

      (:key-down-event ()
        (sdl:push-quit-event))

      (:idle ()
        (draw)
        ;; Change the color of the box if the left mouse button is depressed
        ;(when (sdl:mouse-left-p) (setf *random-color* (sdl:color :r (random 255) :g (random 255) :b (random 255))))

         ;; Clear the display each game loop
        ;(sdl:clear-display sdl:*black*)

         ;; Draw the box having a center at the mouse x/y coordinates.
        ;(sdl:draw-box (sdl:rectangle-from-midpoint-* (sdl:mouse-x) (sdl:mouse-y) 200 200) :color *random-color*)

         ;; Redraw the display
        ;(sdl:update-display)
        ))))

(defun random-hue ()
  (/ (random 1024) 1024))

(defun random-gl-color ()
  (gl:color (random-hue) (random-hue) (random-hue)))

(defun draw ()
  "draw a frame"
  (gl:clear :color-buffer-bit)
  ;; draw a triangle
  (gl:with-primitive :triangles
    (random-gl-color)
    (gl:vertex -1 -1 0) 
    (random-gl-color)
    (gl:vertex 0 1 0)   
    (random-gl-color)
    (gl:vertex 1 -1 0)) 
  ;; finish the frame
  (gl:flush)
  (sdl:update-display))

(terminal256)