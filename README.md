# BetterSelf v1.0-tpsit
> This is just a proof of concept, it's not intended for final versions. This versions aims to showcase how the app can comunicate with a web service.

[See it in action!](https://youtu.be/UBs_O6gTeN4/)

## Server
Powered by Django Rest Framework: 
* ✅ Admin frontend to add users and workouts
* ✅ secure management of user sessions and tokens
* ✅ database tables are automatically managed

 ### API Endpoints 
 * /v1/login<br>
    - Method: POST
    - Require: authentication -> username, password via POST
    - Gets: auth token used to call other endpoints
 * /v1/workouts
    - Method: GET
    - Require: auth token via 'Authorization' header
    - Gets: all sections for the user, JSON-Formatted
 * /admin: Django admin page

## Client
* ✅ Project language: Apple Swift 5.10
* ✅ Frameworks used: SwiftUI
* ✅ Software design pattern: MVC (model - view - controller)
