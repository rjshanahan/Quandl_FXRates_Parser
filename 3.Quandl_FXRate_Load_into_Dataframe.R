######## R code to import parsed, tidy csv rates after Python parser#########

# load required packages

## build FXRates table from Python parser output
FXRates_ALL <- read.csv('FXRATES_clean.csv',
                        header=F,
                        sep=",",
                        strip.white=T,
                        colClasses=c('character', 'character', 'myValue'),
                        col.names=c('CURRENCY',
                                    'DATE',
                                    'RATE'),
                        stringsAsFactors=F,
                        fill=T)
# check dimensions
dim(FXRates_ALL)

## coerce date into 'date' class from 'chr'
FXRates_ALL$DATE <- as.Date(as.character(FXRates_ALL$DATE), format='%Y-%m-%d')

## the next section is optional - it adds a corresponding dummy rate for USD - making calculations easier
## add dummy USD rates
## define date ranges - these should correspond to your Quandl API call from step 1
start <- as.Date('2012-01-01')
now <- as.Date('2015-03-06')

## length of date ranges
rows.date <- as.integer(now - start)

## create datafram using daterange sequenece
alldates <- data.frame(seq((start), (now),by = 1))

## colnames
colnames(alldates) <- 'DATE'

## add additional columns
alldates$RATE <- 1
alldates$CURRENCY <- 'USD'

## merge USD dummy data frame with main FXRates data frame ('merge' from base package)
FXRates_ALL <- merge(FXRates_ALL,
                     alldates,
                     all = T)

# recheck dimensions
dim(FXRates_ALL)

