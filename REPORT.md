# Dennis Broekhuizen Report Travlr

## Short description of the App

<table>
  <tr>
    <td rowspan="2">
       Travlr is a route planner app that tries to solve the traveling salesman problem (TSP) as good as possible. Users of the app can input a maximum of 23 waypoints they want to visit, including a starting point and an end point. Travlr will rearrange the waypoints in an efficient order, so users doesn't have to crack their brains about the TSP.
    </td>
  </tr>
  <tr>
    <td>
       <img src="https://raw.githubusercontent.com/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman/master/Docs/2.%20PlanRouteViewController.png" width="300">
    </td>
  </tr>
</table>

## Description of the functionalities

### High level overview
After creating an account to Travlr, which will be stored in Firebase, users can start planning routes with locations of their choice. Locations can be selected from their saved contacts or the Google Places API. Favorite contacts can be added from the contacts tab in the app, which will also be stored in Firebase.

Chosen locations in the route have to be in such a distance from each other, that it is possible to travel by car. After inputting all required information, the route can be optimized with the help of Google Directions API. Once the route is optimized, users can save the route in Firebase and start traveling. After starting the route, the app will compare the current location of the user with the waypoints in their route. Once a waypoint is reached, a checkmark will appear behind the given waypoint. When users don't know how to travel to one of the locations in the route, they can select and open the location in Apple Maps, which will provide navigation instructions.

### Classes
A short description of all classes used in the app.

#### LoginViewController
The first class and also screen that the user will use and see, is the LoginViewController. This class handles logging the user in to Firebase and will perform a segue to the PlanRouteViewController after they logged in successfully. If the user doesn't have an account already, they have the option to choose 'register' at the bottom of the view. The register button will perform a segue to the RegisterViewController.

#### RegisterViewController
The RegisterViewController handles registering users to Firebase. After they have chosen a valid e-mail and password, users will be logged in automatically and the app performs a segue to the PlanRouteViewController. With an account users are able to save favorite contacts and planned route to Firebase.

#### ContactsViewController
The ContactsViewController requests all saved contacts of a user from Firebase if they have and will show them. In the upper right corner, users can press a 'plus' button, which will perform a segue to AddContactsViewController. In the ContactsViewController users can also delete contacts by swiping to the left at a given contact in a table view row. This will delete the user from Firebase and the table view. Users a also able to search for contacts by swiping down the view. This will show an UISearchController.

#### AddContactsViewController
In the AddContactsViewController users can add new contacts to Firebase. They have to choose a name and an address for the new contact. After pressing 'Add address' a segue will be performed to the Google Places Autocomplete API functionality. In this view users can search for locations all over the world. With the use of this functionality I can make sure users can only use legit locations. After selecting the location an unwind segue will be performed back to the AddContactsViewController. The location is now visible in the table view and the user can save the contact. When pressing the save button, the name, address and address coordinates will be stored to Firebase. The address coordinates will be used in the CurrentRouteViewController, to check a users current location with the address, if they did choose the address in the route.

#### PlanRouteViewController
The PlanRouteViewController is the most important class of the app. Without the possibility to plan a route, the app would be useless. To plan a route users have to input a route name, date they want to travel with the route, starting point, minimum of one waypoint and an end point. The route name can be submitted with a UITextField. The date can be chosen with an UIDatePicker. Locations can be selected with the SearchViewController. A segue to this view controller will be performed after selecting a 'choose location' row in the table view. After selecting a location in the SearchViewController, the location will be visible in the PlanRouteViewController. Starting point and end point can be changed by reselecting the given table view row. Waypoint can be deleted from the route by swiping left at a given row. After filling in all fields and pressing the 'Plan Route' button, a segue will be performed to the OptimizeRouteViewController. All inputted data including waypoint coordinates will be passed with this segue.

From this view controller users are also able to logout and see some little instruction about the app, by pressing the buttons in the navigation bar.

#### SearchViewController
In the SearchViewController users can search and select locations from their saved contacts in Firebase or the Google Places Autocomplete API. Switching between these two is possible with an UISegmentedControl. After selecting a location an unwind segue is performed back to the PlanRouteViewController. The address and address coordinates will be passed with this segue.

#### OptimizeRouteViewController
The OptimizeRouteViewController is also an important class of the app. It will solve the traveling salesman problem for the user. This by calling the DirectionsDataController. The DirectionsDataController will perform an API request to the Google Directions API. If the request with inputted locations is valid, the user will see changes of the order of inputted waypoints. Now the user is able to save their route to Firebase. If the route can't be optimized, the user also isn't able to save their route to Firebase. Routes can't be optimized if inputted locations can't be traveled by car or the inputted locations are containing illegal characters, such as Chinese or Arabic characters, in their address rule. In the first situation the API will give a 'Zero Results'. In the second situation the created URL is invalid, because illegal characters aren't escaped from the URL, so the API request can't be performed.

#### DirectionsDataController
The DirectionsDataController class creates and performs the URL with the users inputted locations to the Google Directions API. Using URL's with specific characters is really limited, so the class escapes most of the illegal characters. Think about replacing a 'space' with '%20', but also pipelines with '%7C' and accented characters with normal characters. Chinese and Arabic characters are out of scope as explained. When the URL can't be requested the data controller will give back an completion nil to the user. The app will show an error message to the user.

