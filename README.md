# movie_app

see Latest Movies , the movie details and store your favorite Movie to watched later

## Getting Started

<img src="https://github.com/liodali/TMDBMovieApp/blob/main/ios_preview_app.gif?raw=true" alt="Movie app"><br>

## Preparation for build 
* if you want to regenerate apk or rebuild the project
 follow those steps
  
### Steps)
> we have .env file that need for tmdb api which contain TMDB Server URL, API_Key

> also create another .env.test as empty file or put in it the same data as .env for testing

> the project contain generated file using build_runner, if you want to generate them inside data_package
```shell
flutter pub run build_runner build
```
##  Add Platform

> use this command to add android : `flutter create --platforms android .`

> use this command to add ios : `flutter create --platforms ios .`


## Build
* I used Flutter 3.19.5
1) Android
> flutter build appbundle --release
2) iOS
> flutter build ios --no-codesign


##### In this project, we implement the  clean architecture
* we have 3 layer:

    * <srong>lib module </string>  : This Main module contains all  the code related to the UI/Presentation layer such as widget,route,localization,and viewModel
    * <srong>Package movie_repository</string> : holds all concrete implementations of our repositories,UseCases and other data sources like  network,local Storage
    * <srong>package Data module </string>  : contain all interfaces of repositories  and  classes

> I used dio for http calls

> I used riverpod/FlutterHook for reactive UI

## testing

> you can see our testing folder in packages or our main test folder,integration_test to see the part that we tested

> you will receive apk,ipa for testing purpose in android device or simulator