//Abstraction

#include<stdio.h>
#include<cs50.h>
#include<math.h>


//state global variables for pennies remaining and coins given as change.
int pr = 0;
int cg = 0;

//List functions to be used
void pennies_remaining (int cs);
int coins_used (int cs);
void coins_given(int cs);
void get_change(void);
void print_begin(int pr);
void print_finalchange(int cg);


//Run through functions, get change input from user, then check coins given and pennies remaining for each coin size from biggest to smallest as a greedy algorithm.
int main(void)
{
    get_change();
    
    print_begin(pr);
    
    coins_given (25);
    pennies_remaining (25);
    
    coins_given (10);
    pennies_remaining (10);
    
    coins_given (5);
    pennies_remaining (5);
    
    coins_given (1);
    pennies_remaining (1);
    
    print_finalchange(cg);
    
}


//prompts the user for amount of change needed and converts into pennies as an integer, saves this as the gobal variable pr.
void get_change(void)
{
    float n;
    do
    {
        n = get_float("How much change do you need?\n");
    }
    while (n < 0.001);
    
    pr = round(n*100);
    
}

//Print to user the change that they needed.
void print_begin()
{
    printf("You needed %i pennies in change. \n", pr);
}


// Changes pennies remaing to the Modulus of the remaining pennies against the coin size in pennies.
void pennies_remaining (int cs)
{
    pr = pr % cs;
}


// Keeps track to the coins given in change which happened in the modulus funtion, and prints what happened in each step to the user.
void coins_given(int cs)
{
    
    int cgp = cg;
    cg = cg+floor(pr/cs);
    int cgpf = cg - cgp;
    printf ("You were given %i coins in change of size %i. \n", cgpf, cs);
}


// Prints the final amount of change given to the user.
void print_finalchange()
{
    printf("You were given %i coins total in change. \n", cg);
    printf("%i \n", cg);
}