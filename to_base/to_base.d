import std.format : format;

unittest
{
	assert(textToHex("") == "");
	assert(textToHex("Hello, World!") == "48656C6C6F2C20576F726C6421");
}

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

unittest
{
	assert(textToBinary("") == "");
	assert(textToBinary("Hello, World!") == "01001000011001010110110001101100011011110010110000100000010101110110111101110010011011000110010000100001");
}

string textToBinary(string text)
{
	string output = "";
	foreach(char c; text)
	{
		for (int index = 0; index < 8; ++index)
		{
			output ~= ((c >> (7 - index)) & 0b1) + '0';
		}
	}
	return output;
}
