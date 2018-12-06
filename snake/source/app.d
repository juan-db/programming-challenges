void main()
{
	import nice.curses;
	
	auto curses = new Curses(Curses.Config());
	curses.stdscr.box(0, 0);
}