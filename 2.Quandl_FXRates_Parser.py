#!/usr/bin/env python
# -*- coding: utf-8 -*-

### FINAL PARSER for QUANDL FX RATES ###

import xml.etree.cElementTree as ET
import StringIO
import re
import codecs
import csv
import cProfile

# variable import file from working directory
filename = "Quandl_XML_raw_FXRates.xml"

# string variables for file positioning
newdoc = '<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n'         # new XML doc marker
ignoreline = "http://www.quandl.com/api/v1/datasets/CURRFX/"    # text descriptor of rates
badsite = '"<!DOCTYPE html PUBLIC'                              # bad response from API


# variables for regex patterns
crap = re.compile(r'(^\"|\"$|>$|\\\\|\\n|\n|\\|\\r|\t)')
isDate = re.compile(r'[1-2][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]')


# function to extract FX rate and date specifically
def FXextractor(element):

    daterate = []
     
    #create iterator over child element
    for child in element.iter():

        for tag in child:
            
            #ignore None element types
            if tag.text == None:
                pass
            
            #identify FX rate component
            elif tag.text.replace(".","").isdigit() == True:
                daterate.append(float(tag.text))
            
            #identify date component
            elif isDate.search(tag.text).group().startswith('2') == True:
                daterate.append(tag.text)
             
            else:
                pass
                    

    return daterate if len(daterate) > 0 else None



# function to call FX rate + date function and add currency tag
def shape_element(element):
    
    fxrates = {}
     
    #ignore empty elements
    if element.tag == None:
        pass
    
    #call to function to extract the rate + date components from the 'datum' element
    elif element.tag == 'datum':
        if FXextractor(element) == None:
            pass
        else:
            fxrates['values'] = FXextractor(element)
    
    #extract the currency
    elif element.tag == 'code':
        if element.text == None:
            pass
        else:
            fxrates['currency'] = element.text[3:]
    
    else:
        pass

    return fxrates if len(fxrates) > 0 else None
 

    
#file writer
def filewriter(data):
    with open("FXRates_clean.txt", "w") as f1:
        goodFX = csv.writer(f1, lineterminator='\n', quotechar='"')
        
        for row in data:
            goodFX.writerow(row)
            
    return goodFX  
    
 
    
# function to write constructed list of dicts to file - MongoDB import ready
def process_map(filename):

    data = []
    with codecs.open(filename, 'r', encoding="utf-8") as f:
        doc = f.readlines()
        
        #strip leading white space from lines
        doc1 = [elem.strip() for elem in doc]
        
        #loop through lines
        for elem in doc1:

            #ignore lines that contain URL
            if elem.startswith(ignoreline) == True or elem.startswith(badsite) == True:   
                pass
            
            #assumes line is XML                                
            else:
                #use regex to remove non-XML characters
                elem1 = re.sub(crap,"",elem)
                
                #convert string of XML to dummy file - ENCODE as utf-8... some ASCII characters
                elemFile = StringIO.StringIO(elem1.encode('utf-8'))            
                
                #parse converted XML
                for event, element in ET.iterparse(elemFile,events=("start", "end")):
                    
                    #call function to extract rates
                    try:
                        el = shape_element(element)
                        #clear element from memory after processing
                        element.clear()

                    except 'ParseError':
                        print element
                        continue                    
                    
                    if el == None:
                        pass

                    else:
                        data.append(el)

    return data


def final():

    data = process_map(filename)
    
    
    #print currency, date and rate in format required for dataframe
    #uses csv file writer

    with open('FXRATES_clean.csv', 'w') as csvfile:
        writer = csv.writer(csvfile, lineterminator='\n', delimiter=',', quotechar='"')
    
        for k in data:
            for i, j in k.items():
                if i == 'currency':
                    ccy = j
                elif i == 'values':
                    if len(j) <= 1:
                        pass
                    else:
                        newrow = ccy, j[0], j[1]
                        writer.writerow(newrow)

# call functions - includes profiler to see what's taking so long
if __name__ == "__main__":
    cProfile.run('final()')
