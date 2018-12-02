import std.stdio : writeln;
import to_base;

bool verbose = false;
string[] strings;

void parseArgs(string[] args)
{
	foreach (arg; args)
	{
		if (arg == "--")
		{
			return;
		}
		else if (arg == "-v")
		{
			verbose = true;
		}
		else
		{
			strings ~= arg;
		}
	}
}

int main(string[] args)
{
	if (args.length < 3)
	{
		printUsage();
		return 1;
	}

	string function(string) convertFun;
	switch (args[1])
	{
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

	parseArgs(args[2..$]);

	if (verbose)
	{
		auto funAddress = cast(ulong)convertFun;
		if (funAddress == cast(ulong)&textToBinary)
		{
			writeln("Printing strings in binary.");
		}
		else if (funAddress == cast(ulong)&textToHex)
		{
			writeln("Printing string in hexadecimal.");
		}
	}

	for (int index = 0; index < strings.length; ++index)
	{
		if (verbose)
		{
			writeln("String: ", strings[index]);
			writeln(convertFun(strings[index]));
			writeln();
		}
		else
		{
			writeln(convertFun(strings[index]));
		}
	}
	return 0;
}

void printUsage()
{
	writeln("Usage: ./tobase hex|bin text [...]");
}