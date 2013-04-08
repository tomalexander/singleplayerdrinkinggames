library sidebar;
import 'dart:html';
import 'login.dart';

class sidebar {
  DivElement content;

  sidebar() {
    content = new DivElement();
    content.classes.add('sidebar');
    content.text = "SIDEBAR";
  }
}



