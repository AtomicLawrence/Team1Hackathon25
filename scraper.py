from bs4 import BeautifulSoup

baseUrl = "https://www.bbc.co.uk/"


if '__name__' == '__main__':
    with open(baseUrl) as fp:
        soup = BeautifulSoup(fp)

        print(soup.contents)