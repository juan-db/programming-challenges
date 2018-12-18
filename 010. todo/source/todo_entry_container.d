/**
Container for all the currently loaded entries.

The class uses the singleton pattern. Access via `getInstance()`.
*/
class TodoEntryContainer
{
	// Stdlib imports
	import std.file;
	import std.json;

	// Local imports
	import todo_entry;

	private static TodoEntryContainer instance;

	public static TodoEntryContainer getInstance()
	{
		if (instance is null)
		{
			instance = new TodoEntryContainer();
		}
		return instance;
	}

	private TodoEntry[] entries;

	private this() {}

	/**
	Reads the specified file's contents and parses it into an array of
	TodoEntries. This array is set as the currently loaded entries.

	Params:
		filename = File to read.
	Throws:
		FileException if reading the file's contents fails for some reason.
		JSONException if the file's contents doesn't match the expected format.
	*/
	public void loadEntries(string filename)
	{
		entries = [];
		auto fileContents = readText(filename);
		auto json = parseJSON(fileContents);
		foreach (entry; json.array)
		{
			entries ~= TodoEntry.fromJSON(entry);
		}
	}


	/**
	Saves all the currently loaded entries to a file.

	Params:
		filename = Name of the file in which to save the entries.
	*/
	public void saveEntries(string filename)
	{
		auto jsonValue = parseJSON("[]");
		foreach (entry; entries)
		{
			jsonValue.array ~= entry.toJSON();
		}
		write(filename, toJSON(jsonValue));
	}

	/**
	Returns:
		The currently loaded entries.
	*/
	public TodoEntry[] getEntries()
	{
		return entries;
	}

	/**
	Appends the given entry to the list of currently loaded entries.

	Params:
		entry = Entry to add to loaded entries.
	*/
	public void addEntry(TodoEntry entry)
	{
		entries ~= entry;
	}
}
