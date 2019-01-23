# Workflow
1. Reading your data
2. Take a peek at your data
3. Inspect your structure of data
4. Formulate questions (strategic business value)
5. Answer questions efficiently

```r
# make sure file is in the directory (getwd)
bank <- read.csv("https://algorit.ma/financials/july/loan.csv", 
	header=FALSE, 
	stringsAsFactor=FALSE)

# pre-processing
bank$loanDate <- as.Date(bank$loanDate, format="%d/%m/%y")
bank$applicantname <- as.character(bank$applicantname)

# get a sense of the data
nrow(bank)
ncol(bank)
dim(bank)
head(bank)
tail(bank)
summary(bank)
str(bank)
```

1. Between the NPL (non-performing loans), which type of loans cost us the most?
2. Between individuals taking a loan for housing / renovation and taking a loan to start a business, which one defaulted more?
3. Among customers who take a loan for education purposes, how many of them defaulted on the loan?
...
5. Among all 4 quarters, which is our best performing month?

```r
# one-dimensional table
table(x)

# two-dimensional table with names
table("Shipment Method"=retail$Ship.Mode, 
      "Customer Type"=retail$Segment)

# get proportion instead
prop.table(table(bank$purpose))

# Subsetting
bank[bank$default == TRUE, ]
bank[bank$purpose == "education" | bank$purpose == "car", ]
bank[bank$loanamount > 50000000 & bank$default == TRUE, ]
```





