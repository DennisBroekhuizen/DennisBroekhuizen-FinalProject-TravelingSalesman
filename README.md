# Dennis Broekhuizen Travlr: Traveling Salesman App

[![BCH compliance](https://bettercodehub.com/edge/badge/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman?branch=master)](https://bettercodehub.com/) ![alttext](https://camo.githubusercontent.com/d3df899a102b55da861042ec3f6452e2f430f71b/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f53776966742d342e302d6565346633372e737667) ![alttext](https://camo.githubusercontent.com/a6f9d213bbc7fa752252b25d0b07ce1b3122a6ae/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f706c6174666f726d732d694f532d3333333333332e737667) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

![alttext](https://raw.githubusercontent.com/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman/master/Docs/AppTitle.png)

## Problem statement
The traveling salesman problem is a problem that hasn't been solved in the mobile world, in a good way yet, in my opinion. People who travel a lot and need to visit more then two addresses a day, have to plan their route in an efficient way. The more addresses you add, the more complex the problem becomes. So when someone has to visit 10 addresses a day, it comes in use to let a computer solve their problem and returns the most efficient route. Also people who are planning a roadtrip and would like to visit a certain amount of places, have the same problem to solve.

## Screenshots final app
![Alttext](https://raw.githubusercontent.com/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman/master/Docs/AppOverview.png)

## Solution
The solution to the described problem is a clear app that let's a user input the addresses they want to visit, choose a starting point and show them the most efficient order of addresses to visit.

### Visual sketch
![alt text](https://raw.githubusercontent.com/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman/master/Docs/TravelingSalesmanApp.png)

### Main features
The user must be able to:
* Create, save and edit route
  * Add addresses to plan a route
  * Save favorite addresses
  * Import addresses from contacts on phone
  * Import multiple addresses from a customer base or file
  * Save routes
  * Save routes on a calander, so the user can plan routes for every day of the week or month and find them back easily by selecting a day
  * Edit routes, so addresses can be added or deleted to a route

* Travel with an ordered efficient route
  * Select a route to start traveling
  * Export two adresses from the route to Google Maps or Apple Maps app to start navigation

* Share addresses and routes between colleagues, family and friends
  * Companies can create a list of addresses of their customers to share with their employees. Employees can start right away with the app without adding addresses of customers.

* Share live location or update your current location with other users
  * Share your location so a boss can see where their employees are
  * Share your location so family and friends can see where you are while road tripping

### Minimum viable product
* Add addresses to plan a route
* Save routes to a calander (Skipped in consultation with Martijn)
* Travel with an ordered efficient route by exporting the route to Google Maps or Apple Maps
* When the route is started by the user, show checkmarks at visited places by checking a users current location when reopening the app. Resume the journey by picking the last checkmarked place and the next place in the list.

### Optional features
* Import addresses contacts or a file
* Save routes on a calander
* Share addresses
* Share live location

## Prerequisites

### Data sources
[Google Directions API](https://developers.google.com/maps/documentation/directions/intro#Waypoints)

### External components
[Firebase](https://firebase.google.com/) to save and share information

### Similar apps
[Route Maker](https://itunes.apple.com/nl/app/route-maker-route-planner/id966111128?mt=8):
App that let's you create routes and optimize them. Disadvantage: can't export route to a navigation app. Can't save routes to a calander for easy use as a businessman.

[Webiste optimap](http://www.gebweb.net/optimap/):
Online simular solution. Hard to use on mobile phones. Only can save routes as a link.

### Hardest parts
Share live location and give specific users permission to see chosen information, like lists of addresses of customers of a given company.

## Sources of external code, images and font

### Code
* Search controller tutorial by [Tom Elliott](https://www.raywenderlich.com/157864/uisearchcontroller-tutorial-getting-started)
* UIAlert with delay from Stack Overflow by [ronatory](https://stackoverflow.com/questions/27613926/dismiss-uialertview-after-5-seconds-swift)
* Get Users Location GPS Coordinates tutorial by [Andrew](http://www.seemuapps.com/swift-get-users-location-gps-coordinates)
* Looked into Geofencing by [Federico Nieto](https://medium.com/lateral-view/geofences-how-to-implement-virtual-boundaries-in-the-real-world-f3fc4a659d40)

### Images
* Tab bar icons by [Icons8](https://icons8.com/ios) under the '[Good Boy License](https://icons8.com/good-boy-license/)'
* App icon by [Font Awesome](https://fontawesome.com/icons) under the '[Font Awesome Free](https://fontawesome.com/license)' license

### Font
* Arciform Typeface by [Matt Ellis](https://www.behance.net/gallery/30453085/Arciform-Free-Typeface) free to use for personal and commercial projects

## License
This project is available under the MIT License. For more information see the full [LICENSE](https://github.com/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman/blob/master/LICENSE).
