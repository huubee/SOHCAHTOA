# Blueprint: SOH CAH TOA Visual Calculator

## Overview

This document outlines the plan for creating a Flutter application that serves as a visual calculator for trigonometry, specifically focusing on the SOH CAH TOA rules for right-angled triangles. The app will be multi-lingual, themeable, and provide an intuitive user experience.

## Features

### Core Functionality
- **Visual Triangle:** Display a clear, interactive right-angled triangle.
- **Input:** Allow users to tap on a side (Opposite, Adjacent, Hypotenuse) or an angle to input its value.
- **Calculation:** Once two values are provided, automatically calculate and display the remaining side and angle values.
- **State Management:** Use the `riverpod` package for robust state management.

### Theming
- **Color Themes:** Offer a selection of three cheerful, modern color themes.
- **Dark/Light Mode:** Full support for both light and dark modes.
- **Theme Toggle:** Allow users to easily switch between themes and modes.
- **Typography:** Use the `google_fonts` package for clean and readable typography.

### Localization
- **Multi-lingual:** Support for English, Dutch, and German from the start.

### Code Quality
- **File Size:** Keep the app and its assets optimized for size.
- **Refactoring:** Maintain a clean codebase by refactoring duplicate code.
- **Constants:** Use constant files for managing themes, strings, and other static values.

## Current Plan

### Iteration 1: Project Setup and Theming (Complete)

1.  **Dependencies:** Added `riverpod` and `google_fonts` to `pubspec.yaml`.
2.  **Localization Setup:** Added `flutter_localizations` and configured the project for English, Dutch, and German.
3.  **Project Structure:** Created a structured directory layout for features, theming, localization, and constants.
4.  **ThemeProvider:** Implemented a `ThemeProvider` using `riverpod` to manage theme state (color scheme and light/dark mode).
5.  **Main App:** Set up the main `MaterialApp` to consume the `ThemeProvider` and localization delegates.
6.  **Theme Constants:** Defined the color palettes for the cheerful themes in a constants file.
7.  **Basic UI:** Created a home page with a simple layout and a theme switcher to test the theme implementation.

### Iteration 2: Trigonometry Calculator UI (Complete)

1.  **Triangle Widget:** Created a custom widget to draw the right-angled triangle.
2.  **Input Fields:** Added input fields for the sides and angles of the triangle.
3.  **Layout:** Arranged the triangle widget and input fields in a user-friendly layout.
4.  **State Management:** Implemented a `TrigonometryProvider` using `riverpod` to manage the calculator's state.
5.  **UI-State Connection:** Connected the UI to the `TrigonometryProvider` to enable real-time calculations and updates.

### Iteration 3: Bug Fixing and Clear Button

1.  **Bug Squashing:** Thoroughly test the calculator for any calculation errors or unexpected behavior.
2.  **Clear Button:** Add a 'Clear' button to reset all the input fields and the calculator's state.
