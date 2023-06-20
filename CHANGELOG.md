## 1.0.0
* **BRAKING CHORE**: Added `Event` positional parameter to `action()` callback in `BlocEventHandlerMixin.handleEvent()`
  
  Before:
  ```dart
  handleEvent<Event, ActionResultType>(
      // ... other parameters
      action: () async {
        // ...
      },
    );
  ```
  Now:
  ```dart
  handleEvent<Event, ActionResultType>(
      // ... other parameters
      action: (event) async {
        // ...
      },
    );
  ```
