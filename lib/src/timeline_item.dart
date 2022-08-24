import 'dart:math';

import 'package:flutter/material.dart';
import 'package:timeline_list/src/timeline_painter.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

abstract class TimelineItem extends StatelessWidget {
  final TimelineModel model;
  final TimelineProperties properties;

  const TimelineItem({Key? key, required this.model, required this.properties}) : super(key: key);

  double get iconSize {
    return 20.0;
  }

  dynamic get icon {
    if (this is TimelineItemCenter) return model.icon;
    // ignore icon size if timeline is not centered.
    return model.icon;
  }
}

class TimelineItemCenter extends TimelineItem {
  // https://github.com/dart-lang/sdk/issues/29395
  const TimelineItemCenter({Key? key, required model, required properties, isFirst, isLast})
      : super(model: model, properties: properties, key: key);

  AlignmentGeometry get position {
    switch (model.position) {
      case TimelineItemPosition.left:
        return Alignment.centerLeft;
      case TimelineItemPosition.right:
        return Alignment.centerRight;
      case TimelineItemPosition.random:
      default:
        return Random().nextBool()
            ? Alignment.centerLeft
            : Alignment.centerRight;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) => Container(
            decoration: TimelineBoxDecoration(
                isFirst: model.isFirst,
                isLast: model.isLast,
                iconSize: iconSize,
                iconBackground: model.iconBackground,
                properties: properties,
                timelinePosition: TimelinePosition.Center),
            child: Stack(
              alignment: position,
              children: <Widget>[
                Container(
                    constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth / 2 -
                            iconSize / 2.0 -
                            TimelineBoxDecoration.LINE_GAP * 2.0,
                        minHeight:
                            iconSize + TimelineBoxDecoration.LINE_GAP * 2),
                    child: model.child),
                Center(child: icon),
              ],
            )));
  }
}

class TimelineItemLeft extends TimelineItem {
  const TimelineItemLeft({Key? key, required model, required properties, isFirst, isLast})
      : super(model: model, properties: properties, key: key);

  @override
  Widget build(BuildContext context) {
    final margin = properties.iconSize + TimelineBoxDecoration.LINE_GAP * 2;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: TimelineBoxDecoration(
                isFirst: model.isFirst,
                isLast: model.isLast,
                iconSize: model.icon != null
                    ? properties.iconSize
                    : TimelineBoxDecoration.DEFAULT_DOT_SIZE,
                iconBackground: model.iconBackground,
                properties: properties,
                timelinePosition: TimelinePosition.Left,
              ),
              width: properties.iconSize + 24,
              alignment: Alignment.center,
              child: icon,
            ),
            Container(
                padding: const EdgeInsets.only(
                    left: TimelineBoxDecoration.LINE_GAP),
                constraints: BoxConstraints(
                    minHeight: margin,
                    maxWidth: constraints.maxWidth - margin * 2.0),
                child: model.child),
          ],
        );
      },
    );
  }
}

class TimelineItemRight extends TimelineItem {
  const TimelineItemRight({Key? key, required model, required properties, isFirst, isLast})
      : super(model: model, properties: properties, key: key);

  @override
  Widget build(BuildContext context) {
    final margin = properties.iconSize + TimelineBoxDecoration.LINE_GAP * 2;
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              padding:
                  const EdgeInsets.only(right: TimelineBoxDecoration.LINE_GAP),
              constraints: BoxConstraints(
                  minHeight: margin,
                  maxWidth: constraints.maxWidth - margin * 2.0),
              child: model.child),
          Container(
              decoration: TimelineBoxDecoration(
                  isFirst: model.isFirst,
                  isLast: model.isLast,
                  iconSize: model.icon != null
                      ? properties.iconSize
                      : TimelineBoxDecoration.DEFAULT_DOT_SIZE,
                  iconBackground: model.iconBackground,
                  properties: properties,
                  timelinePosition: TimelinePosition.Right),
              width: properties.iconSize + 24,
              alignment: Alignment.center,
              child: icon),
        ],
      );
    });
  }
}
