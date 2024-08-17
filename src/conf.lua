-- Configuration
function love.conf(t)
  t.modules.joystick = false
  t.modules.physics = false
  t.window.title = "99 Parse"
  -- Disallow changing orientation of the screen
  t.window.resizable = false
  -- Set aspect ratio to be landscape
  t.window.width = 1024
  t.window.height = 768
  -- Hide status bar
  t.window.fullscreen = true
end
