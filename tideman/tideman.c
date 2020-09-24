#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Max number of candidates
#define MAX 9

// preferences[i][j] is number of voters who prefer i over j
int preferences[MAX][MAX];

// locked[i][j] means i is locked in over j
bool locked[MAX][MAX];

// Each pair has a winner, loser
typedef struct
{
    int winner;
    int loser;
}
pair;

// Array of candidates
string candidates[MAX];
pair pairs[MAX * (MAX - 1) / 2];

int pair_count;
int candidate_count;

// Function prototypes
bool vote(int rank, string name, int ranks[]);
void record_preferences(int ranks[]);
void add_pairs(void);
void sort_pairs(void);
void lock_pairs(void);
void print_winner(void);
bool win(int winner, int loser);

int main(int argc, string argv[])
{
    // Check for invalid usage
    if (argc < 2)
    {
        printf("Usage: tideman [candidate ...]\n");
        return 1;
    }

    // Populate array of candidates
    candidate_count = argc - 1;
    if (candidate_count > MAX)
    {
        printf("Maximum number of candidates is %i\n", MAX);
        return 2;
    }
    for (int i = 0; i < candidate_count; i++)
    {
        candidates[i] = argv[i + 1];
    }

    // Clear graph of locked in pairs
    for (int i = 0; i < candidate_count; i++)
    {
        for (int j = 0; j < candidate_count; j++)
        {
            locked[i][j] = false;
        }
    }

    pair_count = 0;
    int voter_count = get_int("Number of voters: ");

    // Query for votes
    for (int i = 0; i < voter_count; i++)
    {
        // ranks[i] is voter's ith preference
        int ranks[candidate_count];

        // Query for each rank
        for (int j = 0; j < candidate_count; j++)
        {
            string name = get_string("Rank %i: ", j + 1);

            if (!vote(j, name, ranks))
            {
                printf("Invalid vote.\n");
                return 3;
            }
        }

        record_preferences(ranks);

        printf("\n");
    }

    add_pairs();
    sort_pairs();
    lock_pairs();
    print_winner();
    return 0;
}

// Update ranks given a new vote
bool vote(int rank, string name, int ranks[])
{
    //for each candidate the voter can vote for.
    for (int check = 0; check < candidate_count; check++)
    {
        //Check to see if the name of that candidate is equal to the one the voter inputted
        printf("Voter voting for %s at position %i\n", name, check);
        string tempname = candidates[check];
        printf("name at that position is %s\n", tempname);
        //if the names are the same then store the store the id for that candidate at that rank.
        if (strcmp(name, tempname) == 0)
        {
            printf("match found, recording vote.\n");
            ranks[rank] = check;
            return true;
        }
    }
    //If no matches are found, invalidate the ballot.
    printf("No matches found, invalid vote.\n");
    return false;
}



// Update preferences given one voter's ranks
void record_preferences(int ranks[])
{
    printf("\nRecording these preferences.\n");
    //For each rank.
    for (int i = 0; i < (candidate_count - 1); i++)
    {
        //store the candidate id at that rank.
        int candid = ranks[i];
        printf("Voter placed candID %i at place %i\nrecording victory over lower placements.\n", candid, i);
        //Now for all ranks below the current rank.
        for (int j = 1; (j + i) < (candidate_count); j++)
        {
            //Look up the candidate id for that rank and score a point for the first id over the second.
            int candidl = ranks[i + j];
            printf("Voter placed lower candID %i at place %i\nrecording.\n", candidl, (i + j));
            preferences[candid][(candidl)]++;
            printf("Total voters preferring candid %i over %i is now %i\n", candid, candidl, preferences[candid][candidl]);
        }

    }
    return;
}

