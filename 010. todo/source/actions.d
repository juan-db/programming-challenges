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
		assert(keyName !is null);
		assert(name !is null);
		assert(description !is null);
		assert(handler !is null);

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

	/**
	Compares this instance to the given other instance.

	Params:
		other = Other instance to compare this instance to.

	Returns:
		True if all properties of this instance is equal to the other instance
		provided.

	Bugs:
		Doesn't compare handler functions - I don't know how to check equality
		of functions.
	*/
	public override bool opEquals(Object other)
	{
		// Apparently once this method is reached the runtime has already
		// checked that the type of `other` matches this type:
		// https://dlang.org/spec/operatoroverloading.html#equals
		auto o = cast(Action)other;
		return this.getKey() == o.getKey()
			   && getKeyName() == o.getKeyName()
			   && getName() == o.getName()
			   && getDescription() == o.getDescription();
	}

	///
	unittest
	{
		auto a = new Action(0, "Something", "Something Else", "Last Thing", function void() {});
		auto b = new Action(0, "Something", "Something Else", "Last Thing", function void() {});
		auto c = new Action(1, "Not Something", "Random Text", "The Description", function void() { auto a = 0; });
		assert(a == a);
		assert(b == b);
		assert(c == c);
		assert(a == b);
		assert(a != c);
	}

	// Exhaustive unit test.
	unittest
	{
		// FIXME This is a really complex test, this should really be simplified somehow.
		auto a = new Action(0, "Something", "Something Else", "Last Thing", function void() {});
		auto b = new Action(0, "Something", "Something Else", "Last Thing", function void() {});
		auto c = new Action(1, "Something", "Something Else", "Last Thing", function void() {});
		auto d = new Action(0, "Nothing",   "Something Else", "Last Thing", function void() {});
		auto e = new Action(0, "Something", "Nothing",        "Last Thing", function void() {});
		auto f = new Action(0, "Something", "Something Else", "Nothing",    function void() {});
		// FIXME can't compare handler functions yet.
		//auto g = new Action(0, "Something", "Something Else", "Last Thing", function void() { auto a = 1; });
		
		assert(a == a);
		assert(b == b);
		assert(c == c);
		assert(d == d);
		assert(e == e);
		assert(f == f);
		// FIXME can't compare handler functions yet.
		//assert(g == g);
		
		assert(a == b);
		assert(a != c);
		assert(a != d);
		assert(a != e);
		assert(a != f);
		// FIXME can't compare handler functions yet.
		//assert(a != g);
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