//Abstraciton
#include <cs50.h>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

// Checks to see if exacntly one string was entered as a commandline argument and inputs it as the key, k.
int main(int argc, char *argv[])
{

    if (argc != 2)
    {
        printf("Usage: ./caesar integer\n");
        return 1;
    }
    
    //Checks to see if all characters of argv[1] are digits.
    int checkdigit = 0;
    string checkinput = argv[1];
    do
    {
        printf("checking %i\n", checkdigit);
        if (isdigit(checkinput[checkdigit]) == 0)
        {
            printf("Usage: ./caesar integer\n");
            return 1;
        }
        checkdigit++;
    }
    while (checkinput[checkdigit] != 0);
    
    
    string a = ("ABCDEFGHIJKLMNOPQRSTUVWXYZ");
    int k = atoi(argv[1]);
    
    

    //Prompts user for a message to encode stores it as string "pt"
    string pt = get_string("plaintext: ");


    // Takes "pt" and the character to be encoded, finds their combined value above "a", and uses a modulus function to determine the final placment, rolling over if its too high.
    int n = 0;
    do
    {
        int c = (pt[n] - 1);
 
        if ((c > 95) && (c < 122))
        {
            pt[n] = (97 + (((c - 96) + k) % 26));
        }
        else if ((c > 63) && (c < 90))
        {
            pt[n] = (65 + (((c - 64) + k) % 26));
        }
        n++;
    }
    while (pt[n] != 0);
    
    
    //Prints the final encoded message.
    printf("ciphertext: %s\n", pt);
    return 0;
}