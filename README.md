# Dennis Broekhuizen Traveling Salesman App

## Problem statement
The traveling salesman problem is a problem that hasn't been solved in the mobile world, in a good way yet, in my opinion. People who travel a lot and need to visit more then two addresses a day, have to plan their route in an efficient way. The more addresses you add, the more complex the problem becomes. So when someone has to visit 10 addresses a day, it comes in use to let a computer solve their problem and returns the most efficient route. Also people who are planning a roadtrip and would like to visit a certain amount of places, have the same problem to solve.

## Solution
The solution to the described problem is a clear app that let's a user input the addresses they want to visit, choose a starting point and show them the most efficient order of addresses to visit.

### Visual sketch


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
* Save routes to a calander
* Travel with an ordered efficient route by exporting the route to Google Maps or Apple Maps

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
