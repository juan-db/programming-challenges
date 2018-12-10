import nice.curses;
import map;
import snake;

private Curses gameCurses;
private Map gameMap;
private Snake gameSnake;

public Curses getCurses()
{
	if (gameCurses is null)
	{
		auto config = Curses.Config();
		config.disableEcho = true;
		config.nodelay = true;
		gameCurses = new Curses(config);
	}
	return gameCurses;
}

public Map getMap()
{
	if (gameMap is null)
	{
		gameMap = new Map(getCurses(), 20, 20);
	}
	return gameMap;
}

public Snake getSnake()
{
	if (gameSnake is null)
	{
		gameSnake = new Snake(0, 0);
	}
	return gameSnake;
}