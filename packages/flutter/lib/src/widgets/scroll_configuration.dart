// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'framework.dart';
import 'scroll_behavior.dart';

class ScrollConfigurationDelegate {
  /// Returns the ScrollBehavior to be used by generic scrolling containers like
  /// [Block]. Returns a new [OverscrollWhenScrollableBehavior] by default.
  ExtentScrollBehavior createScrollBehavior() => new OverscrollWhenScrollableBehavior();

  /// Generic scrolling containers like [Block] will apply this function to the
  /// Scrollable they create. It can be used to add widgets that wrap the
  /// Scrollable, like scrollbars or overscroll indicators. By default the
  /// [scrollWidget] parameter is returned unchanged.
  Widget wrapScrollWidget(Widget scrollWidget) => scrollWidget;

  /// Overrides should return true if the this ScrollConfigurationDelegate has
  /// changed in a way that requires rebuilding its scrolling container descendants.
  /// Returns false by default.
  bool updateShouldNotify(ScrollConfigurationDelegate old) => false;
}

/// Used by descendants to initialize and wrap the [Scrollable] widgets
/// they create.
///
/// Classes that create Scrollables are not required to depend on this
/// Widget. The following general purpose scrolling widgets do depend
/// on ScrollConfiguration: Block, LazyBlock, ScrollableViewport,
/// ScrollableList, ScrollableLazyList. The Scrollable base class uses
/// ScrollConfiguration to create its [ScrollBehavior].
class ScrollConfiguration extends InheritedWidget {
  ScrollConfiguration({
    Key key,
    this.delegate,
    Widget child
  }) : super(key: key, child: child);

  static final ScrollConfigurationDelegate _defaultDelegate = new ScrollConfigurationDelegate();

  /// Defines the ScrollBehavior and scrollable wrapper for descendants.
  final ScrollConfigurationDelegate delegate;

  /// The delegate property of the closest instance of this class that encloses
  /// the given context.
  ///
  /// If no such instance exists, returns an instance of the
  /// [ScrollConfigurationDelegate] base class.
  static ScrollConfigurationDelegate of(BuildContext context) {
    ScrollConfiguration configuration = context.inheritFromWidgetOfExactType(ScrollConfiguration);
    return configuration?.delegate ?? _defaultDelegate;
  }

  /// A utility function that calls [ScrollConfigurationDelegate.wrapScrollWidget].
  static Widget wrap(BuildContext context, Widget scrollWidget) {
    return of(context).wrapScrollWidget(scrollWidget);
  }

  @override
  bool updateShouldNotify(ScrollConfiguration old) {
    return delegate?.updateShouldNotify(old.delegate) ?? false;
  }
}
