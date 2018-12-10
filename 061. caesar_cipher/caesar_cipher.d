import std.algorithm.iteration : map;
import std.array : array;

string caesarCipher(string plaintext, int rotAmount)
{
	dchar rotChar(dchar c) {
		if (c >= 'a' && c <= 'z')
		{
			return (c - 'a' + rotAmount) % 26 + 'a';
		}
		else if (c >= 'A' && c <= 'Z')
		{
			return (c - 'A' + rotAmount) % 26 + 'A';
		}
		else
		{
			return c;
		}
	}

	return cast(string)plaintext.map!(c => rotChar(c)).array;
}