class Map
{
	/* Offset */
	private immutable int x;
	private immutable int y;
	/* Size */
	private immutable int width;
	private immutable int height;

	this(int x, int y, int width, int height)
	{
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public int getX()
	{
		return x;
	}

	public int getY()
	{
		return y;
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