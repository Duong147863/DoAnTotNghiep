import 'package:flutter/material.dart';
import 'package:nloffice_hrm/repository/decisions_repo.dart';

class DecisionsViewModel extends ChangeNotifier {
  final DecisionsRepository repository = DecisionsRepository();

  bool fetchingData = false;

  
}
