# README.md

```sh
git clone https://github.com/grunwmar/cylkows-tanakh-epub.git
```

Used fonts aren't part of this repository, but you can download them here:
* [Zilla Slab](https://fonts.google.com/specimen/Zilla+Slab?query=zilla)
* [SBL BibLit](https://www.sbl-site.org/educational/BiblicalFonts_SBLBibLit.aspx)

and install them to your system.

To make ebook, run 
```bash
bash ./run.sh ./path/to/json_source/directory he pl
```
(first run of this script will create virtual environment `~/.local/share/tnk_venv` and install requirements).  Books will be exported to
`./output`. 

To go through all sources present in `./json_sources` run script
```bash
bash ./iterate.sh
```
with one from these options `--pl`, `--yi` or `--yi-pl` to select language variants to include (hebrew is in this case implicit).

```bash
bash ./iterate.sh --pl
bash ./iterate.sh --yi
bash ./iterate.sh --yi-pl
```


* Multilanguage version `he`and `pl` to find [here](https://github.com/grunwmar/cylkows-tanakh-epub/tree/main/output/he-pl).
* Multilanguage version `he` and `yi` to find [here](https://github.com/grunwmar/cylkows-tanakh-epub/tree/main/output/he-yi).
* Multilanguage version `he`,`yi` and `pl` to find [here](https://github.com/grunwmar/cylkows-tanakh-epub/tree/main/output/he-yi-pl).
* Example of exported epubs in [tar.xz](https://github.com/grunwmar/cylkows-tanakh-epub/raw/main/output/tanakh_incomplete_%5BPL%5D_epub.tar.xz) archive.
