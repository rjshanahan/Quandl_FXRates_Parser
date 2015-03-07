######## R code to retrieve historical rates from QUANDL API and write to file for Python parser #########

# load required packages
library(RCurl)
library(Quandl)


# define variables for API call
quandlURL <- 'http://www.quandl.com/api/v1/datasets/'   # main Quandl URL for API
QA <- Quandl.auth("xxxxxxxxxxxx")               # users need to get their own Auth token from quandl.com
download_type <- 'xml'                                  # doc type - use XML
start <- as.Date('2012-01-31')                          # start date for retrieved FX Rates


# define Quandl databse + table names from where you'll retrieve historical FX rates
ccyextra <- c('CURRFX/USDAUD','CURRFX/USDBRL','CURRFX/USDGBP','CURRFX/USDCAD','CURRFX/USDCNY','CURRFX/USDDKK','CURRFX/USDEUR','CURRFX/USDHKD','CURRFX/USDINR','CURRFX/USDJPY','CURRFX/USDMYR','CURRFX/USDMXN','CURRFX/USDTWD','CURRFX/USDNZD','CURRFX/USDNOK','CURRFX/USDSGD','CURRFX/USDZAR','CURRFX/USDKRW','CURRFX/USDLKR','CURRFX/USDSEK','CURRFX/USDCHF','CURRFX/USDTHB','CURRFX/USDVEF',
              'CURRFX/USDAED', 'CURRFX/USDAFN', 'CURRFX/USDALL', 'CURRFX/USDAMD', 'CURRFX/USDANG', 'CURRFX/USDAOA', 'CURRFX/USDARS', 'CURRFX/USDAWG', 'CURRFX/USDAZN', 'CURRFX/USDBAM', 'CURRFX/USDBBD', 'CURRFX/USDBDT', 'CURRFX/USDBGN', 'CURRFX/USDBHD', 'CURRFX/USDBIF', 'CURRFX/USDBMD', 'CURRFX/USDBND', 'CURRFX/USDBOB', 'CURRFX/USDBOV', 'CURRFX/USDBSD', 'CURRFX/USDBTN', 
              'CURRFX/USDBWP', 'CURRFX/USDBYR', 'CURRFX/USDBZD', 'CURRFX/USDCDF', 'CURRFX/USDCHE', 'CURRFX/USDCHW', 'CURRFX/USDCLF', 'CURRFX/USDCLP', 'CURRFX/USDCNH', 'CURRFX/USDCOP', 'CURRFX/USDCOU', 'CURRFX/USDCRC', 'CURRFX/USDCUC', 'CURRFX/USDCUP', 'CURRFX/USDCVE', 'CURRFX/USDCZK', 'CURRFX/USDDJF', 'CURRFX/USDDOP', 'CURRFX/USDDZD', 'CURRFX/USDEGP', 'CURRFX/USDERN', 
              'CURRFX/USDETB', 'CURRFX/USDFJD', 'CURRFX/USDFKP', 'CURRFX/USDGEL', 'CURRFX/USDGHS', 'CURRFX/USDGIP', 'CURRFX/USDGMD', 'CURRFX/USDGNF', 'CURRFX/USDGTQ', 'CURRFX/USDGYD', 'CURRFX/USDHNL', 'CURRFX/USDHRK', 'CURRFX/USDHTG', 'CURRFX/USDHUF', 'CURRFX/USDIDR', 'CURRFX/USDILS', 'CURRFX/USDIQD', 
              'CURRFX/USDIRR', 'CURRFX/USDISK', 'CURRFX/USDJMD', 'CURRFX/USDJOD', 'CURRFX/USDKES', 'CURRFX/USDKGS', 'CURRFX/USDKHR', 'CURRFX/USDKMF', 'CURRFX/USDKPW', 'CURRFX/USDKWD', 'CURRFX/USDKYD', 'CURRFX/USDKZT', 'CURRFX/USDLAK', 'CURRFX/USDLBP', 'CURRFX/USDLRD', 'CURRFX/USDLSL', 'CURRFX/USDLTL', 'CURRFX/USDLYD', 'CURRFX/USDMAD', 'CURRFX/USDMDL', 'CURRFX/USDMGA', 
              'CURRFX/USDMKD', 'CURRFX/USDMMK', 'CURRFX/USDMNT', 'CURRFX/USDMOP', 'CURRFX/USDMRO', 'CURRFX/USDMUR', 'CURRFX/USDMVR', 'CURRFX/USDMWK', 'CURRFX/USDMXV', 'CURRFX/USDMZN', 'CURRFX/USDNAD', 'CURRFX/USDNGN', 'CURRFX/USDNIO', 'CURRFX/USDNPR', 'CURRFX/USDOMR', 'CURRFX/USDPAB', 'CURRFX/USDPEN', 'CURRFX/USDPGK', 'CURRFX/USDPHP', 'CURRFX/USDPKR', 'CURRFX/USDPLN', 
              'CURRFX/USDPYG', 'CURRFX/USDQAR', 'CURRFX/USDRON', 'CURRFX/USDRSD', 'CURRFX/USDRUB', 'CURRFX/USDRWF', 'CURRFX/USDSAR', 'CURRFX/USDSBD', 'CURRFX/USDSCR', 'CURRFX/USDSDG', 'CURRFX/USDSHP', 'CURRFX/USDSLL', 'CURRFX/USDSOS', 'CURRFX/USDSRD', 'CURRFX/USDSSP', 'CURRFX/USDSTD', 'CURRFX/USDSYP', 'CURRFX/USDSZL', 'CURRFX/USDTJS', 'CURRFX/USDTMT', 'CURRFX/USDTND', 
              'CURRFX/USDTOP', 'CURRFX/USDTRY', 'CURRFX/USDTTD', 'CURRFX/USDTZS', 'CURRFX/USDUAH', 'CURRFX/USDUGX', 'CURRFX/USDUSN', 'CURRFX/USDUSS', 'CURRFX/USDUYI', 'CURRFX/USDUYU', 'CURRFX/USDUZS', 'CURRFX/USDVND', 'CURRFX/USDVUV', 'CURRFX/USDWST', 'CURRFX/USDYER', 'CURRFX/USDZMW', 'CURRFX/USDZWD')


# create list of URLs for batch API call
urllist <- c(lapply(ccyextra, function(x) paste(quandlURL,
                                                x,
                                                '.', 
                                                download_type, 
                                                '?auth_token=',QA,
                                                '&exclude_headers=true&column=1:2&trim_start=',
                                                start,
                                                sep='')))

# call APIs from list and save to list of XML documents
FXRates_WIKI2.xml <- getURI(urllist)

# output list to R working directory
sink('Quandl_XML_raw_FXRates.xml')
FXRates_WIKI2.xml
sink()
