import std.stdio : writeln;
import deimos.ncurses;
import std.file;
import std.json;
import std.string : indexOf;

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

class TodoEntry
{
	import std.array : appender;
	import std.json;

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


	// =========================================================================
	// === JSON ================================================================
	// =========================================================================

	unittest
	{
		auto expected = new TodoEntry("Hello, World!");
		auto json = expected.toJSON();
		auto actual = TodoEntry.fromJSON(json);
		assert(actual == expected, "to/fromJSON for TodoEntry with no children failed.");
	}

	unittest
	{
		auto expected = new TodoEntry("Hello, World!");
		expected.addChild(new TodoEntry("What's happening?"));
		expected.addChild(new TodoEntry("My day's fine..."));
		auto json = expected.toJSON();
		auto actual = TodoEntry.fromJSON(json);
		assert(actual == expected, "to/fromJSON for TodoEntry with several children failed.");
	}

	unittest
	{
		auto expected = new TodoEntry("Hello, World!");
		expected.addChild(new TodoEntry("What's happening?"));
		expected.getChild(0).addChild(new TodoEntry("My day's fine..."));
		auto json = expected.toJSON();
		auto actual = TodoEntry.fromJSON(json);
		assert(actual == expected, "to/fromJSON for TodoEntry with several layers of children failed.");
	}

	public static TodoEntry fromJSON(JSONValue json)
	{
		auto output = new TodoEntry(json["note"].str);
		foreach (child; json["children"].array)
		{
			output.addChild(TodoEntry.fromJSON(child));
		}
		return output;
	}

	public JSONValue toJSON()
	{
		auto json = JSONValue();
		json["note"] = note;
		JSONValue[] children;
		foreach (child; this.children)
		{
			children ~= child.toJSON();
		}
		json["children"] = children;
		return json;
	}


	// =========================================================================
	// === UTILITY =============================================================
	// =========================================================================

	override public string toString()
	{
		import std.format : format;
		auto repr = appender!string(format("%s<note:%s;children:[",
										   typeof(this).classinfo.name,
										   note));
		foreach (child; children)
		{
			repr.put(child.toString());
		}
		repr.put("]>");
		return repr.data;
	}

	override public bool opEquals(Object o)
	{
		if (o is this)
		{
			return true;
		}

		if (typeid(o) != typeid(this))
		{
			return false;
		}

		auto todoEntry = cast(TodoEntry)o;
		if (todoEntry.note != this.note)
		{
			return false;
		}
		if (todoEntry.children.length != this.children.length)
		{
			return false;
		}
		for (int i = 0; i < this.children.length; ++i)
		{
			if (this.children[i] != todoEntry.children[i])
			{
				return false;
			}
		}
		return true;
	}
}
