import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:hello_me2/authentication.dart';
import 'package:provider/provider.dart';


class DefaultGrabbing extends StatefulWidget {
  final SnappingSheetController snappingSheetController;

  const DefaultGrabbing({Key? key,
    required this.snappingSheetController}) : super(key: key);

  @override
  State<DefaultGrabbing> createState() => _DefaultGrabbingState(snappingSheetController);
}

class _DefaultGrabbingState extends State<DefaultGrabbing> {
  final SnappingSheetController snappingSheetController;

  _DefaultGrabbingState(this.snappingSheetController);
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthRepository>(builder: (context, authRepository, child) {
      return Consumer<ProfileSheet>(builder: (context, profileSheet, child) {
        return GestureDetector(
            onVerticalDragStart: (details) {
              setState(() {
                if ( profileSheet.isDragged && profileSheet.snappingSheetOpen || snappingSheetController.currentPosition > 0.5 * MediaQuery.of(context).size.height) {
                  snappingSheetController.snapToPosition(
                    const SnappingPosition.factor(
                      positionFactor: 0.20,
                      grabbingContentOffset: GrabbingContentOffset.top,
                    )
                    ,);
                  profileSheet.changeDrag(false);
                  // profileSheet.changeSnappingSheet(false);
                } else{
                  snappingSheetController.snapToPosition(
                    const SnappingPosition.factor(
                      grabbingContentOffset: GrabbingContentOffset.bottom,
                      positionFactor: 0.8,)
                    ,);
                  profileSheet.changeDrag(true);
                  profileSheet.changeSnappingSheet(true);
                }
              });
            },
            onTap: () {
              setState(() {
                profileSheet.changeSnappingSheet(!profileSheet.snappingSheetOpen);
                if (profileSheet.snappingSheetOpen){
                  snappingSheetController.snapToPosition(
                      const SnappingPosition.factor(
                        grabbingContentOffset: GrabbingContentOffset.bottom,
                        snappingDuration: Duration(seconds: 1),
                        positionFactor: 0.25,
                      )
                  );
                } else {
                  snappingSheetController.snapToPosition(
                      const SnappingPosition.factor(
                        positionFactor: 0.0,
                        snappingDuration: Duration(seconds: 1),
                        grabbingContentOffset: GrabbingContentOffset.top,
                      ));
                }
              });
            },
            child: _GrabbingIndicator(authRepository: authRepository)
        );
      });
    });
  }

}

class _GrabbingIndicator extends StatelessWidget {
  final AuthRepository? authRepository;

  const _GrabbingIndicator({Key? key, this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        color: Colors.grey[300],
        height: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Welcome back, ${authRepository?.user?.email}',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Icon(Icons.keyboard_arrow_up),
            ),
          ],
        ),
      );
  }
}

class ProfileSheet extends ChangeNotifier {
  bool _snappingSheetOpen = false;
  bool _isDragged = false;

  ProfileSheet();

  bool get snappingSheetOpen => _snappingSheetOpen;
  bool get isDragged => _isDragged;

  void changeSnappingSheet(bool value){
    _snappingSheetOpen = value;
    notifyListeners();
  }
  void changeDrag(bool value){
    _isDragged = value;
    notifyListeners();
  }
}