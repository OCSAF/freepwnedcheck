# FreePwnedCheck

With the freepwnedcheck.sh bash script you can quickly check mail addresses against the database via the ingenious API of https://haveibeenpwned.com/API/v2.

## Installation:

The script also requires the JQ program to parse JSON:

    apt-get install jq

## Usage:

The easiest way is to briefly display the Help.

    ./freepwnedcheck.sh -h

You can check individual email addresses as well as entire email lists. Use a text file for the list and write each of the addresses to be checked on one line.

    ./freepwnedcheck.sh -m <email address>
    ./freepwnedcheck.sh -l mylist.txt

Special thanks to Navan Chauhan for the code inspiration - https://github.com/navanchauhan/Pwned and to the open source community for many useful ideas that have accelerated the creation of the scripts! Further ideas and suggestions for improvement are very welcome.

Translated with www.DeepL.com/Translator - Thanks:-)
