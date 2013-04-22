library search;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'nav_bar.dart';
import 'util.dart';

class search_form {
    DivElement content;

    search_form() {
        content = new Element.html("<div id=\"search\">Search</div>");

		content.nodes.clear();
        
        FormElement form = new Element.html("<form action=\"search.php\" method=\"POST\" onsubmit=\"return false;\"></form>");
        content.nodes.add(form);
        
        form.nodes.add(new Text("Keyword to search: "));
        InputElement keyword = new Element.html("<input type=\"text\" name=\"keyword\" required>");
        form.nodes.add(keyword);
        form.nodes.add(new Element.html("<br>"));
        
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Search\" id=\"searchbutton\">");
        form.nodes.add(submit);

        DivElement search_results = new Element.html("<div></div>");
        content.nodes.add(search_results);

        form.onSubmit.listen((e) {
                submit.disabled = true;
                Map search_vars = new Map();
                search_vars["keyword"] = keyword.value;
                String json_results = get_string_synchronous("search.php", encode_map(search_vars));
                List results = parse(json_results);
                
                search_results.nodes.clear();
                if (results.length == 0) {
                    search_results.nodes.add(new Text("No games found"));
                } else {
                    for (Map game in results) {
                        DivElement InfoDiv = new DivElement();
                        InfoDiv.classes.add('game_name');
                        var gamename = game["game_name"];
                        var gameid = game["game_id"];
                        var link = new Element.html("<a href=/#page=view_game;gameid=${gameid}>${gamename}</a>");
                        InfoDiv.children.add(link);
                        search_results.nodes.add(InfoDiv);
                    }
                }
                submit.disabled = false;
            });
	}
}
