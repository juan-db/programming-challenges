import std.stdio : writeln;
import to_base;

int main(string[] args)
{
	for (int index = 1; index < args.length; ++index)
	{
		writeln(args[index]);
		writeln(textToHex(args[index]));
		writeln(textToBinary(args[index]));
	}
	return 0;
}
