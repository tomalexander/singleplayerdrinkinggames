import 'dart:html';

class nav_bar
{
    DivElement content;
    nav_bar()
    {
        content = new DivElement();
        var link_list = ["Home", "Games", "Booze"];
        link_list.forEach( (e) {
            var link_html = new Element.html("<a href=/${e}.html> ${e} </a>");
            content.children.add(link_html);
        });
    }
}

main() {

    try {
        main_wrapped();
    } on Exception
    catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
  query('#main').children.add(new nav_bar().content);
}
