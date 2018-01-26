# Dennis Broekhuizen Process Book
Summary of important decisions made while making my final app.

# Week 1

# Day 1
* Made a prototype of my app last week. Also implemented the Google Places API with autocomplete for iOS. Users are now able to search for places, addresses and companies.
* Implemented Firebase, so users are now able to create an account and login with their username and password.
* Created a static tableView to let a user plan a route. Had a problem with adding new rows to the tableView when the user wants to add multiple destinations to their route. Made the decisions to create a dynamic tableView instead of a static tableView to solve this problem. When creating a dynamic tableView, I have to create prototype cells to create cells for the different sections I used before in my static tableView. When adding multiple destinations I can make use of these prototype cells multiple times.

# Day 2
* Recreated the tableViewController to plan a route from a static tableView to a dynamic tableView. Users are now able to plan a route with multiple destinations. Starting point and destinations can be found with the Google Places API.

# Day 3
* Added a results tableView where users can see their optimized route after they planned it. Updated some layout parts.
* Users are able to delete chosen destinations from the tableview.

# Day 4
* Able to parse the starting point and destinations of the route between the two view controllers. Haven't found out how to parse the typed name from the UITextfield and date yet.
* Found an interesting library to implement a calendar into my app named FSCalendar. Already implemented it.

# Day 5
* Started looking into the Google Distance API this morning. Came to the conclusion that it's not easy to implement this API into my app. To solve this problem I searched for some solutions online. Found some interesting libraries which can be installed with CocoaPods. I tried to install one of them, but got a lot of errors right after it. Uninstalled it for this reason. I think I have to implement it myself.
* Moved one with another part of my app: the contacts list. Users can now store their favorite addresses. Only have to arrange the possibility to choose these contacts from the planning screen. Used Firebase to store the contacts, so users can hopefully share their contacts in an easy with other users in the future.

# Week 2

# Day 1
* Able to optimize routes with Google Directions API.
* Able to save routes to Firebase and show them in the TravelViewController.
* Able to 'start' a route by saving current route to Firebase.
* Able to search for contacts in the ContactsViewController.
* Started implementing MapKit as an alternative to Google Places API because of the limitations of maximum requests of Google Places API.
* Also able to search for saved contacts in this ViewContoller, but is still buggy.

# Day 2
* Optimized routes are now shown correctly in OptimizeRouteViewController.
* Routes can be started correctly, by showing them in CurrentRouteViewController.
* Addresses in route can be opened in Apple Maps, by selecting a row in tableView.
* Started looking into checking a users current location and comparing it to the addresses in current route. Still a difficult function to implement.

# Day 3
* Able to check current location with addresses in started route while viewing the started route screen. When a user is 100 meters from an address in the route, it will show a checkmark at the given address. To check the addresses with the current location of a user, I had to convert the addresses to coordinates. Tried this with a build in function, which coverts addresses to CLLocation. The problem with this function is that it's an asynchronic function. The function didn't solve my problem as quick as I needed it and I ended up with an empty array, without any coordinates. After that I tried to store the CLLocation of the addresses to Firebase when the user requests the addresses. This also caused some problems, so I finally saved the coordinates as a string to Firebase. In the started route screen, I convert these coordinate strings to an array of CLLocations. After that I was finally able to check a users current location with the addresses in the route.

# Day 4
* Fixed some bugs which caused my app to crash. For example: it's now required to fill in all fields in the planning screen, because when the optimize screen is missing some information it will crash the app. I also safely unwrapped some variables which also caused some problems sometimes.
* Found out that it's not allowed to store forward slashes into Firebase keys. This happened when I used my app in the simulator, when storing the date as a key to firebase. The dateFormatter converted the date into a string with forward slashes because of the device language. Fixed it by setting the dateFormatter locale to nl_Nl. This will always convert a date to a string with dashes, which is allowed in a Firebase key.
