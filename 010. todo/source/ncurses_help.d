// Standard library
import std.algorithm.comparison : min, max;
import std.math : abs;
import std.typecons : Tuple, tuple;

// DUB packages
import deimos.ncurses;

// I have no idea how to test the function in this file other than manually. All
// of them have been tested a little bit but I'm not sure about edge cases.

/**
Moves the cursor horizontally relative to its current location.

A positive integer will move the cursor to the right while a negative integer
will move the cursor to the left.

The cursor will never move off the screen, i.e. the cursor's position is capped
to the dimensions of the window ([0, 0] and [COLS, LINES]).

Params:
	amount = Amount of columns to move the cursor.
	wrap = If set to true the cursor will move to the next/previous line if the
		   cursor is moved past the end/start of the current line.
*/
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

/**
Moves the cursor vertically relative to its currently location.

A positive integer will move the cursor down while a negative integer will move
the cursor up.

The cursor its capped to the dimensions of the window, i.e. min y is 0 and max y
is LINES.

Params:
	amount = Amount of rows to move the cursor.
*/
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
