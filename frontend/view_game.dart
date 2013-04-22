library view_game;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'nav_bar.dart';
import 'util.dart';
import 'dart:core';

import 'login.dart';
import 'markdown.dart';


/*
 * Loads the "view game" form, allowing the user to view a selected game's
 * description, raiting, and other data.
 */
class view_game_form {

    DivElement content;

    display_pre(content) {
        var new_pre = new Element.html("<pre></pre>");
        new_pre.text = content;
        this.content.children.add(new_pre);
    }

    /**
     * Adds the disqus comment bar to the view_game div
     *
     * @param game_name The game name to identify the comment
     * thread we should use.
     */
    add_comments(String game_name) {
        //Set disqus_identified in javascript
        ScriptElement dsq_page_name= new ScriptElement();
        dsq_page_name.type = 'text/javascript';
        dsq_page_name.text = """
            if (!window.DISQUS) {
                var disqus_shortname  = "singleplayerdrinkinggames";
                var disqus_identifier = "gameid_fufufufu_$game_name";
                var disqus_url = "https://singleplayerdrinkinggames.com";
             (function() {
            var dsq = document.createElement('script'); dsq.type = 'text/javascript'; dsq.async = true;
            dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
            (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
            })();
            } else {
                window.DISQUS.reset({
                    reload: true,
                    config: function() {
                        window.alert(this.page.identifier);
                        this.page.identifier = "gameid_fufufufu_$game_name";
                        this.page.url = "https://singleplayerdrinkinggames.com#!fu";
                        window.alert(this.page.identifier);
                    }});
            }
            """;

        //Make thread div so it shows up in the right spot
        DivElement disqus_div = new DivElement();
        disqus_div.id = "disqus_thread";

        //Add all the elements
        this.content.children.add(disqus_div);
        this.content.children.add(dsq_page_name);
    }

    /**
     * Allows the user to vote on a game.
     * 
     * @param vote: Value of the vote. Positive 1 is a postive vote, negative 1 is a negative vote.
     * @param gameid: ID of the game that is being voted for. 
     * 
     * @return int: The total value of votes after the new vote is submitted to the database.
     */
    int process_vote(gameid, vote) {   
        String uuid = get_cookie("login_uuid");
        var votedata = {"game_id":"$gameid","uuid":"$uuid","vote":"$vote"};
        String encodedData = encode_map(votedata);
        int ret = 0;
        String resp = get_string_synchronous("vote.php", encodedData);
        String parsed_resp = parse(resp);
        ret = parsed_resp["vote"];
        return ret;
    }

    /**
     * Fetch the total value of the votes from the database in order to display it on the webpage.
     * 
     * @param gameid: ID of the game to retreive votes for.
     * 
     * @return int: Total values of all the votes.
     */
    int get_vote(gameid) {
        String uuid = get_cookie("login_uuid");
        var votedata = {"game_id":gameid,"uuid":uuid};
        String encodedData = encode_map(votedata);
        int ret = 0;
        String resp = get_string_synchronous("get_vote.php", encodedData);
        String parsed_resp = parse(resp);
        ret = parsed_resp["vote"];
        return ret;
    }

    /**
     * Change the state of the buttons on the page based on how the user voted, if the user voted at all.
     * 
     * @param vote_val: Value of the user's vote.
     * @param down_button: The location of the downvote button.
     * @param up_button: The location of the upvote button.
     */
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
    
    /**
     * Construct the vote buttons, and add listeners that let them
     * vote for the appropriate game when pushed.
     * 
     * @param gameid: the ID of the game that the buttons vote for.
     */
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
        
        //Listeners for the vote buttons
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

    /**
     * Displays the view_game_form.
     */
    view_game_form() {
        this.content = new Element.html("<div></div>");
        this.content.id = "view_game";
        var gameid = get_url_variable("gameid");
        var postdata = {"gameid":gameid};
        String encodedData = encode_map(postdata);
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

                // Add comments
                this.add_comments(gameid);
            });
    }
}
