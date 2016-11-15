%title: Web Scraping and Pattern Matching
%author: Adam Gross
%date: 2016-11-15

-> Outline <-








> What is web scraping and why is it useful?<
>> Libraries to help you web scrape
>>> What is pattern matching and why is it useful?
>>>> Intro to regexes
>>>>> How regexes can help you web scrape


-------------------------------------------------

-> What is web scraping and why is it useful? <-








Every piece of information you could ever want is online somewhere. Some information is available via free APIs, some via paid APIs, and the rest is out there and not necessarily made nicely available to you. 

* APIs
If the information you are looking for is available from an accessible API, use it.

* Web Scraping
Otherwise, you can pull the raw HTML from any web page and parse it for the information you need.

-------------------------------------------------

-> HTML <-

You can use command line tools like cURL to retrieve the raw HTML of a web page:

    ubuntu@ip-172-31-60-0 ~ $ curl http://americanhistory.si.edu/presidency/5d1.html
    <HTML>
    <HEAD>
    <TITLE>The American Presidency</TITLE>
    <STYLE>
    A{text-decoration:none}
    </STYLE>
    <TD ALIGN="left" VALIGN="top">
    <!--text-->
    <TABLE BORDER=0 CELLPADDING=10 CELLSPACING=0 WIDTH=600>
    <TR>
    <TD ALIGN="left" VALIGN="top"><FONT FACE="arial,verdana,helvetica" SIZE=2><B>LIST OF THE PRESIDENTS</B><BR><BR>
    View list:  <A HREF="#chron">chronologically</A> or <A HREF="#alph">alphabetically</A><BR>
    <P><B><A NAME="chron">CHRONOLOGICAL</A></B>
            <P>George Washington&nbsp;&nbsp;&nbsp;(1789-1797)<BR>
            John Adams&nbsp;&nbsp;&nbsp;(1797-1801)<BR>
            Thomas Jefferson&nbsp;&nbsp;&nbsp;(1801-1817)<BR>
            James Madison&nbsp;&nbsp;&nbsp;(1809-1817)<BR>
            James Monroe&nbsp;&nbsp;&nbsp;(1817-1825)<BR>
                            .
                            .
                            .
                           etc

-------------------------------------------------

-> Off the Command Line <-

Most languages have libraries for this as well:
-> Java: <-
    
    1   URL u = new URL("http://www.google.com/");
    2   BufferedReader in = new BufferedReader(new InputStreamReader(u.openStream()));
    4 
    5   String inputLine;
    6   while ((inputLine = in.readLine()) != null)
    7       System.out.println(inputLine);
    8   in.close();

