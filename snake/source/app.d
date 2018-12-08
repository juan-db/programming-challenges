import nice.curses;
import game;

void main()
{
	import core.time;

	auto curses = new Curses(Curses.Config());
	auto lastUpdate = MonoTime.currTime;
	auto timePerUpdate = dur!"msecs"(250);

	while (true)
	{
		if (MonoTime.currTime - lastUpdate >= timePerUpdate)
		{
			lastUpdate = MonoTime.currTime;
			update(curses);
		}

		render(curses);
	}
}

private void update(Curses curses)
{

}

private void render(Curses curses)
{
	curses.stdscr.erase();
	curses.stdscr.box(0, 0);
	game.getMap().render(curses);
	game.getSnake().render(curses);
	curses.stdscr.refresh();
	curses.update();
}