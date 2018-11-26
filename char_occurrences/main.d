import std.stdio : writeln;
import count_occurrences;

int main(string[] args)
{
	if (args.length != 3)
	{
		writeln("Usage: ./co string character");
		return 1;
	}

	writeln(countOccurrences(args[1], args[2][0]));
	return 0;
}
