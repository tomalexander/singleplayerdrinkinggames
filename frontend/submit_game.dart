library submit_game;
import 'dart:html';
import 'login.dart';
import 'markdown.dart';

class submit_game_form {
  DivElement content;
  
  submit_game_form() {
    /*
     * Form to submit a new game to the database
     */
    content = new Element.html("<div id=\"game-submission\"></div>");
    Map user_data = get_login_details();
    if ( user_data != null) {
      // User logged in, create form
      create_form(user_data['id']);
    } else {
      // User not logged in, tell them they're dumb
      content.nodes.clear();
      content.nodes.add(new Text("You must be logged in to submit a game."));
      //content.nodes.add(new login_form());
    }
  }
  
  void create_form(user_id) {
    /*
     * Generates the form that lets a user submit a new game to the database.
     */
    content.nodes.clear();
    FormElement form = new FormElement();
    form.action = "submit_game.php";
    form.method = "POST";
    content.nodes.add(form);
    
    form.nodes.add(new Element.html("<input type=\"hidden\" name=\"submitter_id\" value=\"${user_id}\">"));
    
    DivElement de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"game-name\">Game Name:</label>"));
    de.nodes.add(new Element.html("<input class=\"col2\" type=\"text\" name=\"game_name\" maxlength=\"255\" placeholder=\"Game Name Goes Here: 255 characters\" required>"));
    
    form.nodes.add(de);
    
    de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"short-description\">Short Description:</label>"));
    de.nodes.add(new Element.html("<input class=\"col2\" type=\"text\" name=\"short_description\" maxlength=\"255\" placeholder=\"Short Description: 255 characters\" required>"));
    
    form.nodes.add(de);
    
    de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"long-description\">Long Description:</label>"));
    de.nodes.add(new Element.html("<textarea class=\"col2\" rows=\"4\" name=\"long_description\" maxlength=\"1023\" placeholder=\"Long Description: 1023 characters\" required>"));
    
    form.nodes.add(de);
    
    de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"supplies\">Supplies:</label>"));
    DivElement supply_div = new Element.html("<div id=\"supply-div\" class=\"col2\"></div>");
    if(supply_div.nodes.length < 2) {
      add_supply_item(supply_div, first_item : true);
    }
    de.nodes.add(supply_div);
    form.nodes.add(de);
    
    de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"instructions\">Instructions:</label>"));
    TextAreaElement instructions_markdown = new Element.html("<textarea class=\"col2\" rows=\"8\" name=\"instructions\" placeholder=\"Instructions\" required>");
    de.nodes.add(instructions_markdown);

    form.nodes.add(de);

    FieldSetElement fse = new Element.html("<fieldset class=\"row\" style=\"width:80%; margin:0% 10%;\"></fieldset>");
    fse.nodes.add(new Element.html("<legend style=\"color:black;font-weight:bold;\">Preview Instructions</legend>"));
    DivElement instructions_preview = new Element.html("<div></div>");
    fse.nodes.add(instructions_preview);
    form.nodes.add(fse);
    instructions_markdown.onInput.listen((e) {
            instructions_preview.innerHtml = markdown_to_html(instructions_markdown.value);
        });
    
    
    SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Create Game\">");
    form.nodes.add(submit);
    form.onSubmit.listen((e) {submit.disabled = true;});
  }
  
  void add_supply_item(DivElement to_insert_after, {bool first_item : false}) {
    /*
     * Lets a user add an additional "supply" element to the "submit game" form.
     */
    DivElement new_item = new Element.html("<div class=\"item\"></div>");
    Element new_box = new Element.html("<input id=\"supplies\" name=\"supplies[]\" class=\"supplies\" type=\"text\" placeholder=\"Add Supply Here: 255 characters\" maxlength=\"255\">");
    Element new_add_button = new Element.html("<input id=\"add-supply-button\" name=\"add-supply-button\" class=\"add-supply-button\" type=\"button\" value=\"+\">");
    Element new_remove_button = new Element.html("<input id=\"remove-supply-button\" name=\"remove-supply-button\" class=\"remove-supply-button\" type=\"button\" value=\"-\">");
    
    new_add_button.onClick.listen((e) => add_supply_item(new_item));
    new_remove_button.onClick.listen((e) { 
        // grab [parent]'s [parent], remove [parent], add a new item if none exist
        DivElement parent_parent = new_add_button.parent.parent;
        new_add_button.parentNode.remove();
        if(parent_parent.nodes.length < 1){
          add_supply_item(parent_parent, first_item : true);
        }
      });
    
    new_item.nodes.add(new_box);
    new_item.nodes.add(new_add_button);
    new_item.nodes.add(new_remove_button);
    
    if(first_item) {
      to_insert_after.insertAdjacentElement("afterBegin", new_item);
    } else {
      to_insert_after.insertAdjacentElement("afterEnd", new_item);
    }
  }
}



