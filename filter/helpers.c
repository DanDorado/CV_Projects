#include "helpers.h"
#include <math.h>

// Convert image to grayscale
void grayscale(int height, int width, RGBTRIPLE image[height][width])
{
    //For each row
    for (int i = 0; i < height; i++)
    {
        //For each pixel
        for (int j = 0; j < width; j++)
        {
            //Get the values for the pixels colours.
            float red = image[i][j].rgbtRed;
            float blue = image[i][j].rgbtBlue;
            float green = image[i][j].rgbtGreen;
            //Get the average
            int greyscale = roundf((red + blue + green) / 3);
            //And replace all colours with the average.
            image[i][j].rgbtRed = greyscale;
            image[i][j].rgbtBlue = greyscale;
            image[i][j].rgbtGreen = greyscale;
        }
    }
    return;
}

// Reflect image horizontally
void reflect(int height, int width, RGBTRIPLE image[height][width])
{
    //For each row.
    for (int i = 0; i < height; i++)
    {
        //For each pixel before halfway through the row.
        int j = 0;
        do
        {
            //Store temporary colours of its refkected pixel
            int tred = image[i][width - (j + 1)].rgbtRed;
            int tgreen = image[i][width - (j + 1)].rgbtGreen;
            int tblue = image[i][width - (j + 1)].rgbtBlue;

            //Overwrite the reflected pixel with this pixel.
            image[i][width - (j + 1)].rgbtRed = image[i][j].rgbtRed;
            image[i][width - (j + 1)].rgbtBlue = image[i][j].rgbtBlue;
            image[i][width - (j + 1)].rgbtGreen = image[i][j].rgbtGreen;

            //Overwrite this pixel with the temporary pixel.
            image[i][j].rgbtRed = tred;
            image[i][j].rgbtBlue = tblue;
            image[i][j].rgbtGreen = tgreen;
            j++;
        }
        while (j < (width - j));
    }
    return;
}

// Blur image
void blur(int height, int width, RGBTRIPLE image[height][width])
{
    //Make a copy of the image
    RGBTRIPLE oimage[height][width];

    //For each row
    for (int i = 0; i < height; i++)
    {
        //For each pixel
        for (int j = 0; j < width; j++)
        {
            oimage[i][j].rgbtRed = image[i][j].rgbtRed;
            oimage[i][j].rgbtBlue = image[i][j].rgbtBlue;
            oimage[i][j].rgbtGreen = image[i][j].rgbtGreen;
        }
    }

    //For each row
    for (int i = 0; i < height; i++)
    {
        //For each pixel
        for (int j = 0; j < width; j++)
        {
            //Check each pixel from topleft to bottomright. If it is "inbounds" then count it and add the colour values to "thepot"
            int inbounds = 0;
            float redpot = 0;
            float bluepot = 0;
            float greenpot = 0;
            //Check a 3x3 box centred on current;
            for (int k = -1; k < 2; k++)
            {
                for (int m = -1; m < 2; m++)
                {
                    if ((i + k < height) && (i + k > -1) && (j + m < width) && (j + m > -1))
                    {
                        inbounds++;
                        redpot += oimage[(i + k)][(j + m)].rgbtRed;
                        bluepot += oimage[(i + k)][(j + m)].rgbtBlue;
                        greenpot += oimage[(i + k)][(j + m)].rgbtGreen;
                    }
                }
            }

            //Once all neighbors checked divide each colour in "thepot" by "inbounds" and set the pixel to that value.

            image[i][j].rgbtRed = roundf(redpot / inbounds);
            image[i][j].rgbtBlue = roundf(bluepot / inbounds);
            image[i][j].rgbtGreen = roundf(greenpot / inbounds);
        }
    }
    return;
}

// Detect edges
void edges(int height, int width, RGBTRIPLE image[height][width])
{
    
    //Make a copy of the image
    RGBTRIPLE oimage[height][width];

    //For each row
    for (int i = 0; i < height; i++)
    {
        //For each pixel
        for (int j = 0; j < width; j++)
        {
            oimage[i][j].rgbtRed = image[i][j].rgbtRed;
            oimage[i][j].rgbtBlue = image[i][j].rgbtBlue;
            oimage[i][j].rgbtGreen = image[i][j].rgbtGreen;
        }
    }

    //For each row
    for (int i = 0; i < height; i++)
    {
        //For each pixel
        for (int j = 0; j < width; j++)
        {
            //Check each pixel from topleft to bottomright. If it is "inbounds" then count it and add the colour values to "thepot" multiplied by the Sobel operator
            double gxredpot = 0;
            double gxbluepot = 0;
            double gxgreenpot = 0;
            double gyredpot = 0;
            double gybluepot = 0;
            double gygreenpot = 0;
            //Check a 3x3 box centred on current pixel, use a formula to generate correct Sobel, and multiply the colour of the pixel by the sobel operator. If null then black.
            for (int k = -1; k < 2; k++)
            {
                for (int m = -1; m < 2; m++)
                {
                    if ((i + k < height) && (i + k > -1) && (j + m < width) && (j + m > -1))
                    {
                        gxredpot += (oimage[(i + k)][(j + m)].rgbtRed * (m * (2 - (k * k))));
                        gxbluepot += (oimage[(i + k)][(j + m)].rgbtBlue * (m * (2 - (k * k))));
                        gxgreenpot += (oimage[(i + k)][(j + m)].rgbtGreen * (m * (2 - (k * k))));
                        gyredpot += (oimage[(i + k)][(j + m)].rgbtRed * (k * (2 - (m * m))));
                        gybluepot += (oimage[(i + k)][(j + m)].rgbtBlue * (k * (2 - (m * m))));
                        gygreenpot += (oimage[(i + k)][(j + m)].rgbtGreen * (k * (2 - (m * m))));
                    }
                    else
                    {
                        gxredpot += 0 * (m * (2 - (k * k)));
                        gxbluepot += 0 * (m * (2 - (k * k)));
                        gxgreenpot += 0 * (m * (2 - (k * k)));
                        gyredpot += 0 * (k * (2 - (m * m)));
                        gybluepot += 0 * (k * (2 - (m * m)));
                        gygreenpot += 0 * (k * (2 - (m * m)));
                    }
                }
            }

            //Once all neighbors added to the gx and gy value, get the final value for that colour. If thats bigger than 255, use 255 instead.

            double fred = sqrt((gxredpot * gxredpot) + (gyredpot * gyredpot));
            if (fred > 255)
            {
                image[i][j].rgbtRed = 255;
            }
            else
            {
                image[i][j].rgbtRed = round(fred);
            }
            
            double fblue = sqrt((gxbluepot * gxbluepot) + (gybluepot * gybluepot));
            if (fblue > 255)
            {
                image[i][j].rgbtBlue = 255;
            }
            else
            {
                image[i][j].rgbtBlue = round(fblue);
            }
            
            double fgreen = sqrt((gxgreenpot * gxgreenpot) + (gygreenpot * gygreenpot));
            if (fgreen > 255)
            {
                image[i][j].rgbtGreen = 255;
            }
            else
            {
                image[i][j].rgbtGreen = round(fgreen);
            }
            
            
        }
    }
    return;
}