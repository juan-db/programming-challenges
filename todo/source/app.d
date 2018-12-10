import std.stdio : writeln;
import deimos.ncurses;
import std.file;
import std.json;
import std.string : indexOf, toStringz;
import std.array : replicate;
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
	TodoEntry[] entries;
	if (exists(filename))
	{
		if (!isFile(filename))
		{
			writeln("\"", filename, "\" exists but is not a file.");
			return 2;
		}
		else
		{
			try
			{
				auto json = parseJSON(readText(filename));
				foreach (entry; json.array)
				{
					entries ~= TodoEntry.fromJSON(entry);
				}
			}
			catch (FileException fe)
			{
				writeln(fe.msg);
				return 3;
			}
			catch (JSONException je)
			{
				writeln(je.msg);
				return 4;
			}
		}
	}

	/* ncurses initialization. */
	initscr();
	scope(exit) endwin();
	cbreak();
	noecho();
	nonl();
	keypad(stdscr, true);
	nodelay(stdscr, true);
	set_escdelay(0);

	/* Logic */
	drawEntries(entries);
	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{
		if (ch != ERR)
		{
			drawEntries(entries);
		}
	}
	return 0;
}

private void drawEntries(TodoEntry[] entries)
{
	if (COLS == 0)
	{
		return;
	}

	void drawEntries(int indent, TodoEntry[] entries)
	{
		foreach (entry; entries)
		{
			auto note = replicate(" ", indent) ~ entry.getNote();
			if (note.length > COLS)
			{
				if (COLS <= 3)
				{
					attron(A_UNDERLINE);
					addstr(toStringz([".", "..", "..."][COLS - 1]));
					attroff(A_UNDERLINE);
					addch('\n');
				}
				else
				{
					addstr(toStringz(note[0..(COLS - 3)]));
					attron(A_UNDERLINE);
					addstr(toStringz("..."));
					attroff(A_UNDERLINE);
					addch('\n');
				}
			}
			else
			{
				addstr(toStringz(note));
				addch('\n');
			}
			drawEntries(indent + 2, entry.getChildren());
		}
	}

	drawEntries(0, entries);
}
