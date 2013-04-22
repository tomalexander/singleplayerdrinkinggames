library search;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'nav_bar.dart';
import 'util.dart';
import 'view_game.dart';

 /**
  * Allows the user to search the website for a certain keyword.
  */
class search_form {
    DivElement content;

    /**
     * Creates the form that allows a user to search the site based on an input keyword
     * Upon initiating a search, the form displays either the results as a list of links to game pages
     * or that no games match the keyword specified
     */
    search_form() {
        content = new Element.html("<div>Search</div>");
        content.id = "search";

		content.nodes.clear();
        
        FormElement form = new Element.html("<form action=\"search.php\" method=\"POST\" onsubmit=\"return false;\"></form>");
        content.nodes.add(form);
        
        form.nodes.add(new Text("Keyword to search: "));
        InputElement keyword = new Element.html("<input type=\"text\" name=\"keyword\" required>");
        form.nodes.add(keyword);
        form.nodes.add(new Element.html("<br>"));
        
        SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Search\">");
		submit.id = "searchbutton";
        form.nodes.add(submit);

        DivElement search_results = new Element.html("<div></div>");
        content.nodes.add(search_results);

        form.onSubmit.listen((e) {
                submit.disabled = true;
                Map search_vars = new Map();
                search_vars["keyword"] = keyword.value;
                String json_results = get_string_synchronous("search.php", encodeMap(search_vars));
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
