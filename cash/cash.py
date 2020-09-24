# Get the get_float function
from cs50 import get_float

# Get input from the user, convert it to pennies.
while True:
    p = get_float("Cash:")
    if p > 0:
        break
p = int(p * 100)

# For each coinsize, give the most possible in coins, using quotients and remainders.
csize = [25, 10, 5, 1]
coin = 0
for i in csize:
    coin += (p // i)
    p = p % i
print(coin)