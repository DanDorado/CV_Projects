//Abstraction

#include<cs50.h>
#include<stdio.h>
#include<math.h>
#include<stdlib.h>

//Lists the functions we will use.
void get_credit(void);
void credit_check(void);
void print_result(void);

long creditno = 0;
int digitcount = 0;


int main(void)
{
    get_credit();
    credit_check();
    print_result();
}

//Prompts user for a credit card number and stores it as cn.
void get_credit(void)
{
    creditno = get_long("What is your credit card number?\n");
}


void credit_check(void)
{
    //Checks the number of digits in the number and store them in an array.
    {
        long d = creditno;

        do
        {
            int fd = (d - ((d / 10) * 10));
            d = d / 10;
            digitcount++;
        }
        while (d > 0);

        int digits[digitcount];

        d = creditno;
        for (int b = 0 ; b < digitcount ; b++)
        {
            int fd = (d - ((d / 10) * 10));
            digits[digitcount - b] = fd;
            d = d / 10;
        }


        //Checks if Luhn's Algorithm returns a valid card.

        {
            int od = 0;
            for (int b = digitcount - 1; b > 0; b = b - 2)
            {
                //Extra line here to add digits of 6*2=12 etc together.
                int dnd = (digits[b] * 2);
                dnd = (floor(dnd / 10)) + dnd - (10 * (floor(dnd / 10)));
                od = od + dnd;
                /*printf("odd digits %i\n", od);*/
            }

            int ed = 0;
            for (int b = digitcount ; b > 0; b = b - 2)
            {
                ed = ed + (digits[b]);
                /*printf("even digits %i\n", ed);*/
            }

            int td = ed + od;
            /*printf("total digits %i\n", td);*/

            int valid = td % 10;
            /*printf("valid card %i\n", valid);*/

            /*if (valid == 0)
            {
                printf("This card is a valid format\n");
            }

            else
            {
                printf("User Error\n");
            }*/


            //Checks that the digit count & starting numbers align with a company.

            if ((valid == 0) && (digitcount == 15) && (digits[1] == 3) && ((digits[2] == 4) || (digits[2] == 7)))
            {
                printf("AMEX\n");
            }
            else

                if ((valid == 0) && ((digitcount == 13) || (digitcount == 16)) && (digits[1] == 4))
                {
                    printf("VISA\n");
                }
                else

                    if ((valid == 0) && (digitcount == 16) && (digits[1] == 5) && ((digits[2] == 1) || (digits[2] == 2) || (digits[2] == 3)
                            || (digits[2] == 4) || (digits[2] == 5)))
                    {
                        printf("MASTERCARD\n");
                    }
                    else

                    {
                        printf("INVALID\n");
                    }
        }
    }

}

//Displays whatever I need displayed.
void print_result(void)
{
    /*    printf("%ld\n", creditno);
    printf("%i\n", digitcount);*/
}