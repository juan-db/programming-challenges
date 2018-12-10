int countOccurrences(string str, char character)
{
	int count = 0;
	foreach (c; str)
	{
		if (c == character)
		{
			++count;
		}
	}
	return count;
}
