* I have used Test Driven Development (TDD) approach.

The folder structure of this hackathon is as follows:
1. my_onebus.rb - It is main file with .find function and which call Crawler and Parser Modules.
2. onebus/my_crawler.rb - This is the main crawler website function.
3. onebus/my_data_parser.rb - This is the main parser module for the data module which we get from crawler.
4. spec - This folder contains test cases for different scenario. 

Challenges:

1. This is not a generic crawling tast. Hence, main challenge comes in form of crawling where cookies and user defined token values are required to pass to json header in order to get sucessful query of data. 

2. Query engine of the webpage is based on Ajax so it is not possible to parse web page as such which is the case of general web crawling cases.

3. It's hackathon work and hence, being a python evangelist, it made it more challenging as I need to learn Ruby on the go and challenges that I faced were completely new to me and which made this more interesting and fun hack.


