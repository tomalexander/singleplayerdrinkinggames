library list_games;

import 'dart:html';
import 'dart:json';
import 'nav_bar.dart';
import 'util.dart';

/*
 * Makes a list of the games avalible for the user to view.
 */
class list_games_form {
    DivElement content;

    /**
     * Displays the list of games avalible for the user to view.
     */
    list_games_form() {
        content = new Element.html("<div></div>");
        content.id = "view_game";
        get_string("list_games.php", "", (resp) {
                List games = parse(resp);
                games.forEach( (Map game) {
                        DivElement InfoDiv = new DivElement();
                        InfoDiv.classes.add('game_name');
                        var gamename = game["game_name"];
                        var gameid = game["game_id"];
                        var link = new Element.html("<a href=/#page=view_game;gameid=${gameid}>${gamename}</a>");
                        InfoDiv.children.add(link);
                        content.children.add(InfoDiv);
                    });
            });
    }
}

