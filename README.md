# About

A couple of command line tools. One to build and the other to deploy a samsung telly app for local testing purposes.
I don't recommend these for production use btw. 
It's handy for me to keep them here. If you find them useful too, fab. 

# Usage 

## How to build

Assumes a samsung TV app is contained in folder. Outputs a zip file.

Specify the build number using the '-b' flag. I'd recomend going with a simple increment, or for the adventurous, a git commit id.

```
Usage: build.sh -b buildnum [-o output] [-f] -j folder
```

## How to deploy

Assumes a samsung TV app has been build in zip format. There are options to override the title, descrtiption, id, etc which appear in the index.

```
Usage: deploy.sh [-b buildnum] [-t title] [-d description] [-i id] [-f] zip
```

## For example:

```
./build.sh -b 1 -o amazing_app.zip app/
./build.sh -b $(git rev-parse --short HEAD) -o amazing_app.zip app/

./deploy.sh amazing_app.zip
```

# Requires
dnf install xmlstarlet

# Files

Samsung tellies look for an index of available apps called `widgetlist.xml`.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="ok">
  <list>
  </list>
</rsp>
```

The deploy script updates this file, and deployes the apps into a `widgets` folder.

e.g. 
```
/www/widgetlist.xml
/www/widgets/amazing_app.zip
```

In my setup, `www/` maps to `http://172.16.0.10/` and so, it all looks like this to my telly:

```
http://172.16.0.10/widgetlist.xml
http://172.16.0.10/widgets/amazing_app.zip
```

# Acknowledgements

Where would we be without Stack Overflow! Go Community!
Your work is appreciated + very useful.

* https://developer.samsung.com/smarttv/develop
* https://piecioshka.github.io/slides-first-app-on-samsung-smart-tv/?full#file-widgetlist-xml
* https://stackoverflow.com/questions/415677/how-to-replace-placeholders-in-a-text-file
* https://unix.stackexchange.com/questions/523467/creating-new-elements-with-xmlstarlet
* https://linuxhandbook.com/replace-string-bash/
* https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
* https://stackoverflow.com/questions/9332802/how-to-write-a-bash-script-that-takes-optional-input-arguments
* https://www.cyberciti.biz/faq/howto-linux-unix-bash-append-textto-variables/
* https://www.cyberciti.biz/faq/bash-check-if-file-does-not-exist-linux-unix/
* https://stackoverflow.com/questions/44186213/how-to-declare-xpath-namespaces-in-xmlstarlet#:~:text=Implicit%20Declaration%20of%20Default%20Namespace&text=In%20order%20to%20handle%20namespaces,0%2B).
* https://stackoverflow.com/questions/6314679/in-bash-how-do-i-count-the-number-of-lines-in-a-variable
