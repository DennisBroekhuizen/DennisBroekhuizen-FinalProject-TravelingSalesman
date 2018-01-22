# Dennis Broekhuizen Process Book
Summary of important decisions made while making my final app.

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
