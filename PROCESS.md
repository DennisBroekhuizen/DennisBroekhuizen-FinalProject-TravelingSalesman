# Dennis Broekhuizen Process Book
Summary of important decisions made while making my final app.

# Day 1
* Made a prototype of my app last week. Also implemented the Google Places API with autocomplete for iOS. Users are now able to search for places, addresses and companies.
* Implemented Firebase, so users are now able to create an account and login with their username and password.
* Created a static tableView to let a user plan a route. Had a problem with adding new rows to the tableView when the user wants to add multiple destinations to their route. Made the decisions to create a dynamic tableView instead of a static tableView to solve this problem. When creating a dynamic tableView, I have to create prototype cells to create cells for the different sections I used before in my static tableView. When adding multiple destinations I can make use of these prototype cells multiple times.

# Day 2
* Recreated the tableViewController to plan a route from a static tableView to a dynamic tableView. Users a now able to plan a route with multiple destinations. Starting point and destinations can be found with the Google Places API.
