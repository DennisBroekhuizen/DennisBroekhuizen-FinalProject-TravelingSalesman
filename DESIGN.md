# Dennis Broekhuizen Traveling Salesman App Design

## Advanced sketch
![alt text](https://raw.githubusercontent.com/DennisBroekhuizen/DennisBroekhuizen-FinalProject-TravelingSalesman/master/Docs/AppDesign.png)

## Utility modules, classes and functions
* Class loginViewController
  * func login: handles logging in the user

* Class registrationViewController
  * func createAccount: handles creating an account

* Class mainViewController
  * func createRoute

* Class addressesViewController
  * func addAddress: add addresses to the addressbook
  * func editAddress: edit addresses
  * func deleteAddress: delete addresses

* Class routesViewController
  * func startRoute: start created route
  * func editRoute: edit routes
  * func delete route: delete routes

## APIs
The main API that will be used is the Google Maps API and mainly sub parts of it. The Google Directions API will respond with an optimized route of given addresses by the user. The Google Places API will come in handy for verifying real existing addresses that the user meant to use. It will also provide autocomplete prediction.

Another interesting API is the KvK API for retrieving company addresses. A disadvantage to this API is that it isn't free, so it won't be used in this version of the app. The Google Places API is a good alternative.

## Database tables and fields
Firebase will be used to store several information of the user. When someone is using the app for the first time, they will be asked to create an account. Users can store addresses and routes in the database. The idea is that users can share this information with other users if they allow them to. In the future it will also be possible to share your current location with other users of a route you have started.

The table that will be included in the database will be:
* Users
  * User (Unique identifier)
    * Saved addresses
      * Unique address
    * Created routes
      * Route name
        * Start point
        * Addresses in route
    * Started route
      * Current location
        * Date
      * Route progress
        * Places
          * visited/unvisited
