
#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>

//Define unload programme
bool unload(void);
bool unload1(void);

// Number of buckets in hash table alphabet/apostrophe/other
const unsigned int N = 28;
//Longest word.
const int LENGTH = 20;
//Number of words in Dictionary
int wordcount = 0;
//Number of misspelled words.
int mispel = 0; //temp
//Unload Level: how deep the unloader is.
int ul = 0;


// Default dictionary
#define DICTIONARY "dictionaries/small"   /////TEMP

//A node is just a list of nodes.
typedef struct node
{
    struct node *next[N];
}
node;

//The base node for the tree;

node* start;

//The travelling node

node* trans;

//The anchor node

node* anc;

int main(int argc, char *argv[])
{
    // Check for correct number of args
    if (argc != 2 && argc != 3)
    {
        printf("Usage: ./speller [DICTIONARY] text\n");     ///TEMP
        return 1;
    }
    // Determine dictionary to use
    char *dictionary = (argc == 3) ? argv[1] : DICTIONARY;

     // Starting table initialise
    start = malloc(sizeof(node));
    if (start == NULL)
    {
        printf("Not enough memory for start, abandoning");
        return 1;
    }

    //Sets each starting gate to closed, except for the recursive 0.
    start-> next[0] = start;
    for(int i = 1; i < N; i++)
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
    FILE * dict = fopen(dictionary, "r");
    do
    {
        dictcon = fread(buffer, sizeof(char), chunksize, dict);
        for (int i = 0; i < dictcon; i++)
        {
            if (buffer[i] == 10)
            {
                place = 0;
                printf("\n");
            }
            else if (buffer[i] == 39)
            {
                place = 27;
                printf(" end    %i  \n", place);
                printf("'");
            }
            else
            {
                place = buffer[i] - 96;
                printf("%c", buffer[i]);
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
                    /*printf("New word declared at %i\n", c);*/
                    wordcount++;
                    /*printf("novel words: %i\n", wordcount);*/
                    //loop this position back to the start.
                    trans-> next[place] = start;
                    trans = start;
                }
                else
                {
                    //You are currently 'writing' a novel path.
                    /*printf("Writing new %i at %i\n", word[c], c);*/
                    //Create a new node, NULL the characters there, and step into it.
                    n = malloc(sizeof(node));
                    if (n == NULL)
                    {
                        printf("error");
                        return 1;
                    }
                    trans-> next[place] = n;
                    for(int k = 0; k < N; k++)
                    {
                        n-> next[k] = NULL;
                    }
                    trans = n;
                }
            }
            else
            {
                // You are somewhere you've been before, keep reading until you come across new characters, looping at discovered nonalphabetical characters.
                /*printf("pass\n");*/
                trans = trans-> next[place];
            }
        }
        printf("chunk written.\n");
    }
    while (dictcon == chunksize);
    printf("DICTIONARY LOADED\n\n");

    //// String to Dictionary integers

    // For a Dictionary we only need to worry about lowercase letters and apostrophes



    /////////////////////////////////////////////////////////////




    ///  SPELLCHECK ///

    //Takes in the text to be checked for errors.

    //Start the array at the start again.
    trans = start;
    // Open the dictionary and read to buffer one chunksize at a time.
    FILE * checktxt = fopen("dictionaries/small2", "r");
    do
    {
        dictcon = fread(buffer, sizeof(char), chunksize, checktxt);
        int i = 0;
        do
        {
            //check the letters and manipulate into integers fit for the nodes. letters are 1-26, apostrophes 27, and everything else is 0.
            place = buffer[i];
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
                printf("\n");
            }

            //If you are charting new ground then this word wasn't in the dictionary.
            if (trans-> next[place] == NULL)
            {
                mispel++;
                printf("\nmistake %i \n", mispel);
                //Burrow through text without adding to misspells until you find a new word.
                do
                {
                    i--;
                    place = buffer[i];
                }
                while ((place == 39) || ((place > 96) && (place < 123)) || ((place > 64) && (place < 91)));
                i++;
                do
                {
                    printf("%c", buffer[i]);
                    place = buffer[i];
                    i++;
                }
                while ((place == 39) || ((place > 96) && (place < 123)) || ((place > 64) && (place < 91)));
                i--;
                //Burrow through text without adding to misspells until you find a new word.
                //return to start.
                trans = start;
            }
            else
            {
                //Nothing to worry about, move through the paths of the tree.
                trans = trans-> next[place];
            }
            i++;
        }
        while (i < dictcon);
    }
    while (dictcon == chunksize);
    printf("\nTHE END\n");
    unload();
}
    ///Unload
bool unload(void)
{
    trans = start;
    anc = start;
    if (unload1() == 1)
    {
        printf("unloaded\n");
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
            printf("moving into level %i at position %i\n", ul, n);
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
    printf("leaving level %i\n", ul);
    ul--;
    return 1;
}


getrusage(RUSAGE_SELF, &after);

getrusage(RUSAGE_SELF, &before);
