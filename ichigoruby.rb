require 'io/console'
require 'io/console/size'
require 'curses'

rows, columns = IO::console_size
if rows < 26 || columns < 34
  puts "resize the console bigger than 26 rows x 34 columns"
  exit
end

Curses::init_screen
Curses::resizeterm(26, 34)

Curses.crmode
Curses.curs_set 0
Curses.noecho
Curses.setscrreg(100, 100)

$win = Curses::stdscr.subwin(24 + 2, 32 + 2, 0, 0)

LEFT = 28
RIGHT = 29
UP = 30
DOWN = 31

$cursorx = 0
$cursory = 0

def lcInner(x, y)
  $win.setpos(y + 1, x + 1)
  #print "\e[#{y};#{x}H"
end

def lc(x, y)
  $cursorx = x
  $cursory = y
  lcInner(x, y)
end

def cls
  $win.clear
  $win.box(?|, ?-, ?+)
  #print "\e[2J"
end

def printInner(s)
  $win.addstr s
end

def print(s)
  printInner s
  if $cursory == 23
    scroll UP
  end
  $win.refresh
end

def rnd(n)
  rand(n)
end

def scroll(n)
  if n == 30
    #$win.scrl(-1)
    for y in 0..22
      for x in 0..31
        n = scr(x, y + 1)
        lcInner x, y
        printInner n.chr
      end
    end
    for x in (0..31)
      lcInner x, 23
      printInner " "
    end
    #print "\e[1S"
  else n == 1
    #$win.scrl(-1)
    #print "\e[nT"
  end
end

def wait(n)
  sleep n.to_f / 60
end

def inkey
#  k = STDIN.getch
#if k == "\C-c"
#  exit
#end
  k = nil
  begin
    k = STDIN.read_nonblock(3)
  rescue IO::EAGAINWaitReadable => e
    return 0
  end
  if k[0] == "\e"
    return [ 31, 30, 29, 28 ][k[2].ord - 65]
  end
  return k.ord
end

def scr(x, y)
  $win.setpos(y + 1, x + 1)
  n = $win.inch
  return n
end

=begin
# test

cls; x = 15
loop do
  lc x, 5; print "O"
  lc rand(32), 23; print "*"
  wait 3
  k = inkey
  x -= 1 if k == 28
  x += 1 if k == 29
  if scr(x, 5) != 32
    break
  end
end

sleep 1

=end