#### TravelViewController
In the TravelViewController saved routes to Firebase will be requested and visible. Routes a ordered by date. By selecting a route, a segue will be performed to RouteDetailViewController with all the information requested from Firebase about that route. Users are also able to delete routes from Firebase and the table view by swiping left at a table view row.

#### RouteDetailViewController
The RouteDetailViewController will show all the details of inputted information about a route. Users can choose to start a route by pressing the 'Start' button in the upper right corner. When pressing the button, the route will be saved to Firebase as an users 'current route'. (Implemented because users can share their current route with other users in the future in an easy way). After saving the route to Firebase, a segue will be performed to the last screen CurrentRouteViewController.

#### CurrentRouteViewController
The CurrentRouteViewController is the class and view that handles traveling with the selected route. When the route is started, a table view with the starting point, waypoint(s) and end point is visible. The view will be presented modally. This will hiding the tab bar, so users can't use the app in a normal way while traveling. Users have the possibility to select a location and open it with Apple Maps. In this way people are able to navigate between locations. Another cool feature of this view controller is checking the users current location with waypoints in the route. When a user is near a waypoint, the location will be checkmarked as visited, by showing a checkmark in the table view. To allow this feature to work, the user has to view this view controller, because only then the location will constantly be checked. So when a users chooses to open a location in Apple Maps, the have to switch back to Travlr when they have reached their location. This will mostly always happen, because when the user resumes their route, the also reopen the app. Starting point and end point won't be checked with the current location of the user, because that isn't that interesting. To stop a route, users have to press the left top button. The app will stop tracking the current location of the user and users can start using the app in a normal way again.

### Models
A short description of the models used in the app.

#### Route struct
Struct of a route, to send routes between view controllers and save & retrieve routes from Firebase.

#### Directions data struct
Structure used for storing elements from Google Directions API.

#### Contacts struct
Structure used to store and retrieve contacts from database.

### Data sources
* Google Places API: Autocomplete iOS
* Google Directions API
* Firebase

## Challenges during development and changes

### Challenges
While developing the app there were some challenges that didn't go as planned:
* Created a static table view at first to plan a route with different sections, but had to add dynamic cells in a specific section for multiple waypoints in the route. It wasn't possible to arrange this, so I had to change the static table view to an dynamic table view with custom prototype cells.

* In static table views it's much easier to pass data from an UITextField to the next ViewController. In my dynamic table view I had a problem by passing a user typed in route name to the next view controller. The chosen route date was also a similar little challenge. Not the biggest challenge during development, but had some issues. In the final week I also discovered a bug with these cells. These cells are the top cells of my table view, below that users can see their chosen waypoint and a 'Plan Route' button. When adding multiple waypoints, the top cell are being dequeued, which means the app unexpectedly found nil while unwrapping the UITextField and Data label placeholders. Solved this by immediately saving these values to a variable after editing.

* To make my MVP a little bit more complex I decided to let a users save routes at a specific date, so they could select the route via a calendar in the TravelViewController. This feature was harder to implement as I thought it would be. I found a really nice library named 'FSCalendar' to show a calendar in my app. Really easy to show this calendar in my app, but a little bit harder to link saved routes to the calendar and show them at the planned date. Because I also had some other big functionalities I really had to implement for my MVP, I decided in consultation with Martijn to skip this feature and delete it from my MVP. Instead of this feature show all saved routes of a user in the TravelViewController with name and date of a route. Routes are order by date, so users can find back their route in an easy way aswell.

* In the CurrentRouteViewController I decided to show checkmarks at already visited waypoints of a route. To make this possible the app needs to check a users current location with the given waypoints of the route. The problem that occurred during the development of this functionality is that I didn't saved the coordinates of the waypoints to Firebase at first, but only the address names. In the CurrentRouteViewController I had to find a solution to convert these address names to latitude and longitude coordinates, only then it would be possible to check the waypoints with a users current location. I tried multiple ways to geocode the locations, but mostly none of them worked. For example I tried working with a standard function of Apple called 'geocodeAddressString'. This would cause delay in my app, because it's an asynchronous function. I wasn't able to save these coordinates to an array at the time I needed them. At this point I decided to rewrite some parts of my app and immediately save coordinates to Firebase. It turned out that it wasn't possible to save CLLocation to Firebase, so it had to save my coordinates as a string. Finally could request the coordinates in the CurrentRouteViewController, but had to convert the coordinates from a string to an array of CLLocations. Now the app can check the current location with the waypoints CLLocations.

* During one of my last days of development I discovered a bug with creating URL's for my Google Directions API request. It turned out that it wasn't possible to let an URL contain special characters, such as accented characters. Solved the bug by escaping these characters, but then tried out Chinese characters and found out it would also crash my app. Because of the time that I had left, I decided not to include locations with illegal characters such as Chinese characters and just show the user an alert message.

### Changes
* Users can't select a route from a calendar as described, but instead of that can see their routes is a list ordered by date.
* Users can't plan routes with locations that contain illegal characters such as Chinese or Arabic characters.

## Future development
If I had much more time, I would have made the much more like a social media app. Users then could show users they follow their current location of the current route their traveling with. It would also be possible to share addresses with other users, such as address book of companies with their customers. In this way traveling salesman would be enlightened while planning their routes. (Some of the functionalities I described beside my MVP.) Overall I'm happy with the result that I accomplished in the time that I had.