// Record pairs of candidates where one is preferred over the other
void add_pairs(void)
{
    printf("add_pairs\n");
    int paircount = 0;
    //for each candidate.
    for (int i = 0; i < (candidate_count); i++)
    {
        //check each other candidate.
        for (int j = 0; j < (candidate_count); j++)
        {
            //check for ties (not used for anything)
            if (preferences[i][j] == preferences[j][i])
            {
                printf("tie between candidate %i and %i, at %i votes\n", i, j, preferences[j][i]);
            }
            //if the candidate scored more votes over his rival than the reverse, score him as a "pair" where he defeated his rival.
            if (preferences[i][j] > preferences[j][i])
            {
                printf("%i voters preferred candidate %i over candidate %i, creating pair %i.\n", preferences[i][j], i, j, paircount);

                pairs[paircount].winner = i;
                pairs[paircount].loser = j;

                printf("New pair: winner %i. loser %i.\n", pairs[paircount].winner, pairs[paircount].loser);
                paircount++;
            }
        }
    }
    //update the global pair count with the new value.
    pair_count = paircount;
    return;
}

// Sort pairs in decreasing order by strength of victory
void sort_pairs(void)
{
    printf("\nStarting Bubble Sort\n");
    //Just initialising the search. Do the following until you had an entire run without any changes being made.
    int change = 0;
    do
    {
        //Start the search from the "far left", set changes made to zero and store the number of votes from the first pair. This search will run by moving small victories right and snapping larger victories left
        printf("Making a pass.\n");
        change = 0;
        int lp = 0;
        int place = 0;
        int lpc = preferences[(pairs[lp].winner)][(pairs[lp].loser)];
        printf("The lowest preference count I'm storing is %i, carried by the %i th pair\n I will swap this with anything higher I encounter.\n",
               lpc, lp);
            
        printf("This pair represents candidate %s's victory over %s with %i votes\n", candidates[pairs[lp].winner],
               candidates[pairs[lp].loser], preferences[(pairs[lp].winner)][(pairs[lp].loser)]);
            
        //While you are not looking at an empty pair, do the following (this should be optimised.)
        do
        {
            //check the "victory strength" at each pair from "left to right"
            
            printf("checking the next place\n");
            printf("The lowest preference count I'm storing is %i, carried by the %i th pair\n", lpc, lp);
            printf("This pair represents candidate %s's victory over %s with %i votes\n", candidates[pairs[lp].winner],
                   candidates[pairs[lp].loser], preferences[(pairs[lp].winner)][(pairs[lp].loser)]);
                
            //hpc is the value fo that strength, compared to lpc the "stored value" from the lowest pair strength found so far.
            int hpc = preferences[(pairs[place].winner)][(pairs[place].loser)];

            printf("Comparing this to the %i th pair\n", place);
            printf("This pair represents candidate %s's victory over %s with %i votes\n", candidates[pairs[place].winner],
                   candidates[pairs[place].loser], hpc);
                
            //If you have found a victory that is stronger than the victory you are holding, you need to swap the two.
            if (hpc > lpc)
            {
                printf("These need to be swapped\n");
                printf("storing temporary variables for swamp %s was the winner, %s was the loser, the point value was %i.\n",
                       candidates[pairs[place].winner], candidates[pairs[place].loser], hpc);
                
                //Create a temporary variable set to hold the lower values during the swap so you don't lose them.
                
                int tempw = pairs[lp].winner;
                int templ = pairs[lp].loser;

                //replace the lower value space with the higher values.

                pairs[lp].winner = pairs[place].winner;
                pairs[lp].loser = pairs[place].loser;
                
                //replace the higher value space with the stored lower values.
                
                pairs[place].winner = tempw;
                pairs[place].loser = templ;

                //State that your low value is now in its new spot for any further changes down the line.

                lp = place;

                printf("transfer complete.\n");
                printf("The original placement preference count I changed is now %i, carried by the %i th pair\n", lpc, lp);

                printf("I also changed the %i th pair\n", place);
                printf("This pair now represents candidate %s's victory over %s with %i votes\n", candidates[pairs[place].winner],
                       candidates[pairs[place].loser], preferences[(pairs[place].winner)][(pairs[place].loser)]);
                
                //You've made a change, so there will need to be another sort after this one to check if finished.

                change++;

            }
            else
            {
                //If there hasn't been a swap then the value you found was either smaller than or equal to your previously held value. Drop that value and hold this one instead.
                lp = place;
                lpc = preferences[(pairs[lp].winner)][(pairs[lp].loser)];
            }
            //look one pair to the right and look again.
            place++;
        }
        while (preferences[(pairs[(place)].winner)][(pairs[(place)].loser)] != 0);
        printf("Finished pass, changes made %i \n", change);

    }
    while (change != 0);
    printf("Finished pass, no changes made. Sorted.\n \n");
    return;
}

