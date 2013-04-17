library view_game;

import 'dart:json';
import 'dart:uri';
import 'dart:core';

class markdown_regex {
    RegExp regex;
    Function callback;
    int start;
    int end;
    String before;
    String after;
    Match found;
    bool has_match;
    Function process_function;
    markdown_regex(RegExp _regex, Function _callback, {Function process: generate_markdown_nodes}) {
        regex = _regex;
        callback = _callback;
        start = -1;
        end = -1;
        has_match = false;
        process_function = process;
    }

    void populate_variables(String inp) {
        if (regex.hasMatch(inp)) {
            has_match = true;
        } else {
            return;
        }
        found = regex.firstMatch(inp);
        start = found.start;
        end = found.end;
        before = inp.substring(0, start);
        after = inp.substring(end);
    }

    List<markdown_node> execute() {
        List<markdown_node> ret = new List<markdown_node>();
        if (!has_match)
            return ret;
        
        for (markdown_node cur in process_function(before)) {
            ret.add(cur);
        }
        // call the callback
        ret.add(callback(found));

        for (markdown_node cur in process_function(after)) {
            ret.add(cur);
        }
        return ret;
    }
}

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
        // List<markdown_node> subcontent = generate_markdown_nodes(content);
        // for (markdown_node cur in subcontent) {
        //     children.add(cur);
        // }
        children.add(new markdown_plaintext(content));
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
    markdown_paragraph(String _content) : super() {
        children.add(new markdown_plaintext(_content.trim()));
    }

    String generate_html() {
        String ret = "<p>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html()}";
        }
        ret = "${ret}</p>";
        return ret;
    }
}

class markdown_blockquote extends markdown_node {
    markdown_blockquote(String _content) : super() {
        for (markdown_node cur in generate_markdown_nodes(_content)) {
            children.add(cur);
        }
    }

    String generate_html() {
        String ret = "<blockquote>";
        for (markdown_node cur in children) {
            ret = "${ret}${cur.generate_html()}";
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
    markdown_strong(String _content) : super() {
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

/** 
 * Convert markdown to HTML
 * 
 * @param inp Markdown formatted text
 * 
 * @return HTML formatted text
 */
String markdown_to_html(String inp) {
    String ret = "";
    List<markdown_node> top_nodes = generate_markdown_nodes(inp);
    for (markdown_node cur in top_nodes) {
        ret = "${ret}${cur.generate_html()}";
    }
    return ret;
}

main() {

    try {
        main_wrapped();
    } catch (ex) {
        print(ex.toString());
    }
}

List<markdown_node> generate_markdown_nodes(String content) {
    List<markdown_node> ret = new List<markdown_node>();
    List<markdown_regex> regular_expressions = new List<markdown_regex>();

    RegExp plain_header = new RegExp(r"^(#+) ([^#\n]+)#*\n?", multiLine: true);
    RegExp blockquote = new RegExp(r"(^> ?.*?$\n?)+", multiLine: true);
    RegExp underline_big_header = new RegExp(r"^(.+)\n=+\n?", multiLine: true);
    RegExp underline_little_header = new RegExp(r"^(.+)\n-+\n?", multiLine: true);
    
    regular_expressions.add(new markdown_regex(plain_header, (Match found) {
                int header_depth = found.group(1).trim().length;
                return new markdown_headline(header_depth, found.group(2));
    }));
    regular_expressions.add(new markdown_regex(blockquote, (Match found) {
                // Trim the '> ' at the start of the line
                String fixed = found.group(0).splitMapJoin("\n", onNonMatch: (String match) {
                        if (match.length < 2)
                            return "";
                        else
                            return match.substring(2);
                    });
                return new markdown_blockquote(fixed);
    }));
    regular_expressions.add(new markdown_regex(underline_big_header, (Match found) {
                return new markdown_headline(1, found.group(1));
    }));
    regular_expressions.add(new markdown_regex(underline_little_header, (Match found) {
                return new markdown_headline(2, found.group(1));
    }));


    bool found_match = false;
    int earliest_start = -1;
    markdown_regex earliest_regex = null;
    for (markdown_regex cur in regular_expressions) {
        cur.populate_variables(content);
        if (!cur.has_match)
            continue;

        found_match = true;
        if (earliest_start == -1 || cur.start <= earliest_start) {
            earliest_start = cur.start;
            earliest_regex = cur;
        }
    }

    if (!found_match) {
        if (content.length > 0) {
            for (markdown_node cur in generate_markdown_paragraphs(content)) {
                ret.add(cur);
            }
        }
        return ret;
    }
    return earliest_regex.execute();
}

List<markdown_node> generate_markdown_paragraphs(String content) {
    List<markdown_node> ret = new List<markdown_node>();
    List<markdown_regex> regular_expressions = new List<markdown_regex>();

    RegExp empty_line = new RegExp(r"^\s*$", multiLine: true);
    RegExp paragraph_regex = new RegExp(r"(^.*[^\s]+.*\n?)+", multiLine: true);
    regular_expressions.add(new markdown_regex(paragraph_regex, (Match found) {
                return new markdown_paragraph(found.group(0));
    }, process: generate_markdown_paragraphs));
    
    bool found_match = false;
    int earliest_start = -1;
    markdown_regex earliest_regex = null;
    for (markdown_regex cur in regular_expressions) {
        cur.populate_variables(content);
        if (!cur.has_match)
            continue;

        found_match = true;
        if (earliest_start == -1 || cur.start <= earliest_start) {
            earliest_start = cur.start;
            earliest_regex = cur;
        }
    }

    if (!found_match) {
        if (content.length > 0) {
            ret.add(new markdown_plaintext(content));
        }
        return ret;
    }
    return earliest_regex.execute();
}

main_wrapped() {
    String inp = "A First Level Header\n====================\n\nA Second Level Header\n---------------------\n\nNow is the time for all good men to come to\nthe aid of their country. This is just a\nregular paragraph.\n\nThe quick brown fox jumped over the lazy\ndog's back.\n\n### Header 3\n\n> This is a blockquote.\n> \n> This is the second paragraph in the blockquote.\n>\n> ## This is an H2 in a blockquote";
    print(markdown_to_html(inp));
}
