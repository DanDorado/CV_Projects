# Get the ability to use argv
import sys
# Get the ability to look at comma seperated variables
import csv

# Abort if the user didnt provide two files to read
if len(sys.argv) != 3:
    print('Usage: python dna.py data.csv sequence.txt')
    sys.exit()

# Abort if either of theose files were not the correct type
arg1 = sys.argv[1]
arg2 = sys.argv[2]
if arg2.count('.txt') != 1:
    print('Usage: python dna.py data.csv sequence.txt')
    sys.exit()
if arg1.count('.csv') != 1:
    print('Usage: python dna.py data.csv sequence.txt')
    sys.exit()

# DNAh is a list of the DNA sequences we want to search for
with open(arg1) as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    DNAh = next(csv_reader)
    # DNA a list of lists, [x][y] one list per person we will look for, the 'y' list corresponds
    # to the DNAh value fo a sequence, with [x][0] linking to their name.
    # col stores the column number, line_count the row number.
    DNA = []
    col = len(DNAh)
    line_count = 0
    for row in csv_reader:
        DNA.append(row)
        line_count += 1


# Now open the .txt to check against
txt = open(arg2, "r")
compseq = txt.read()
# Over the .txt file search for each of the sequences stored in DNAh
for i, sequence in enumerate(DNAh):
    searchseq = (DNAh[i])
    # lenseq is the number of nucleotides in the sequence, we will jump forward this much every
    # time a match is found to avoid ATAT being found in ATATAT twice.
    # conscu is the current length of consequetive sequences, it overwrites conshi, the highest total value, whenever it surpasses it.
    lenseq = len(searchseq)
    iter = 0 - lenseq
    conscu = 0
    conshi = 0
    count = compseq.count(searchseq)
    # Check how many times the sequence exists in the DNA, while you are looking, use a temporary variable to see if the current value is one sequence away from the previous value, if so then you are building a consequetive sequence.
    for j in range(count):
        checkcons = iter
        iter = compseq.index(searchseq, iter + lenseq)
        if checkcons == iter - lenseq:
            conscu += 1
            if conscu > conshi:
                conshi = conscu
        else:
            conscu = 1
    if conshi == 0 and range(count) != 0:
        conshi = 1
    # Override all names which didn't get a match
    for k in range(line_count):
        if i is not 0:
            if int(DNA[k][i]) is not conshi:
                DNA[k][0] = ('fake')
# If any names are left, they are matches, if none are left then there were no matches.
result = 0
for p in range(line_count):
    if DNA[p][0] is not 'fake':
        print(DNA[p][0])
        result = 1
if result is 0:
    print('No match\n')
