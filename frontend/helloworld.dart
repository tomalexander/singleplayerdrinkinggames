import 'dart:html';

main() {
  var button = new ButtonElement();
  button..id = 'confirm'
        ..text = 'Click to Confirm'
        ..classes.add('important')
        ..on.click.add((e) => window.alert('Confirmed!'));
  query('#registration').children.add(button);
  window.alert('RUN');
}
