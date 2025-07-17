from bs4 import BeautifulSoup
import requests
from playwright.sync_api import sync_playwright
import tldextract
from pathlib import Path


DIRECTORY_ROOT= "page_data"


def get_folder_path(url: str) -> str:
    return f"{DIRECTORY_ROOT}/{tldextract.extract(url).domain}"

def save_page_data_to_folder(url: str) -> None:
    file_directory_base = get_folder_path(url)
    Path(file_directory_base).mkdir(parents=True, exist_ok=True)
    scrape_page(url, file_directory_base)
    with sync_playwright() as playwright:
        take_screenshot(playwright, url, file_directory_base)


def take_screenshot(playwright, url: str, file_directory_base: str) -> None:
    browser = playwright.chromium.launch()
    page = browser.new_page()
    page.goto(url)
    page.screenshot(path=f"{file_directory_base}/screenshot.png", full_page=True)
    browser.close()

def scrape_page(url: str, file_directory_base: str) -> None:
    response = requests.get(url)
    html_content = response.text

    soup = BeautifulSoup(html_content, 'html.parser')

    html = get_html(soup)
    with open(f"{file_directory_base}/html.txt", "w") as text_file:
        text_file.write(html)


def get_html(soup: BeautifulSoup) -> str:
    return soup.prettify()


# def get_css(soup: BeautifulSoup) -> list[str]:
#     css_files = []
#     for css in soup.find_all("link"):
#         if css.attrs.get("href"):
#             css_url = urljoin(URL, css.attrs.get("href"))
#             css_files.append(css_url)
#     print(css_files)
#     return css_files


if __name__ == '__main__':
    save_page_data_to_folder("https://www.bbc.co.uk")