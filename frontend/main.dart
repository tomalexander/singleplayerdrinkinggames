import 'dart:html';

class nav_bar
{
    DivElement content;
    nav_bar()
    {
        content = new Element.html("<div></div>");
        nav_links = ["Games", "Good Booze", "Logout"];
        nav_links.forEach( (e) {
            link_html = new Element.html("<a> ${e} </html>");
            content.nodes.add(link_html);
        });
    }
}

main() 
{

    try {
        main_wrapped();
    } on Exception
    catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() 
{
    query('#main').children.add(new nav_bar().content);
}
