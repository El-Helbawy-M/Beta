abstract class AppEvents {
  dynamic arrgument;
  AppEvents({this.arrgument});
}

class Click extends AppEvents {
  Click({dynamic arrgument}) : super(arrgument: arrgument);
}

class Get extends AppEvents {
  Get({dynamic arrgument}) : super(arrgument: arrgument);
}

class Update extends AppEvents {
  Update({dynamic arrgument}) : super(arrgument: arrgument);
}

class Send extends AppEvents {
  Send({dynamic arrgument}) : super(arrgument: arrgument);
}

class Next extends AppEvents {
  Next({dynamic arrgument}) : super(arrgument: arrgument);
}

class Back extends AppEvents {
  Back({dynamic arrgument}) : super(arrgument: arrgument);
}
