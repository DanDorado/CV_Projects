A .py programme to quickly find matches between people and DNA sequences by specifically searching for "LTR's", sequences of nucleotides which consecutively repeat.

Takes in two arguments that must be .txt files. Both files will be sequences of nucleotides (ATCG). The first will be have a list of specific 'LTR sequences' to look in the first row. The following rows will be csv's which show names of individuals on file followed by the amount of times that the 'marker' LTR's are found in that individual, formatted as below.

name,AGAT,AATG,TATC

Alice,28,42,14

Bob,17,22,19

Charlie,36,18,25

The second argument will be for a file which contains a full DNA sequence. The programme will search this DNA sequence looking for repeating nucleotides which match each 'marker'. The longest consequetive sequences of 'markers' are stored, and checked against the individuals in the first file.

If an exact DNA match with the sample is found then the name of the individual is printed, if no exact match is found then "No match" is returned.
