# Wire Frame

The wireframe has been developed so that an iOS developer can sit with a Project Manager or customer and create a simple navigationable application that reflects the customers requirements.

The wireframe allows for you to create views with a navigation bar that contains your icons or text, that will then open a new screen based upon the target page provided.

The wireframe, allows for you to create quick lists of data.

## Basic Installation

## Basic Usage

The `Wireframe` within the  `JSONWireframe` project reads from the `wireframe.json` json file that is located by the `AppDelegate.swift` file.

For the application to open without any fatal errors being throw, its requires a json object to be present within the file containing the following 3 keys: `appName`, `root` and `route`.

> `appName` - `string` - (required)

The `appName` is an arbitury name that indicates which wireframe this json file is handling. At the moment it does not have any use, but it is there for the future.

> `root`:`string` - (required)

The `root` indicates to the application which `route` is going to be used as `window`'s the `rootViewController`.

> `routes` - `array` (required)

The `routes` key, initially must contain the `root`'s route definition for the application to not crash.

> Mandatory key/value pairs.

```json
{
    "appName": "application",
    "root" , "home",
    "routes": []
}
```

># WARNING
The application will still crash at this point if you run it, because it cannot detect the `home` route.

# Route Definition

A `route` is a way of saying a `Screen`.
The presenting of `UIViewController`'s within the wireframe application is completely dependant upon it knowing about how to build the view controller and which route is responsible for it.

# Basic `route` Usage

The following keys are mandatory for the application to not crash.

> `title` is used for the application when presenting within a `UINavigation Controller`.

> `name` allows for other routes to identifier it.

```json
{
    "appName": "application",
    "root" , "home",
    "routes": [
        {
            "name": "home",
            "title": "Home"
        }
    ]
}

```

You can not run the application and you will see a completely which screen.

You notice in the `debug`log that the following information has been outputted:

```bash
"Auto Registering route: dismiss"
"Auto Registering route: pop"
"Auto Registering route: popToRoot"
"Auto Registering route: popToView"
"Registerd Route name: home"
```

The application registers some useful default routes that you can use as to complete some actions that only require for the route to be removed. I will discuss this later in the documentation.


# `route` : `type`


The routes `type` property defines the type of view controller that will be displayed.

The default is `view`. The will display a `View`. A `View` inherits `UIViewController` and contains a `route` property.

By definition, the `View` should not be used for custom view controllers within the wireframe. 

> `"type" : "navigation"`

When the `route`'s `type` value is `navigation`. The `View` will be placed within a `UINavgationController`.

```json
{
    "appName": "application",
    "root" , "home",
    "routes": [
        {
            "type" : "navigation",
            "name": "home",
            "title": "Home"
        }
    ]
}

```

# `route` : `presentationType` or `presentationStyle` (optional)


The default `presentationStyle` of a `route` is `push` unless the `type` has been set to `navigation`. 

If the `type` is `navigation` and the `presentationStyle` or `presentationType` key value pair is not defined, then it will be `present`.

```json
{
    "appName": "application",
    "root" , "home",
    "routes": [
        {
            "type" : "navigation",
            "name": "home",
            "title": "Home",
            "presentationType" : "present"
        }
    ]
}
```

> OR

```json
{
    "appName": "application",
    "root" , "home",
    "routes": [
        {
            "type" : "navigation",
            "name": "home",
            "title": "Home",
            "presentationStyle" : "present"
        }
    ]
}
```

# `route`: `subroutes` (optional)


The `wireframe` allows for you to define `route`'s with `subroutes`. This means that a `route` `present`s, or `push`es other `route`'s.

The `route` upon being created will check if it contains a `subroutes` key so that it can provide buttons for the user to tap, in order to open the `subroute`.

The `route` can contain a `subroutes` key. The `subroutes` key is an `array` of `route` name's.

Warning: The `route` name must be defined within the `routes` array. If you have forgotten to add it, the application will warn you with a pop up, and then crash.

> CRASH

```json
{
    "appName": "application",
    "root" , "home",
    "routes": [
        {
            "type" : "navigation",
            "name": "home",
            "title": "Home",
            "presentationStyle" : "present",
            "subroutes": [
                "settings"
            ]
        }
    ]
}
```

> NO CRASH

```json
{
    "appName": "application",
    "root" , "home",
    "routes": [
        {
            "type" : "navigation",
            "name": "home",
            "title": "Home",
            "presentationStyle" : "present",
            "subroutes": [
                "settings"
            ]
        },
        {
            "name" : "settings",
            "title" : "Settings"
        }
    ]
}
```






 
