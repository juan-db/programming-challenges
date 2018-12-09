import nice.curses;
import game;

void main()
{
	import core.time;

	auto lastUpdate = MonoTime.currTime;
	auto timePerUpdate = dur!"msecs"(250);
	while (true)
	{
		if (MonoTime.currTime - lastUpdate >= timePerUpdate)
		{
			lastUpdate = MonoTime.currTime;
			update(game.getCurses());
		}

		readInput(game.getCurses());
		render(game.getCurses());
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

private void readInput(Curses curses)
{
}
