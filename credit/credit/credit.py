# Get the get_int function
from cs50 import get_string

# Get a number from the user.
cn = get_string("Number:  ")
total = 0
place = 0
# Run a check on the number format, for each number from the right side(we use i to count, it doesn't matter from left or right):
# If it is even then add it to the total
# If it is odd then double it and add the total digits to the total.
for i in range(len(cn)):
    place = len(cn) - i - 1
    if (i + 1) % 2 is 1:
        total += (int(cn[place]))
    else:
        total += (int(cn[place]) * 2 // 10) + (int(cn[place]) * 2 % 10)
# If total is a multiple of 10 then the card can be valid.
if total % 10 is not 0:
    print("INVALID")
# Check for the correct card number length and starting digits of the main credit card companies.
elif (len(cn) is 15) and (int(cn[0]) is 3) and (int(cn[1]) in (4, 7)):
    print("AMEX")
elif (len(cn) is 16) and (int(cn[0]) is 5) and (0 < int(cn[1]) < 6):
    print("MASTERCARD")
elif (len(cn) in (13, 16)) and (int(cn[0]) is 4):
    print("VISA")
# Otherwise print invalid anyway.
else:
    print("INVALID")