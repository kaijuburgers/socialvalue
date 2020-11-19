'''

Uses UKPC module to return the district number for the postcodes

If I had time, I would write a module myself, especially since UKPC seems to validate the incode before the outcode, despite this being unnecessary for producing district information

'''

from ukpc import PostCode
import string

def removespaces(string): 
    return string.replace(" ", "") 

#this is very quick and inelegant, would loop through incodes until I get a hit 
#this incode is only assigned because I couldn't find a module that worked with just outcodes, the incode is just a proxy value
def getarea(pc1):
    pc1 = pc1.upper()
    pc = removespaces(pc1)
    try:
        pc = pc + " 0AA"
        pc = PostCode(pc)
        return pc.area
    except:
        pass


