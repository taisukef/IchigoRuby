require "curses"
Curses::crmode
Curses::noecho

while 1 do
  a = nil
  begin
    a = STDIN.read_nonblock(10)
	p a
  rescue IO::EAGAINWaitReadable => e
  end
  sleep 1
end
