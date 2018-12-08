import map;
import snake;

private Map gameMap;
private Snake gameSnake;

public Map getMap()
{
	if (gameMap is null)
	{
		gameMap = new Map(0, 0, 20, 20);
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