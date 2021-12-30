#  BeerBox App

## Instructions to Run App
- Launch 'pod install' from a Terminal, in the root folder of the project where the Podfile is placed.
- Run the app from Simulator or Device.


## Stack
- UI: SwiftUI
- Reactive Framework: Combine
- Architecture: Standard Clean Architecture
- Dependencies Injection: (to guarantee Dependency Inversion) Using Swinject Library
- Networking: Alamofire


## Possible future improvements
- Implement a more complex Detail page, where to find all the informations provided by the API.
- Add more filter options.
- Add some nice transition animation tapping on an element of the list.
- Improve the error management and the feedback to the user when occurs.
- Introduce a kind of caching strategy to reduce the number of API calls.
- Indroduce a proper Routing solution, for the navigation in the app.


## Known Issues
- Sometimes the images are not properly loaded between searches (probably the library CachedAsyncImage is not properly handling the updates).
- On detail view appear, the image is not moving together with the other views, but appears with a fade. Even though, the effect is not bad.

## Final Thoughts

With more time, i would like to extend this app with new functionalities and experiment more 
the potential of an architecture based on this brand new stack (SwiftUI + Combine), 
especially when it comes to transitions and animations which are really cool and "easy" to 
implement, considering the past on UIKit.


