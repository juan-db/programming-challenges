class TodoEntry
{
	import std.array : appender;
	import std.json;

	private string note;
	private bool done;
	private TodoEntry[] children;

	this(string note)
	{
		this.note = note;
		this.done = false;
	}

	public void setNote(string note)
	{
		this.note = note;
	}

	public void setDone(bool done)
	{
		this.done = done;
	}

	public string getNote()
	{
		return note;
	}

	public bool isDone()
	{
		return done;
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
		output.setDone(json["done"].boolean);
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
		json["done"] = done;
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
		auto repr = appender!string(format("%s<note:%s;done:%s;children:[",
										   typeof(this).classinfo.name,
										   note, done));
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
