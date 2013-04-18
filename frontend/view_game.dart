library view_game;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'nav_bar.dart';
import 'util.dart';
import 'dart:core';

import 'login.dart';
import 'markdown.dart';

String encodeMap(Map data) {
    return data.keys.map((k) {
        return '${encodeUriComponent(k)}=${encodeUriComponent(data[k])}';
    }).join('&');
}

class view_game_form {
    DivElement content;

    display_pre(content) {
        var new_pre = new Element.html("<pre></pre>");
        new_pre.text = content;
        this.content.children.add(new_pre);
    }

    int process_vote(gameid, vote) {
      String uuid = get_cookie("login_uuid");
      var votedata = {"game_id":"$gameid","uuid":"$uuid","vote":"$vote"};
      String encodedData = encodeMap(votedata);
      int ret = 0;
      String resp = get_string_synchronous("vote.php", encodedData);
      String parsed_resp = parse(resp);
      ret = parsed_resp["vote"];
      return ret;
    }

    int get_vote(gameid) {
        String uuid = get_cookie("login_uuid");
        var votedata = {"game_id":gameid,"uuid":uuid};
        String encodedData = encodeMap(votedata);
        int ret = 0;
        String resp = get_string_synchronous("get_vote.php", encodedData);
        String parsed_resp = parse(resp);
        ret = parsed_resp["vote"];
        return ret;
    }

    void redo_buttons(vote_val, down_button, up_button) {
        if(vote_val == 1) {
            down_button.classes.clear();
            up_button.classes.clear();
            down_button.classes.add("down-button");
            up_button.classes.add("up-button-a");
        } else if (vote_val == -1) {
            down_button.classes.clear();
            up_button.classes.clear();
            down_button.classes.add("down-button-a");
            up_button.classes.add("up-button");
        } else {
            down_button.classes.clear();
            up_button.classes.clear();
            down_button.classes.add("down-button");
            up_button.classes.add("up-button");
        }
    }
    
    void vote_buttons(gameid) {
        Map user_data = get_login_details();
        if(user_data == null) {
          return;
        }

        var new_pre = new Element.html("<pre></pre>");
        int prev_vote = get_vote(gameid);
        Element down_button = new Element.html("<input id=\"down-button\" name=\"down-button\" type=\"button\" value=\"DOWN\">");
        Element up_button = new Element.html("<input id=\"up-button\" name=\"up-button\" type=\"button\" value=\"UP\">");
        this.redo_buttons(prev_vote, down_button, up_button);

        down_button.onClick.listen((e) {
            int vote_val = this.process_vote(gameid,-1);
            this.redo_buttons(vote_val, down_button, up_button);
          });
        up_button.onClick.listen((e) {
            int vote_val = this.process_vote(gameid,1);
            this.redo_buttons(vote_val, down_button, up_button);
          });
        new_pre.text = "Vote : ";
        new_pre.nodes.add(down_button);
        new_pre.nodes.add(up_button);
        this.content.children.add(new_pre);
    }

    view_game_form() {
        this.content = new Element.html("<div></div>");
        this.content.id = "view_game";
        var gameid = get_url_variable("gameid");
        var postdata = {"gameid":gameid};
        String encodedData = encodeMap(postdata);
        get_string("view_game.php", encodedData, (resp) {
            var parsed_resp = parse(resp);
            this.display_pre("Name : ${parsed_resp["game_name"]}");
            this.display_pre("Submitter : ${parsed_resp["submitter_username"]}");
            this.display_pre("Short Description : ${parsed_resp["short_description"]}");
            this.display_pre("Long Description : ${parsed_resp["long_description"]}");
            DivElement instructions_div = new Element.tag("div");
            instructions_div.innerHtml = markdown_to_html(parsed_resp["instructions"]);
            this.content.children.add(instructions_div);
            
            this.display_pre("Supplies:\n${parsed_resp["supplies"].join("\n")}");

            this.display_pre("Upvotes : ${parsed_resp["upvote_count"]}");
            this.display_pre("Downvotes : ${parsed_resp["downvote_count"]}");
            this.vote_buttons(gameid);
            //this.display_pre(resp);
        });
    }
}
