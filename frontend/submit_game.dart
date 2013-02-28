import 'dart:html';

class submit_game_form {
  DivElement content;
  
  submit_game_form() {
    content = new Element.html("<div id=\"game-submission\"></div>");
    FormElement form = new FormElement();
    form.action = "submit_game.php";
    form.method = "POST";
    content.nodes.add(form);
    
    DivElement de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"game-name\">Game Name:</label>"));
    de.nodes.add(new Element.html("<input class=\"col2\" type=\"text\" name=\"game-name\" maxlength=\"255\" placeholder=\"Game Name Goes Here: 255 characters\" required>"));
    
    form.nodes.add(de);
    
    de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"short-description\">Short Description:</label>"));
    de.nodes.add(new Element.html("<input class=\"col2\" type=\"text\" name=\"short-description\" maxlength=\"255\" placeholder=\"Short Description: 255 characters\" required>"));
    
    form.nodes.add(de);
    
    de = new Element.html("<div class=\"row\"></div>");
    de.nodes.add(new Element.html("<label class=\"col1\" for=\"long-description\">Long Description:</label>"));
    de.nodes.add(new Element.html("<textarea class=\"col2\" rows=\"4\" name=\"long-description\" maxlength=\"1023\" placeholder=\"Long Description: 1023 characters\" required>"));
    
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
    DivElement instruction_div = new Element.html("<div id=\"instruction-div\" class=\"col2\"></div>");
    if(instruction_div.nodes.length < 2) {
      add_instruction_item(instruction_div, first_item : true);
    }
    de.nodes.add(instruction_div);
    form.nodes.add(de);
    
    SubmitButtonInputElement submit = new Element.html("<input type=\"submit\" value=\"Create Game\">");
    form.nodes.add(submit);
    form.onSubmit.listen((e) {submit.disabled = true;});
  }
  
  void add_supply_item(DivElement to_insert_after, {bool first_item : false}) {
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
  
  void add_instruction_item(DivElement to_insert_after, {bool first_item : false}) {
    DivElement new_item = new Element.html("<div class=\"item\"></div>");
    Element new_box = new Element.html("<input id=\"instructions\" name=\"instructions[]\" class=\"instructions\" type=\"text\" placeholder=\"Add Instruction Here: 255 characters\" maxlength=\"255\">");
    Element new_add_button = new Element.html("<input id=\"add-instruction-button\" name=\"add-instruction-button\" class=\"add-instruction-button\" type=\"button\" value=\"+\">");
    Element new_remove_button = new Element.html("<input id=\"remove-instruction-button\" name=\"remove-instruction-button\" class=\"add-instruction-button\" type=\"button\" value=\"-\">");

    new_add_button.onClick.listen((e) => add_instruction_item(new_item));
    new_remove_button.onClick.listen((e) { 
                                           // grab [parent]'s [parent], remove [parent], add a new item if none exist
                                           DivElement parent_parent = new_add_button.parent.parent;
                                           new_add_button.parentNode.remove();
                                           if(parent_parent.nodes.length < 1){
                                             add_instruction_item(parent_parent, first_item : true);
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



