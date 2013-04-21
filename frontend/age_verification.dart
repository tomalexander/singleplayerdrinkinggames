library age_verification;
import 'dart:html';
import 'util.dart';

class age_verification {
    DivElement content;
    age_verification() {
        content = new Element.html("<div></div>");
        content.nodes.add(new Element.html("<h2>Please verify your age</h2>"));
        content.nodes.add(new Element.html("<br>"));
        ButtonElement over = new Element.html("<button>I am at least 18 years old</button>");
        content.nodes.add(over);
        content.nodes.add(new Element.html("<a href=\"\">I am under 18 years old</a>"));

        over.onClick.listen((e) {
                set_cookie("over18", "true", seconds: 86400);
                window.location = "#page=index";
            });
    }
}