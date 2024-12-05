# music-app

Build an application about music as Spotify

## Requirements

1. Docker
2. Python
3. Flutter

First of all, we need to set up database postgres for app by running

```
docker-compose up -d
```

## Client

This is flutter app, so it requires Flutter setup
Link: [Flutter Setting](https://docs.flutter.dev/get-started/install)

Source is following standard MVC with structure

```
lib
    |-- cores
        |--themes
            |--app_pallete.dart
            |--theme.dart
        |--app.dart
    |-- features
        |--auth
            |--controllers
            |--screens
            |--widgets
            |--models
            |--repositories
    |-- utils
    |-- main.dart
```

## Server

This is python backend
