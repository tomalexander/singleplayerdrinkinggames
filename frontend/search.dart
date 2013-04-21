library search;
import 'dart:html';
import 'nav_bar.dart';

class search_form
{
    DivElement content;
    search_form()
    {
        content = new Element.html("<div>Search</div>");
        content.id = "search";

	content.nodes.clear();
        
        FormElement form = new Element.html("<form action=\"search.php\" method=\"POST\"></form>");
        content.nodes.add(form);
        
        form.nodes.add(new Text("Keyword to search: "));
        InputElement keyword = new Element.html("<input type=\"text\" name=\"keyword\" required>");
        form.nodes.add(keyword);
        form.nodes.add(new Element.html("<br>"));
        
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Search\">");
        form.nodes.add(submit);
        form.onSubmit.listen((e) {submit.disabled = true;});

    }

    


}
