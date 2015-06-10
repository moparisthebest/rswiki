import requests, logging
from bs4 import BeautifulSoup
from queue import Queue
from threading import Thread

logging.getLogger("requests").setLevel(logging.WARNING)


def get_pages(page):
    global all_pages
    if page in all_pages:
        return
    all_pages.append(page)
    ebin.write(page + "\n")
    print(page + "\n")
    req = requests.get("https://rswiki.moparisthebest.com/index.php?title=" + page)
    soup = BeautifulSoup(req.text)
    content = soup.find("div", id="mw-content-text")
    links = content.find_all("a")
    for link in links:
        link = link["href"]
        off = link.find("?title=")
        if off is -1:
            continue
        next_page = link[off + 7:]
        if "#" in next_page:
            next_page = next_page[:next_page.find("#")]
        if "&" not in next_page and "Special:" not in next_page and next_page != page:
            get_pages(next_page)


ebin = open("legit_pages.txt", "w")
all_pages = []
pages = get_pages("Main_Page")
