# Programming for Data Science
## Setup

- [ ] Installation of R
- [ ] Installation of RStudio
- [ ] Connect to WiFi
- [ ] Download all materials for this workshop (Programming for Data Science)

We'll start at **6.30pm**, and we have a break at 7.41pm - 7.50pm

mentor@algorit.ma

## Summary
1. R is case-sensitive
2. Integer, Numeric, Character, Logical, Complex
3. A vector has to contain objects of the same class

Examples:
```r
brand <- "algoritma"
brand == "Algoritma"
# print FALSE

print(BraNd)
# error: BraNd not found

# to check the class:
class(brand)
```

4. Think of a Data Frame as a List of lists. An excel file that has 11 columns will effectively a list of 11 smaller list. Because of this, columns in a data frame can have their own respective classes

### Worflow
1. Read your data in
- R can work in data of any kind
    - xls, xlsx
    - csv
    - json
    - api
    - xml
    - apache hive
    - spark
    - oracle
    - mysql
    - readLines

2. Take a peek at your data
    - `head(insurance)` will print the first 6 rows
    - `tail(insurance, 7)` will print the last 7 rows

3. Understand the structure of your data
    - `str(insurance)` prints the structure of the data
    - `summary(insurance)` will print out the table for each column, or numerical summary

```r
insurance <- read.csv("my_insurance_q42018.csv")

```














## Additional References
https://peerj.com/preprints/3182.pdf
https://google.github.io/styleguide/Rguide.xml


