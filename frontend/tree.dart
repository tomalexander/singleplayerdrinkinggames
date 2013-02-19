import 'dart:html';

class tree
{
    DivElement content;
    String name;

    /** 
     * Construct a tree
     *
     * @param _name The name of the return value in the form
     * @param data A list of lists. Each sub-element contains the fields (id, parentid, text)
     */
    tree(String _name, List data) {
        content = new Element.tag("div");
        name = _name;
        InputElement hidden_element = new Element.html("<input type=\"hidden\" name=\"${name}\">");
        content.nodes.add(hidden_element);
    }
}

main() {
    try {
        main_wrapped();
    } on Exception catch (ex) {
        document.window.alert(ex.toString());
    }
}

main_wrapped() {
    String json_data = "[[1,1,\"Candy\"],[2,1,\"igloo\"],[3,2,\"sloth\"],[4,2,\"tree\"]]";
    query('#tree').children.add(new tree("submit_name", parse(json_data)).content);
}
