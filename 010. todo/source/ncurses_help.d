// Standard library
import std.typecons : tuple;

// DUB packages
import deimos.ncurses;

// I have no idea how to test the function in this file other than manually. All
// of them have been tested a little bit but I'm not sure about edge cases.

// Using incredibly simple cap and abs instead of complicated ones in math
// module since all the complex stuff isn't needed I believe.
///
unittest
{
	assert(cap(0, 10, 5) == 5);
	assert(cap(0, 10, -1) == 0);
	assert(cap(0, 10, 15) == 10);
	assert(cap(-100, 100, 0) == 0);
	assert(cap(-100, 100, -200) == -100);
	assert(cap(-100, 100, 200) == 100);
}

/**
Caps the given number between min and max.

Bugs:
	Doesn't enforce a min greater than max or max less than min. This is
	intentional as it's not necessary and the entire purpose of this function
	is to be the bare minimum.

Params:
	min = The minimum value num can be.
	max = The maximum value num can be.
	num = The actual number to check.

Returns:
	`min` if `num` is less than `min`. `max` is `num` is greater than `max`.
	Otherwise, returns `num`.
*/
private int cap(int min, int max, int num)
{
	if (num < min)
	{
		return min;
	}
	else if (num > max)
	{
		return max;
	}
	else
	{
		return num;
	}
}

///
unittest
{
	assert(abs(0) == 0);
	assert(abs(1) == 1);
	assert(abs(-1) == 1);
	assert(abs(10000) == 10000);
	assert(abs(-10000) == 10000);
}

/**
Returns the absolute value of `num`.

Params:
	num = Number whose absolute value to calculate.

Returns:
	The absolute value of `num`.
*/
private int abs(int num)
{
	return (num < 0) ? (-num) : num;
}

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

Bugs:
	If wrapping is enabled and the cursor travels past the top or bottom of the
	screen, wrapping behaves in an unintuitive manner.
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
	x = cap(0, COLS - 1, x);
	y = cap(0, LINES - 1, y);
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
	y = cap(0, LINES - 1, y);
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
