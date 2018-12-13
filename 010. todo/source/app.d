// Standard library
import std.stdio : writeln;
import std.file;
import std.json;
import std.string : indexOf, toStringz, fromStringz;
import std.array : replicate;
import std.conv : to;
import std.algorithm.comparison : min, max;

// DUB packages
import deimos.ncurses;

// Local
import ncurses_help;
import todo_entry;

private int currentLine = 0;

int main(string[] args)
{
	if (args.length != 2)
	{
		writeln("Usage: ", args[0], " file");
		return 1;
	}

	/* read todo file. */
	auto filename = args[1];
	TodoEntry[] entries = loadEntries(filename);
	if (entries is null)
	{
		return 2;
	}

	/* ncurses initialization. */
	initscr();
	if (LINES <= 6 || COLS <= 16)
	{
		endwin();
		writeln("Terminal dimensions must be at least 6 high and 16 wide.");
		return 5;
	}
	scope(exit) endwin();
	cbreak();
	noecho();
	nonl();
	keypad(stdscr, true);
	nodelay(stdscr, true);
	set_escdelay(0);
	curs_set(0);

	void delegate()[int] actions = [
		KEY_F(2): () => cast(void)(entries ~= createEntry()),
		KEY_UP: () => cast(void)(currentLine = max(currentLine - 1, 0)),
		KEY_DOWN: () => cast(void)(currentLine = min(currentLine + 1, LINES - 1))
	];
	drawEntries(entries);
	move(1, 0);
	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{
		if (ch != ERR)
		{
			if (ch in actions)
			{
				actions[ch]();
				redrawScreen(entries);
			}
		}
	}
	return 0;
}

private void redrawScreen(TodoEntry[] entries, bool resetCursor = false)
{
	erase();
	drawEntries(entries);
	if (resetCursor)
	{
		currentLine = 0;
	}
	move(currentLine, 0);
}

private TodoEntry[] loadEntries(string filename)
{
	TodoEntry[] output;

	if (!exists(filename))
	{
		return output;
	}

	if (!isFile(filename))
	{
		writeln("\"", filename, "\" exists but is not a file.");
		return null;
	}

	try
	{
		auto json = parseJSON(readText(filename));
		foreach (entry; json.array)
		{
			output ~= TodoEntry.fromJSON(entry);
		}
	}
	catch (FileException fe)
	{
		writeln(fe.msg);
		return null;
	}
	catch (JSONException je)
	{
		writeln(je.msg);
		return null;
	}
	return output;
}

private TodoEntry createEntry()
{
	erase();
	attron(A_UNDERLINE);
	addstr(toStringz("Create a new entry:"));
	attroff(A_UNDERLINE);
	addch(' ');
	echo();
	nocbreak();
	nodelay(stdscr, false);
	byte[256] buff;
	getnstr(cast(char*)buff, 256);
	auto str = fromStringz(cast(char*)buff);
	auto output = new TodoEntry(cast(string)(str.idup));
	noecho();
	cbreak();
	nodelay(stdscr, true);
	return output;
}

/**
Draws a single todo entry to the screen where the cursor currently is.

Params:
	entry = todo entry to draw on the screen.
	highlight = whether or not this entry should be highlighted.
*/
private void drawEntry(TodoEntry entry, bool highlight)
{
	auto note = entry.getNote();
	if (note.length > COLS)
	{
		note = note[0..COLS - 4] ~ " ...";
	}
	if (highlight)
	{
		attron(A_STANDOUT);
		addstr(toStringz(note));
		attroff(A_STANDOUT);
	}
	else
	{
		addstr(toStringz(note));
	}
}

private void drawEntries(TodoEntry[] entries)
{
	void drawEntries(TodoEntry[] entries, int depth)
	{
		foreach (entry; entries)
		{
			if (depth > 0)
			{
				auto indent = replicate(" ", depth - 1);
				addstr(toStringz(indent));
				addch('-');
			}
			int x, y;
			getyx(stdscr, y, x);
			drawEntry(entry, y == currentLine);
			addch('\n');
			drawEntries(entry.getChildren(), depth + 1);
		}
	}

	drawEntries(entries, 0);
}
