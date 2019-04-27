require 'io/console'
require 'curses'

=begin
win = Curses::stdscr.subwin(24 + 2, 32 + 2, 0, 0)
win.box(?|, ?-, ?+)
win.addstr("A")
win.setpos(1, 1)
n = win.inch
win.setpos(3, 3)
win.addstr n.to_s
win.refresh
=end

def lc(x, y)
#  win.setpos(x, y)
  print "\e[#{y};#{x}H"
end

def cls
  print "\e[2J"
end

UP = 0
DOWN = 1

def scroll(n)
  if n == 0
    print "\e[1S"
  else n == 1
    print "\e[nT"
  end
end

def wait(n)
  sleep n.to_f / 60
end

Curses.crmode
Curses.curs_set 0

def inkey
#  k = STDIN.getch
  k = nil
  begin
    k = STDIN.read_nonblock(3)
    if k == "\C-c"
      exit
    end
  rescue IO::EAGAINWaitReadable => e
    return 0
  end
  if k[0] == "\e"
    return [ 31, 30, 29, 28 ][k[2].ord - 65]
  end
  return k.ord
end


def scr(x, y)
  Curses::stdscr.setpos(y, x)
  n = Curses::stdscr.inch
  p n
  return n
end

#  print (65 + rand(26)).chr

cls; x = 15
loop do
  lc x, 5; print "O"
  lc rand(32), 23; print "*"
  scroll UP
  wait 3
  k = inkey
  x -= 1 if k == 28
  x += 1 if k == 29
  if scr(0, 0) != 32
    break
  end
end
