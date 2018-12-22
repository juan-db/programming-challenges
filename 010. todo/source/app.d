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
import todo_entry_container;
import actions;

private int currentLine = 0;
private string filename;

/**
Maps lines numbers to the entry that appears on that line.
*/
private TodoEntry[int] lineToEntryMap;

int main(string[] args)
{
	if (args.length != 2)
	{
		writeln("Usage: ", args[0], " file");
		return 1;
	}

	/* read todo file. */
	filename = args[1];
	try
	{
		loadEntries(filename);
	}
	catch (FileException fe)
	{
		writeln(fe.msg);
		return 2;
	}
	catch (JSONException je)
	{
		writeln(je.msg);
		return 3;
	}

	/* ncurses initialization. */
	initscr();
	scope(exit) endwin();
	if (LINES <= 6 || COLS <= 16)
	{
		writeln("Terminal dimensions must be at least 6 high and 16 wide.");
		return 5;
	}
	cbreak();
	noecho();
	nonl();
	keypad(stdscr, true);
	nodelay(stdscr, true);
	set_escdelay(0);
	curs_set(0);

	Action[] actions = [
		new Action(KEY_F(2), "F2", "New Entry", "Creates a new entry at the root.", () { addEntry(createEntry()); }),
		new Action(KEY_F(3), "F3", "New Child Entry", "Creates a new child entry for the selected entry.",
				   () { lineToEntryMap[currentLine].addChild(createEntry()); }),
		new Action(KEY_F(4), "F4", "Delete Entry", "Deletes the currently selected entry. (Not Implemented)",
				   () { return; }),
		new Action(KEY_F(5), "F5", "Save To File", "Saves all currently loaded entries to a file",
				   () { saveEntries(filename); }),
		new Action(KEY_UP, "Up arrow", "Change Selection", "Move the cursor up one line.",
				   () { currentLine = max(currentLine - 1, 0); }),
		new Action(KEY_DOWN, "Down arrow", "Change Selection", "Move the cursor down one line.",
				   () { currentLine = min(currentLine + 1, LINES - 1, lineToEntryMap.length - 1); }),
		new Action('?', "?", "Help", "Show available actions.", () { drawHelp(); })
	];
	foreach (action; actions)
	{
		registerAction(action);
	}

	drawEntries(getEntries());
	move(1, 0);
	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{
		if (ch != ERR)
		{
			foreach (action; getActions(ch))
			{
				action();
			}
			redrawScreen(getEntries());
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

/**
Prompts the enter a note for a new entry and creates a new entry using that
note.

Returns:
	A new TodoEntry with a note provided by the user.
*/
private TodoEntry createEntry()
{
	erase();

	// Write prompt for user.
	attron(A_UNDERLINE);
	addstr(toStringz("Create a new entry:"));
	attroff(A_UNDERLINE);
	addch(' ');

	// Set up ncurses.
	echo();
	nodelay(stdscr, false);
	curs_set(1);

	// Get the input from the user.
	auto output = new TodoEntry(getNStr(256));

	// Set ncurses back to its original state.
	noecho();
	nodelay(stdscr, true);
	curs_set(0);

	return output;
}

/**
Clears the screen and draws a hotkey reference describing what each key does.
*/
private void drawHelp()
{
	import std.format : format;
	alias z = toStringz;
	erase();

	// FIXME actions get printed in a random order, add some logical order.
	foreach (action; getActions())
	{
		addstr(z(format("(%s) %s: %s\n", action.getKeyName(), action.getName(), action.getDescription())));
	}

	nodelay(stdscr, false);
	getch();
	nodelay(stdscr, true);
}

/**
Draws a single todo entry to the screen where the cursor currently is.

Params:
	entry = Todo entry to draw on the screen.
	highlight = Whether or not this entry should be highlighted.
*/
private void drawEntry(TodoEntry entry, bool highlight)
{
	//int y, x;
	//getyx(y, x);
	auto line = getCursorCoords(stdscr).y;
	lineToEntryMap[line] = entry;
	auto note = entry.getNote();
	note = (entry.isDone() ? "[x] " : "[ ] ") ~ note;
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

/**
Draws the notes of all given entries to the screen at the current cursor
position.

Children entries get prepended with whitespace relative to their depth and a
distinguishing symbol, e.g. a dash (-).

When drawn it looks something like this:
Root entry.
- Children entry at depth 1.
 - Child entry at depth 2.
 - Another child entry at depth 2.
Second root entry.

Params:
	entries = Entries to draw to the screen.
*/
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

