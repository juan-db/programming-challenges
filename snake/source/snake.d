class Snake
{
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

	import std.container.dlist;

	private DList!BodyPart body;

	this(int x, int y)
	{
		body = DList!BodyPart();
		body.insertFront(BodyPart(x, y));
	}

	import nice.curses;
	void draw(Curses curses)
	{
		foreach (bodyPart; body)
		{
			curses.stdscr.move(bodyPart.getX, bodyPart.getY);
			curses.stdscr.addch(bodyPart == body.front() ? '@' : '*');
		}
	}
}