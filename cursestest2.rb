require "curses"
include Curses

init_screen
#begin
  win = stdscr.subwin(24 + 2, 32 + 2, 0, 0)
  win.box(?|, ?-, ?+)
  win.setpos(1, 1)
  win.addstr("A")
  win.setpos(1, 1)
  n = win.inch
  win.setpos(3, 3)
  win.addstr n.to_s
  win.refresh
  getch
#ensure
  close_screen
#nd