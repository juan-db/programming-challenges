import std.stdio : writeln;
import std.conv : to, ConvException;
import caesar_cipher;

int main(string[] args)
{
	if (args.length != 3)
	{
		writeln("Usage: ./caesar <plaintext> <shift>");
		return 1;
	}

	try
	{
		string plaintext = args[1];
		int shift = to!int(args[2]);
		string cipherText = caesarCipher(plaintext, shift);
		writeln(cipherText);
		return 0;
	}
	catch (ConvException except)
	{
		writeln("Shift must be a number");
		return 2;
	}
}
