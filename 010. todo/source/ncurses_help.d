// Standard library
import std.algorithm.comparison : min, max;
import std.math : abs;
import std.typecons : Tuple, tuple;

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

/**
Gets cursor coordinates.

Params:
	window = Window whose cursor coordinates to return.

Returns:
	A set with the x and y properties mapped to the x and y coordinates
	for cursor in the specified window.
*/
public auto getCursorCoords(WINDOW* window)
{
	int y, x;
	getyx(window, y, x);
	return tuple!(int, "x", int, "y")(x, y);
}

/**
Reads a string up to the first newline or up to n characters from user input.

Params:
	n = Max length of the string.

Returns:
	A D-style string with a max length of n characters.
*/
public string getNStr(uint n)
{
	import std.string : fromStringz;
	char[] buff;
	buff.length = n;
	getnstr(buff.ptr, n);
	auto str = cast(string)fromStringz(buff.ptr);
	return str.idup;
}
