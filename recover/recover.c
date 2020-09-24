#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

//Global variables
typedef uint8_t BYTE;
//Counter is used to check the jpgs that have been finished
int counter = -1;

char filename[3] = {0, 0, 0};

//Open the file inputted by the user, and as long as it exists store it as rec.
int main(int argc, char *argv[])
{
    FILE *rec = fopen(argv[1], "r");
    if (rec == NULL)
    {
        printf("Incorrect File\n");
        return 1;
    }
    
    if (argc != 2)
    {
        printf("usage ./recover xxxx.raw");
        return 1;
    }
    printf("%s\n", argv[1]);

    //Make an array of BYTES ("unsigned integers of size 8") 512 in size called buffer.
    BYTE buffer[512];

    //wri checks whether a jpg is currently being written.
    
    FILE *JPG = NULL;
    do
    {
       
        //Check to see if the bytes read by fread is less than it tries to read. If so then it means you are near the end of the file.
        int stuffleft = fread(buffer, sizeof(BYTE), 512, rec);
        printf("stuff left %i\n", stuffleft);
        if (stuffleft != 512)
        {
            printf("The end is nigh");
            counter = 9999;
        }

        //Check to see if the first three digits of the enw file are 0, indicating the likely start of a blank block.
        
        if (buffer[0] == 0 && buffer[1] == 0 && buffer[3] == 0 && buffer[4] == 0)
        {
            if (counter == -1)
            {
                continue;
                
            }
        }

        //Check to see if the first four bytes match the JPEG header. The third byte is checked to see whether the second unsigned digit was e.
        
        if ((buffer[0] == 0xff) && (buffer[1] == 0xd8) && (buffer[2] == 0xff) && ((buffer[3] & 0xf0) == 0xe0))
        {
            //Start a new jpg file and start writing. this file has a name set by the counter of jpgs completed so far
            counter++;
            sprintf(filename, "%03i.jpg", counter);
            JPG = fopen(filename, "w");
            if (JPG == NULL)
            {
                printf("couldn't write file");
                return 1;
            }
        }
        //if you haven't written anything yet.
        if (counter == -1)
        {
            continue;
        }
        if (stuffleft != 512)
        {
            
            printf("stuff %i\n", stuffleft);
            printf("where's my stuff yo\n");
        }
        //write into the open jpeg all of the read bytes.
        fwrite(buffer, sizeof(BYTE), stuffleft, JPG);
    }
    
    //exit when the counter has reached the end.
    while (counter != 9999);
    printf("I reached the end\n");
    return 0;
}