// Lock pairs into the candidate graph in order, without creating cycles
void lock_pairs(void)
{
    printf("\nLocking in candidates\n\n");
    //For each pair (starting with the strongest since we sorted) do the following.
    for (int i = 0; i < pair_count; i++)
    {
        printf("Looking at the %i th pair.\n", i);
        printf("This pair represents candidate %s's victory over %s with %i votes\n", candidates[pairs[i].winner],
               candidates[pairs[i].loser], preferences[(pairs[i].winner)][(pairs[i].loser)]);
        printf("Checking locks\n");
        //store variables for the winner and loser of the pair to make things easier.
        int winner = pairs[i].winner;
        int loser = pairs[i].loser;
        
        // win(x,y) is a recursive function created to check whether it locking in that pair (adding an arrow on the graph) would create a loop. If it returns true then it didn't detect a loop and you can lock in safely.
        
        if (win(winner, loser) == true)
        {
            printf("Locking in pair %i\n", i);
            locked[pairs[i].winner][pairs[i].loser] = true;
        }
        else
        {
            printf("Not locking pair %i\n", i);
        }
    }
    return;
}

// Print the winner of the election
void print_winner(void)
{
    printf("checking for winners\n");
    //For each candidate
    for (int i = 0; i < candidate_count; i++)
    {
        int defeated = 0;
        //Check to see if any other candidate defeated them in a pair that was locked in.
        for (int j = 0; j < candidate_count; j++)
        {
            if (locked[j][i] == true)
            {
                //If so then add to "defeated".
                /*printf("%s was defeated by %s.\n", candidates[i], candidates[j]);*/
                defeated++;
            }

        }
        //If they weren't defeated then they were the winner of the election.
        if (defeated == 0)
        {
            /*printf("\n\n%s went undefeated and is a winner!\n\n", candidates[i]);*/
            printf("%s\n", candidates[i]);


            //These final lines just print out the final "scores" so I could understand what had happened during the tally.


            for (int f = 0; f < (pair_count); f++)
            {
                /* printf("pair %i = %s over %s by %i\n", f, candidates[pairs[f].winner], candidates[pairs[f].loser], preferences[pairs[f].winner][pairs[f].loser]);*/
            }

        }
        else
        {
            /*printf("%s was defeated by %i opponents\n", candidates[i], defeated);*/
        }
    }
}

//check recursively if you can get through the initial "winner" through any path of "losers" and return to the winner. If so then there is a loop. We can be sure that there are no infinite loops for this function to get trapped in because we will police every single lockin.
bool win(int winner, int loser)
{
    //For the loser, check each candidate.
    for (int i = 0; i < candidate_count; i++)
    {
        //If the loser defeated that candidate.
        if (locked[loser][i] == true)
        {
            //If the defeated candidate was the winner then we have detected a loop.
            if (i == winner)
            {
                printf("closed loop detected\n");
                return false;
            }
            // Otherwise they defeated someone else, and we need to check the paths from this new loser and see if we can return to the original winner.
            else
            {
                //So do this all again with i as the new loser but keeping the original winner.
                return win(winner, i);
            }
        }
    }
    //If you don't find anything then you are okay to lock it in.
    printf("no loop detected\n");
    return true;
}