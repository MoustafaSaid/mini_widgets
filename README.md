# mini_widgets

A mini Flutter app showcasing a widget catalog with several lesser-known, but highly useful, widgets. The home screen lists demo entries and navigates to focused examples.

## Run the app

```bash
flutter run
```

Then on the home screen, tap any item to open its demo.

## Featured widgets and what they do

### InteractiveViewer
Pannable and zoomable container for its child. Great for images, diagrams, and custom canvases.
- In this demo: An oversized custom-painted grid with a `FlutterLogo` in the center.
- Interactions: Pinch to zoom, drag to pan.
- Key props used: `minScale`, `maxScale`, `boundaryMargin`.

### DraggableScrollableSheet
A bottom sheet that users can drag to expand or collapse within defined size bounds.
- In this demo: A music-style “Recently Played” sheet with a handle, header, and a scrollable list.
- Interactions: Drag the sheet up/down; scroll the list inside.
- Key props used: `initialChildSize`, `minChildSize`, `maxChildSize`.

### ListWheelScrollView
A cylindrical, 3D wheel-like list. Useful for pickers or compact lists with a distinctive feel.
- In this demo: Cards displayed on a wheel with fixed item extent.
- Interactions: Flick/scroll to move through items; snapping due to `FixedExtentScrollPhysics`.
- Key props used: `itemExtent`, `diameterRatio`, `perspective`.

### ClipPath with CustomClipper
Clips its child to any path you define. Enables custom shapes for cards, tickets, headers, etc.
- In this demo: Two shapes — a “ticket” with side notches and a wavy-top card.
- Implementation: Two `CustomClipper<Path>` classes return the clip shapes used by `ClipPath`.

## Navigation
The catalog home builds a simple list of demos. Tapping a list tile pushes a new page with the corresponding widget example.

## Notes
- The draggable sheet content is rendered as a single `ListView` (with header rows) to avoid overflow in compact sizes.
- The app uses Material 3 theming with an indigo seed color.
