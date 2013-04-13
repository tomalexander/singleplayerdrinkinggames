library view_game;

import 'dart:html';
import 'dart:json';
import 'dart:uri';
import 'util.dart';
import 'dart:core';

class markdown_node {
    List<markdown_node> children;
    markdown_node() {
        children = new List<markdown_node>();
    }

    String generate_html() {
        return "ERROR: SHOULD BE OVERRIDDEN";
    }
}

class markdown_headline extends markdown_node {
    int level;
    markdown_headline(int _level, String content) : super() {
        level = _level;
        List<markdown_node> subcontent = generate_markdown_nodes(content);
        for (markdown_node cur in subcontent) {
            children.add(cur);
        }
    }

    String generate_html() {
        String ret = "<h${level}>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html()}";
        }
        ret = "${ret}</h${level}>";
        return ret;
    }
}

class markdown_paragraph extends markdown_node {
    String content;
    markdown_paragraph(String _content) : super() {
        content = _content;
    }

    String generate_html() {
        String ret = "<p>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html();}";
        }
        ret = "${ret}</p>";
        return ret;
    }
}

class markdown_blockquote extends markdown_node {
    String content;
    markdown_blockquote(String _content) : super() {
        content = _content;
    }

    String generate_html() {
        String ret = "<blockquote>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html();}";
        }
        ret = "${ret}</blockquote>";
        return ret;
    }
}

class markdown_emphasis extends markdown_node {
    String content;
    markdown_emphasis(String _content) : super() {
        content = _content;
    }

    String generate_html() {
        String ret = "<em>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html();}";
        }
        ret = "${ret}</em>";
        return ret;
    }
}

class markdown_strong extends markdown_node {
    String content;
    markdown_emphasis(String _content) : super() {
        content = _content;
    }

    String generate_html() {
        String ret = "<strong>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html();}";
        }
        ret = "${ret}</strong>";
        return ret;
    }
}

class markdown_plaintext extends markdown_node {
    String content;
    markdown_plaintext(String _content) : super() {
        content = _content;
    }

    String generate_html() {
        return content;
    }
}

class markdown_field {
    DivElement content;

    markdown_field(String inp) {
        content = new Element.html("<div></div>");
        List<markdown_node> top_nodes = generate_markdown_nodes(inp);
        for (markdown_node cur in top_nodes) {
            content.nodes.add(new Text(cur.generate_html()));
        }
    }
}

main() {

    try {
        main_wrapped();
    } catch (ex) {
        document.window.alert(ex.toString());
    }
}

List<markdown_node> generate_markdown_nodes(String content) {
    List<markdown_node> ret = new List<markdown_node>();

    RegExp plain_header = new RegExp(r"^(#+) ([^#\n]+)#*\n", multiLine: true);
    if (plain_header.hasMatch(content)) {
        Match found = plain_header.firstMatch(content);
        int start = found.start;
        int end = found.end;
        String before = content.substring(0, start);
        String after = content.substring(end);
        for (markdown_node cur in generate_markdown_nodes(before)) {
            ret.add(cur);
        }
        int header_depth = found.group(1).trim().length;
        ret.add(new markdown_headline(header_depth, found.group(2)));
        for (markdown_node cur in generate_markdown_nodes(after)) {
            ret.add(cur);
        }
        return ret;
    }

    ret.add(new markdown_plaintext(content));
    return ret;
}

main_wrapped() {
    String inp = "A First Level Header\n====================\n\nA Second Level Header\n---------------------\n\nNow is the time for all good men to come to\nthe aid of their country. This is just a\nregular paragraph.\n\nThe quick brown fox jumped over the lazy\ndog's back.\n\n### Header 3\n\n> This is a blockquote.\n> \n> This is the second paragraph in the blockquote.\n>\n> ## This is an H2 in a blockquote";
    query('#main').children.add(new markdown_field(inp).content);
}
