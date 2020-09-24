Set of files to be used together.

A .c programme to check a list of 'input words' against any given dictionary and decide if they are acceptable. This was programme was the result of a challenge to allocate memory, load a dictionary as a data structure, perform checks against the 'input words', print the results, and unload the dictionary in an efficient way.
I chose to define a "Node" as a list of 28 pointers to other nodes, which would point to NULL by default. The first would represent the end of a word, the others represent the alphabet plus an apostrophe. 
By using a function to allocate memory for new nodes as needed, I could link nodes together such that novel letter routes would create new nodes, and finalised words would use the first pointer to return to the 'base node'.

Once the dictionary was loaded in this way, I could check words since you could move down the nodes for any given number of letters, running into NULL at any point you were 'off script', and look at the first pointer to see if the current position is at a suitable 'word end'.

To unload the dictionary from memory efficiently I used a recursive function, and relied on Valgrind to check for memory leakage that might be created.
