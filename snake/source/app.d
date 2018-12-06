void main()
{
	/* Initialize curses. */
	import nice.curses;
	auto curses = new Curses(Curses.Config());

	import core.time;
	import snake : Snake;

	int lastY = 0;
	auto lastUpdate = MonoTime.currTime;
	auto timePerUpdate = dur!"msecs"(250);
	while (true)
	{
		if (MonoTime.currTime - lastUpdate >= timePerUpdate)
		{
			lastUpdate = MonoTime.currTime;
			curses.stdscr.clear();
			auto player = new Snake(3, lastY++);
			player.draw(curses);
			curses.stdscr.box(0, 0);
			curses.stdscr.refresh();
			curses.update();
		}
	}
}