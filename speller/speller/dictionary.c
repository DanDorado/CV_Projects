// Implements a dictionary's functionality

#include <stdbool.h>

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "dictionary.h"

// Number of buckets in hash table
const unsigned int N = 28;

// Represents a node in a hash table
//A node is just a list of nodes.
typedef struct node
{
    struct node *next[N];
}
node;

//The base node for the tree;

node *start;

//The travelling node

node *trans;

//The anchor node

node *anc;

//Unload Level: how deep the unloader is.
int ul = 0;

//Number of words in Dictionary
int wordcount = 0;

// Returns true if word is in dictionary else false
bool check(const char *word)
{
    ///  SPELLCHECK ///

    //Takes in the text to be checked for errors.

    //Start the array at the start again.
    trans = start;
    int place = 0;
    int i = 0;
    do
    {
        //check the letters and manipulate into integers fit for the nodes. letters are 1-26, apostrophes 27, and everything else is 0.
        place = word[i];
        if (place == 39)
        {
            place = 27;
        }
        else if ((place > 96) && (place < 123))
        {
            place = place - 96;
        }
        else if ((place > 64) && (place < 91))
        {
            place = place - 64;
        }
        else
        {
            place = 0;
        }
        //If you are charting new ground then this word wasn't in the dictionary.
        if (trans-> next[place] == NULL)
        {
            return 0;
        }
        else
        {
            //Nothing to worry about, move through the paths of the tree.
            trans = trans-> next[place];
        }
        i++;
    }
    while (place != 0);
    return 1;
}

// Hashes word to a number
unsigned int hash(const char *word)
{
    // TODO
    return 0;
}

// Loads dictionary into memory, returning true if successful else false
bool load(const char *dictionary)
{
    // Starting table initialise
    start = malloc(sizeof(node));
    if (start == NULL)
    {
        return false;
    }

    //Sets each starting gate to closed, except for the recursive 0.
    start-> next[0] = start;
    for (int i = 1; i < N; i++)
    {
        start-> next[i] = NULL;
    }


    /*Table of i - gates. if a gate leads to another node it means:

    0: A non-alphabetical non-' value. Encountering any of these will return to the start and.
    1: A word continued with a here.
    2: A word continued with b here.
    ....
    26: A word continued with z here.
    27: A word continued with an apostrophe here.
    */

    //"start" is the beginning of all words for the tree, always kept active.
    trans = start;
    node *n;
    ///     Making Dictionary     ///

    //A placeholder integer which is used to populate the tree and changes value depending on the character in the buffer.
    int place = 0;

    // CONVERT WORDS TO INTS //
    int chunksize = 10000;

    char buffer[chunksize];
    for (int i = 0; i < chunksize; i++)
    {
        buffer[i] = 0;
    }
    int dictcon = 1;
    FILE *dict = fopen(dictionary, "r");
    do
    {
        dictcon = fread(buffer, sizeof(char), chunksize, dict);
        for (int i = 0; i < dictcon; i++)
        {
            if (buffer[i] == 10)
            {
                place = 0;
            }
            else if (buffer[i] == 39)
            {
                place = 27;
            }
            else
            {
                place = buffer[i] - 96;
            }
            //Populate the tree with words.

            //For the entire word/dictionary.


            //If you come to a new junction, this means that you are writing in uncharted territory. If you come to a NULL zero, it means that you have
            // completed a novel word and increase wordcount.
            if (trans-> next[place] == NULL)
            {
                if (place == 0)
                {
                    //You've discovered a novel route to a non-alphabetical character. A new word.
                    wordcount++;
                    //loop this position back to the start.
                    trans-> next[place] = start;
                    trans = start;
                }
                else
                {
                    //You are currently 'writing' a novel path.
                    //Create a new node, NULL the characters there, and step into it.
                    n = malloc(sizeof(node));
                    if (n == NULL)
                    {
                        return false;
                    }
                    trans-> next[place] = n;
                    for (int k = 0; k < N; k++)
                    {
                        n-> next[k] = NULL;
                    }
                    trans = n;
                }
            }
            else
            {
                // You are somewhere you've been before, keep reading until you come across new characters, looping at discovered nonalphabetical characters.
                trans = trans-> next[place];
            }
        }
    }
    while (dictcon == chunksize);
    fclose(dict);
    return true;
}

// Returns number of words in dictionary if loaded else 0 if not yet loaded
unsigned int size(void)
{
    return wordcount;
}

// Unloads dictionary from memory, returning true if successful else false
bool unload(void)
{
    trans = start;
    anc = start;
    if (unload1() == 1)
    {
        return 1;
    }
    return 0;
}

bool unload1(void)
{
    trans-> next[0] = anc;
    int n = (N - 1);
    do
    {
        if (trans->next[n] != NULL)
        {
            anc = trans;
            trans = trans->next[n];
            ul++;
            unload1();
        }
        n--;
    }
    while (n != 0);
    anc = trans->next[0];
    free(trans);
    if (ul != 0)
    {
        trans = anc;
    }
    ul--;
    return 1;
}
