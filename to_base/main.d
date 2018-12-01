import std.stdio : writeln;
import to_base;

int main(string[] args)
{
	if (args.length < 3) {
		printUsage();
		return 1;
	}

	string function(string) convertFun;
	switch (args[1]) {
		case "b":
		case "bin":
		case "binary":
			convertFun = &textToBinary;
			break;

		case "h":
		case "hex":
		case "hexadecimal":
			convertFun = &textToHex;
			break;

		default:
			printUsage();
			writeln("Invalid mode: ", args[1], ". Must be one of: hex or binary.");
			return 2;
	}

	for (int index = 2; index < args.length; ++index)
	{
		writeln(convertFun(args[index]));
	}
	return 0;
}

void printUsage() {
	writeln("Usage: ./tobase hex|bin text [...]");
}