import std.stdio : writeln;
import deimos.ncurses;
import std.file;
import std.json;
import std.string : indexOf, toStringz, fromStringz;
import std.array : replicate;
import std.conv : to;
import todo_entry;

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
	scope(exit) endwin();
	if (COLS <= 6)
	{
		writeln("Terminal must be more than 6 columns wide.");
		return 5;
	}
	if (LINES <= 6)
	{
		writeln("Terminal must be more than 6 lines long.");
		return 6;
	}
	cbreak();
	noecho();
	nonl();
	keypad(stdscr, true);
	nodelay(stdscr, true);
	set_escdelay(0);

	drawEntries(entries);
	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{
		if (ch != ERR)
		{
			if (ch == KEY_F(2))
			{
				auto newEntry = createEntry();
				entries ~= newEntry;
			}
			erase();
			move(0, 0);
			drawEntries(entries);
		}
	}
	return 0;
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
	void drawEntries(int indent, TodoEntry[] entries)
	{
		foreach (entry; entries)
		{
			drawEntry(entry, false);
			addch('\n');
			drawEntries(0, entry.getChildren());
		}
	}

	drawEntries(0, entries);
}
