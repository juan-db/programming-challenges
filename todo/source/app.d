import std.stdio;
import deimos.ncurses;
import std.string;
import std.conv : to;

void main()
{
	/* Initialization */
	initscr();
	scope(exit) endwin();
	cbreak();
	noecho();
	nonl();
	keypad(stdscr, true);
	nodelay(stdscr, true);
	set_escdelay(0);

	/* Logic */;
	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{
	}
}

class TodoEntry
{
	import std.array : appender;

	private string note;
	private TodoEntry[] children;

	this(string note)
	{
		this.note = note;
	}

	public void setNote(string note)
	{
		this.note = note;
	}

	public string getNote()
	{
		return note;
	}

	public void addChild(TodoEntry child)
	{
		children ~= child;
	}

	public TodoEntry getChild(int index)
	{
		return children[index];
	}

	public TodoEntry[] getChildren()
	{
		return children;
	}

	override public string toString()
	{
		auto representation = appender!string(typeof(this).classinfo.name ~ "<note: " ~ note ~ "; children: [");
		foreach (child; children)
		{
			representation.put(child.toString());
		}
		representation.put("]>");
		return representation.data;
	}
}
