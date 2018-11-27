import std.format : format;

string textToHex(string text)
{
	auto alphabet = "0123456789ABCDEF";
	string charToHex(char c)
	{
		return format("%c%c", alphabet[c >> 4], alphabet[c & 0b1111]);
	}

	string output = "";
	foreach (char c; text)
	{
		output ~= charToHex(c);
	}
	return output;
}