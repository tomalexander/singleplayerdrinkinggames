library nav_bar;
import 'dart:html';

class nav_bar
{
    DivElement content;
    nav_bar()
    {
        content = new DivElement();
        content.id = "nav_bar";
        var link_list = ["Home", "Games", "Booze", "Login", "Register"];
        var link_map = {
            "Home" : "index",
            "Games" : "games",
            "Booze" : "booze",
            "Login" : "login",
            "Register" : "register"
        };
        link_list.forEach( (e) {
            var page = link_map[e];
            var link_html = new Element.html("<a href=/#page=${page}> ${e} </a>");
            content.children.add(link_html);
        });
    }
}
