import std.stdio : writeln;
import deimos.ncurses;
import std.file;
import std.json;
import std.string : indexOf;
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
	if (!exists(filename))
	{
		writeln("File \"", filename, "\" does not exist.");
		return 2;
	}
	if (!isFile(filename))
	{
		writeln(filename, " is not a file.");
		return 3;
	}
	auto json = parseJSON(readText(filename));
	TodoEntry[] entries;
	foreach (entry; json.array)
	{
		entries ~= TodoEntry.fromJSON(entry);
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
	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{

	}
	return 0;
}
