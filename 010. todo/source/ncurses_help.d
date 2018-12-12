// Standard library
import std.algorithm.comparison : min, max;
import std.math : abs;

// DUB packages
import deimos.ncurses;

// TODO not tested that much, only basic functionality tested.
public void moveHorizontal(int amount, bool wrap = false)
{
	int x, y;
	getyx(stdscr, y, x);
	x += amount;
	if (wrap)
	{
		if (x < 0)
		{
			y -= 1 + abs(x) / COLS;
			x = COLS + x;
		}
		else
		{
			y += x / COLS;
			x = x % COLS;
		}
	}
	x = max(min(x, COLS - 1), 0);
	y = max(min(y, LINES - 1), 0);
	move(y, x);
}

// TODO not tested extensively at all. I don't really know how to test ncurses
// related functions and it works for what I need currently.
public void moveVertical(int amount)
{
	int x, y;
	getyx(stdscr, y, x);
	y += amount;
	y = max(min(y, LINES - 1), 0);
	move(y, x);
}