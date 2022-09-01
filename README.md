Usage: build.sh -b buildnum [-o output] [-f] -j folder
Usage: deploy.sh [-b buildnum] [-t title] [-d description] [-i id] [-f] zip

For example:
./build.sh -b 1 -o amazing_app.zip app/
./deploy.sh amazing_app.zip


Requires:
dnf install xmlstarlet

Files:
/www/idgetlist.xml

<?xml version="1.0" encoding="UTF-8"?>
<rsp stat="ok">
  <list>
  </list>
</rsp>

Blank folder:
/www/widgets/

Acknowledgements:
https://developer.samsung.com/smarttv/develop
https://piecioshka.github.io/slides-first-app-on-samsung-smart-tv/?full#file-widgetlist-xml
https://stackoverflow.com/questions/415677/how-to-replace-placeholders-in-a-text-file
https://unix.stackexchange.com/questions/523467/creating-new-elements-with-xmlstarlet
https://linuxhandbook.com/replace-string-bash/
https://www.baeldung.com/linux/use-command-line-arguments-in-bash-script
https://stackoverflow.com/questions/9332802/how-to-write-a-bash-script-that-takes-optional-input-arguments
https://www.cyberciti.biz/faq/howto-linux-unix-bash-append-textto-variables/
https://www.cyberciti.biz/faq/bash-check-if-file-does-not-exist-linux-unix/
https://stackoverflow.com/questions/44186213/how-to-declare-xpath-namespaces-in-xmlstarlet#:~:text=Implicit%20Declaration%20of%20Default%20Namespace&text=In%20order%20to%20handle%20namespaces,0%2B).
https://stackoverflow.com/questions/9018723/what-is-the-simplest-way-to-remove-a-trailing-slash-from-each-parameter
https://stackoverflow.com/questions/9018723/what-is-the-simplest-way-to-remove-a-trailing-slash-from-each-parameter
https://stackoverflow.com/questions/6314679/in-bash-how-do-i-count-the-number-of-lines-in-a-variable
