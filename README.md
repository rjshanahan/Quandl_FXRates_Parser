# Quandl_FXRates_Parser

Python parser to extract historical FX Rates from Quandl (xml) download - batch call for ALL currencies

Ever wanted a list of all historical FX Rates? Quandl in its awesomeness can help (and Wiki Rates).

Anyway my issue is how to consume these once retrieved via the Quandl API. As a lazy person i retrieve all rates in one go. What you're left with is a list of messy XML documents.

Fair warning... I am a programming buffoon... but I've written a Python based parser to tidy things up, with some R based bookends to call and load resulting rates

There are three parts:
1. "1.Quandl_FXRate_Retrieve_from_API.R": this R file creates a list of URLs to call the Quandl API in one batch. It spits out a doc containing the XML documents to your working directory
2. "2.Quandl_FXRates_Parser.py": this Python file parsers the messy file and coughs up a pretty CSV of the currency, date and rate
3. "3.Quandl_FXRate_Load_into_Dataframe.R": this R program loads the CSV into a data frame. It also creates dummy entries for USD for calculation ease

References:
Some info on Quandl API - including how to get your own auth token:
https://www.quandl.com/help/api

Info regarding data:
- All rates are against base USD
- the Quandl Wiki FX database: https://www.quandl.com/data/CURRFX
- Generic info re: the returned rates: This exchange rate shows the value of 1 U.S. Dollar in [your currency]. This exchange rate is an amalgamation of rates from multiple sources.  These include exchanges, brokerages, newspapers and central bank sources. High and Low rates are crudely estimated.

This has been tested reliably with Python 2.7 and 3.4 and R 3.1

I'm sure there are way more efficient ways of doing this... i'm all ears!