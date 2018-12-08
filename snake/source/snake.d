class Snake
{
	import nice.curses;
	import std.container.dlist;

	struct BodyPart
	{
		private immutable int x;
		private immutable int y;

		this(int x, int y)
		{
			this.x = x;
			this.y = y;
		}

		public int getX()
		{
			return x;
		}

		public int getY()
		{
			return y;
		}
	}

	private DList!BodyPart body;

	this(int x, int y)
	{
		body = DList!BodyPart();
		body.insertFront(BodyPart(x, y));
	}

	void render(Curses curses)
	{
		import game;
		import map;

		auto gameMap = game.getMap();
		auto xOffset = gameMap.getX() + 1;
		auto yOffset = gameMap.getY() + 1;
		foreach (bodyPart; body)
		{
			curses.stdscr.move(xOffset + bodyPart.getX, yOffset + bodyPart.getY);
			curses.stdscr.addch(bodyPart == body.front() ? '@' : '*');
		}
	}
}