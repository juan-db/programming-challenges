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

	/* Logic */
	auto entry = new TodoEntry("Hello, World!");
	entry.addChild(new TodoEntry("What's happening?"));

	addstr(toStringz(entry.toJSON()));

	for (int ch; indexOf("qQ\x1b", ch = getch()) == -1;) // loop till 'q', 'Q', or escape
	{
	}
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

	unittest
	{
		auto expected = new TodoEntry("Hello, World!");
		auto json = expected.toJSON();
		auto actual = TodoEntry.parseJSON(json);
		assert(actual == expected, "JSON conversion/parsing for TodoEntry with no children failed.");
	}

	unittest
	{
		auto expected = new TodoEntry("Hello, World!");
		expected.addChild(new TodoEntry("What's happening?"));
		expected.addChild(new TodoEntry("My day's fine..."));
		auto json = expected.toJSON();
		auto actual = TodoEntry.parseJSON(json);
		assert(actual == expected, "JSON conversion/parsing for TodoEntry with several children failed.");
	}

	public static TodoEntry parseJSON(string jsonString)
	{
		auto json = std.json.parseJSON(jsonString);
		auto output = new TodoEntry(json["note"].str);
		foreach (child; json["children"].array)
		{
			output.addChild(new TodoEntry(child["note"].str));
		}
		return output;
	}

	public string toJSON()
	{
		auto json = JSONValue();
		json["note"] = note;
		JSONValue[] children;
		foreach (child; this.children)
		{
			children ~= std.json.parseJSON(child.toJSON());
		}
		json["children"] = children;
		return std.json.toJSON(json);
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