-> or with the [Jsoup](https://jsoup.org) library: <-
    
    1   String html = Jsoup.connect("http://americanhistory.si.edu/presidency/5d1.html").get().html();

-> Python: <-
    
    1   import urllib
    2   url = 'http://americanhistory.si.edu/presidency/5d1.html'
    3   html = urllib.urlopen(url)
    4   print html.read()

-------------------------------------------------

-> BeautifulSoup <-

[BeautifulSoup](https://www.crummy.com/software/BeautifulSoup/) is a python library that makes parsing of this HTML really easy.
You can extract elements of the HTML tree by type, class, and other custom-defined criteria. For example:
    
    1   import BeautifulSoup
    2   import urllib
    3   url = 'http://www.presidentsusa.net/presvplist.html'
    4   soup = (BeautifulSoup.BeautifulSoup(urllib.urlopen(url)))
    5   html = str(soup)
    6   td_list = soup.findAll('td')
    7   for item in td_list:
    8       print item

outputs
    
    ubuntu@ip-172-31-60-0 ~ $ python get_presidents.py
    <td>1. <a href="washington.html">George Washington (1789-1797)</a></td>
    <td><a href="jadams.html">John Adams (1789-1797)</a></td>
    <td>2. <a href="jadams.html">John Adams (1797-1801)</a></td>
    <td><a href="jefferson.html">Thomas Jefferson (1797-1801)</a></td>
                            .
                            .
                            etc

------------------------------------------------------------------

-> Potential Sources of Issues <-











> Keep your rate of access low
>> Watch out for HTTP authentication
>>> *Watch out for bot denial of service*

-------------------------------------------------

-> Pattern Matching and Regular Expressions <-

Recall

    
    <td>1. <a href="washington.html">George Washington (1789-1797)</a></td>
    <td><a href="jadams.html">John Adams (1789-1797)</a></td>
    <td>2. <a href="jadams.html">John Adams (1797-1801)</a></td>
    <td><a href="jefferson.html">Thomas Jefferson (1797-1801)</a></td>
    <td>3. <a href="jefferson.html">Thomas Jefferson (1801-1809)</a></td>
    <td><a href="jefferson.html">Aaron Burr (1801-1805)</a><br />
    <a href="jefferson.html">George Clinton (1805-1809)</a></td>
                            .
                            .
                            etc

* There is clearly a pattern to the format of each entry
* RegExes provide a formal language for expressing these patterns
* Libraries exist to use regExes for pattern matching and extracting target information from patterns

*_HTML:_*

<td>1. <a href="washington.html">George Washington (1789-1797)</a></td>

*_RegEx pattern:_*

<td>([0-9]*)\. <a href="[a-z\.]*">([\w ]*) \(([0-9]*)-([0-9]*)\)</a></td>


-------------------------------------------------

-> Putting it All Together <-

* urllib.urlopen gives us the HTML

* BeautifulSoup.BeautifulSoup objects allow us to extract desired parts of the HTML

* RegExes allow us to express a pattern or format that each entry we extracted follows
    
    * allows us to pull out characters at specific locations in the pattern

So with this we can print out, in order, each president's name and term:

    
    import BeautifulSoup
    import urllib
    import re
    
    url = 'http://www.presidentsusa.net/presvplist.html'
    soup = BeautifulSoup.BeautifulSoup(urllib.urlopen(url))
    td_list = [str(x) for x in soup.findAll('td')]
    matcher = re.compile('<td>([0-9]*)\. <a href="[a-z\.]*">([\w \.]*) \(([0-9]*)-?([0-9a-z]*)?\).*')
    for td in td_list:
        matches = matcher.match(td)
        if matches:
            num_pres, name, begin, end = matches.groups()
            print '#{}: {}, {}-{}'.format(num_pres, name, begin, end)
    

------------------------------------------------------

-> Output <-





    ubuntu@ip-172-31-60-0 ~ $ python get_presidents.py
    #1: George Washington, 1789-1797
    #2: John Adams, 1797-1801
    #3: Thomas Jefferson, 1801-1809
    #4: James Madison, 1809-1817
    #5: James Monroe, 1817-1825
    #6: John Quincy Adams, 1825-1829
    #7: Andrew Jackson, 1829-1837
    #8: Martin Van Buren, 1837-1841
    #9: William Henry Harrison, 1841-
    #10: John Tyler, 1841-1845
    #11: James K. Polk, 1845-1849
    #12: Zachary Taylor, 1849-1850
    #13: Millard Fillmore, 1850-1853
    #14: Franklin Pierce, 1853-1857
    #15: James Buchanan, 1857-1861
    #16: Abraham Lincoln, 1861-1865
    ......etc

---------------------------------------------------

-> Resources <-





* If you want to recap this presentation, slides/markdown will be available on [our GitHub](https://github.com/vandyapps/)

* For an intro to regExes, check out the documentation for your favorite language

    * general and language specific regEx tutorials can be found in the documentation
    
    * or check out [Codular](http://codular.com/regex) 
    
    * or [DigitalOcean's tutorial](https://www.digitalocean.com/community/tutorials/an-introduction-to-regular-expressions)


-> Thanks! <-
