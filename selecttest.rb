require 'io/console'

while 1 do
  r = IO.select([ STDIN ])
  p r[0]
  if r = STDIN
  	p STDIN.getch
  end
  sleep(1)
end
