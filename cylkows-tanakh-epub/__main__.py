import hebrew_numbers
import jinja2
import tempfile
import sys
import os
import json
import itertools
from jinja2 import Template

HEBR_SCRIPT_LANGS = ["he", "yi"]


def yiddish_filter(text):
    letters = [
        ["וו", "װ"],
        ["וי", "ױ"],
        ["יי", "ײ"],
        ["ײַ", "ײַ"],
    ]
    for old, new in letters:
        text = text.replace(old, new)
    return text


# Goes through entered list of languages and searches for corresponding files
def iterate_langs(dir_path, lang_list):
    name = os.path.basename(dir_path)
    result = dict()
    for lang in lang_list:
        filename = os.path.join(dir_path, f"{lang}.json")
        with open(filename, "r") as f:
            jdata = json.load(f)
            title = jdata.get("heTitle"), jdata.get("title")
            text = jdata.get("text")
            result[lang] = {"title": title, "dir_name": name, "text": text}
    return result


# Merges selected books to one dictionary
def merge_books(book_dict):
    languages = list(book_dict.keys())
    merged_list = []
    title = list(book_dict.values())[0]["title"]
    name = list(book_dict.values())[0]["dir_name"]

    if languages[0] in HEBR_SCRIPT_LANGS:
        title = title[0]
    else:
        title = title[1]

    z = zip([b["text"] for b in book_dict.values()])
    for book in zip(*z):
        list_chapters = []
        for i, chapter in enumerate(zip(*book), start=1):
            list_verses = []
            for j, verse in enumerate(zip(*chapter), start=1):
                v = {lang: text_edit(lang, text, i, j) for lang, text in zip(languages, verse)}
                list_verses.append((index_transform(languages[0], j), v))
            list_chapters.append((index_transform(languages[0], i, g=True), list_verses))
        merged_list.append(list_chapters)
    return title, languages, merged_list, name


def index_transform(lang, index, g=False):
    if lang in HEBR_SCRIPT_LANGS:
        return hebrew_numbers.int_to_gematria(index, gershayim=g)
    return index


def text_edit(lang, text, chapter=None, verse=None):
    text = text.strip()
    text = yiddish_filter(text)
    return (index_transform(lang, chapter), index_transform(lang, verse)), text


def main(args):
    dir_path = args[1]
    languages = args[2:]

    with tempfile.TemporaryDirectory() as tmpd:
        # tmpd = "./tmp"
        book_dict = iterate_langs(dir_path, languages)
        merged = merge_books(book_dict)
        title = merged[0]
        output_dir = os.environ.get("OUTPUT_DIR") if os.environ.get("OUTPUT_DIR") is not None else "./output"
        html_filename = os.path.join(tmpd, f"book.html")
        epub_filename = os.path.join(output_dir, f"{merged[-1]}_{'-'.join(languages)}.epub")
        css_filename = os.path.join(tmpd, "style_inline.css")

        print(f"Working on title={title} lang={languages}")
        # TODO Jinja template to make HTML file

        is_block = os.environ.get("BLOCK_FORMAT") == "1" if os.environ.get("BLOCK_FORMAT") is not None else False
        if is_block:
            template_name = "template_block.html"
        else:
            template_name = "template_inline.html"

        with open(template_name, "r") as t:
            template = Template(t.read())

            html = template.render(chapters=merged[2][0], title=merged[0], css=css_filename,
            direction= "rtl" if (
                            set(languages) == set(HEBR_SCRIPT_LANGS)) or languages[0] in HEBR_SCRIPT_LANGS else "ltr",
                            main_lang='-'.join(languages)
                        )

            with open(html_filename, "w") as tmpf:
                tmpf.write(html)

        env_vars = {
            "HTML_BOOK_PATH": html_filename,
            "EPUB_BOOK_PATH": epub_filename,
            "CSS_BOOK_PATH": css_filename,
        }

        os.environ.update(env_vars)

        r = os.system("bash make_epub.sh")
        if r != 0:
            print(title, languages[0], "EPUB conversion failed.")
        else:
            print(title, languages[0], "Done.", epub_filename)
        print("")


if __name__ == "__main__":
    main(sys.argv)

