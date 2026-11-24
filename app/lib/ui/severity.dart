// The colors of each severity and state vocabulary, one function per
// vocabulary so their names never clash.
import 'package:flutter/material.dart';

import 'theme.dart';

/// A map finding: high, medium, low, accepted.
Color findingColor(DeckColors c, String severity) => switch (severity) {
  'high' => c.red,
  'medium' => c.orange,
  'low' => c.indigo,
  _ => c.graphite,
};

/// A review thread: must-fix, suggestion, question.
Color threadColor(DeckColors c, String severity) => switch (severity) {
  'must-fix' => c.red,
  'suggestion' => c.orange,
  'question' => c.blue,
  _ => c.graphite,
};

/// A ticket check or a review verdict.
Color checkColor(DeckColors c, String state) => switch (state) {
  'ok' || 'done' || 'fulfilled' => c.green,
  'concern' || 'missing' || 'not_addressed' => c.red,
  'partial' || 'extra' => c.orange,
  _ => c.graphite,
};
