/**
Represents an action that can be taken when a key is pressed by the user.

An object of this class can be registered to handle a keypress by the user. When
a key is pressed the program will look for any registered actions whose key
matches the key that was pressed by the user. If the key matches, the function
from the action will be executed.

TODO: how do you register the action?
*/
public class Action
{
	private int key;
	private string keyName;
	private string name;
	private string description;
	private void function() handler;

	/**
	Creates a new `Action` instance registerable as a listener when the user
	presses a key.

	Params:
		key = Key which should trigger this action. See curs_getch(3X) for key code.
		keyName = Human-readable name for the key to press to invoke this action,
				  e.g. "F3" or "Left arrow".
		name = Name of the action which will be displayed on the help screen.
		description = Description for what this action does when invoked.
		handler = Actual function to execute when the key associated with this
				  action is pressed.
	*/
	public this(int key, string keyName, string name, string description,
				void function() handler)
	{
		this.key = key;
		this.keyName = keyName;
		this.name = name;
		this.description = description;
		this.handler = handler;
	}

	public int getKey()
	{
		return key;
	}

	public string getKeyName()
	{
		return keyName;
	}

	public string getName()
	{
		return name;
	}

	public string getDescription()
	{
		return description;
	}

	public void function() getHandler()
	{
		return handler;
	}
}

///
unittest
{
	auto act = new Action(0, "None you can press", "Nothing", "Doesn't do anything.", function void() {});
	assert(act.getKey() == 0);
	assert(act.getKeyName() == "None you can press");
	assert(act.getName() == "Nothing");
	assert(act.getDescription() == "Doesn't do anything.");
	assert(act.getHandler() !is null);
}