import 'package:flutter/foundation.dart' show immutable;
import 'package:rx_dart/views/current_view.dart';
import 'package:rxdart/rxdart.dart';

@immutable
class ViewsBloc {
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  void dispose() {
    goToView.close();
  }

  const ViewsBloc._({
    required this.currentView,
    required this.goToView,
  });

  factory ViewsBloc() {
    final goToView = BehaviorSubject<CurrentView>();

    return ViewsBloc._(
      currentView: goToView.startWith(
        CurrentView.login,
      ),
      goToView: goToView.sink,
    );
  }
}
