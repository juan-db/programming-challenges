class Map
{
	import nice.curses;

	/** Curses window for the map. */
	private Window window;

	/* Size */
	private immutable int width;
	private immutable int height;

	this(Curses curses, int width, int height)
	{
		this.width = width;
		this.height = height;
	}

	public int getWidth()
	{
		return width;
	}

	public int getHeight()
	{
		return height;
	}

	import nice.curses;
	public void render(Curses curses)
	{
	}
}