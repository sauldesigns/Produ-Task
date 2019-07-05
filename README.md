# Produ:Task

[![Codemagic build status](https://api.codemagic.io/apps/5d04d10185769144bd77e750/5d04d10185769144bd77e74f/status_badge.svg)](https://codemagic.io/apps/5d04d10185769144bd77e750/5d04d10185769144bd77e74f/latest_build)

Produ:Task is a cross-platform cloud-enabled mobile application powered by Flutter Framework and Google Firebase.

The application was built with simplicity in mind so that users are able to focus on completing their tasks. 

The app uses an easy to use UI so that only necessary information is only displayed. Making it easier for one to stay productive. 

| Landing Page | Sign Up |
| ------ | ------ |
|<img src="http://sauldesigns.me/img/produtask/landingpage.PNG" width="400" height="800">| <img src="http://sauldesigns.me/img/produtask/signup.PNG" width="400" height="800">|

| Home Tab | Tasks |
| ------ | ------ |
|<img src="http://sauldesigns.me/img/produtask/hometab.PNG" width="400" height="800">| <img src="http://sauldesigns.me/img/produtask/tasks.PNG" width="400" height="800">|

| Settings | Edit Profile |
| ------ | ------ |
|<img src="http://sauldesigns.me/img/produtask/settings.PNG" width="400" height="800">| <img src="http://sauldesigns.me/img/produtask/editprofile.PNG" width="400" height="800">|

### Authenthication Methods
- [x] Google Sign In
- [x] Email & Password
- [ ] Facebook
- [ ] Apple Sign In

### How To Create Categories and Tasks
  - Initial page will be list of categories. By default there will be no categories. 
  - You can create categories by tapping on the "+" card.
    - Categories define the type of tasks will be created.
    - Makes it easier to sort tasks
  - Tap on created category to enter category and view the task list
  - By default there will be no tasks. Just like category you create task by tapping + icon.
  - Once a task is created you can tap on the check icon to complete the task, if you want to revert status of task you will simply retap the check icon. 
  - Long press on a category will bring up a menu. 
    - Allows ability to change color of category
    - Allows to edit category
    - Allow to share category with other users
    - Allows to delete category
  - Slide a task to left to bring up delete button, or slide a task to the right to bring up edit button.

### Database
  - Powered By Google Firebase:
    - Authenticaion
    - Image Storage
    - Data Storage

You can also:
  - Change profile picture
  - Edit profile
  - Reset password

### API
  - Powered by Firebase Database

>Produ:Task uses Firebase Database as the backend in order to store user created categories and tasks. This also helps store user profile images as well as allowing user authenthication. 

### Open Source Projects
Produ:Task uses a number of open source projects to work properly:

  - [Firebase Core] - Enables connecting to multiple Firebase apps.
  - [Firebase Auth] - Enables Android and iOS authentication using passwords, phone numbers and identity providers like google, facebook, and twitter
  - [Firebase Storage] - Enables the use of Cloud Storage API.
  - [Firebase Cloud Firestore] - Enables the use of the Cloud Firestore API.
  - [Image Picker] - Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera
  - [Connectivity] - Allows app to discover network connectivity and configure themseleves accordingly allowing app to show error when not connected to the internet.
  - [Email Validator] - Allows app to properly validate if an email was entered on sign in or sign up. 
  - [Fancy Bottom Navigation] - Allows app to create a nice animated navigation bar.
  - [Flushbar] - Makes it easier to display snackbar messages. 
  -  [Google Sign In] - Allows app to be able to use google authenthication rather than manually signing up. 
  -  [Flutter Slidable] - Makes it easier to create tasks that incorporate the ability to make task slidable allowing ability to add buttons when item is slided to left or right.

### Mobile Application Installation

| Android | iOS |
| ------ | ------ |
| In-progress | In-progress |

Application in progress of being uploaded to both the iOS and Android App store.

### Todos
  - Write MORE Tests
  - Implement profile page
  - Add smoother transitions/animations. 
  - Add ability to set reminders
  - Add calendar
  - Add more features

  [firebase core]: <https://pub.dev/packages/firebase_core>
  [firebase auth]: <https://pub.dev/packages/firebase_auth>
  [firebase storage]: <https://pub.dev/packages/firebase_storage>
  [firebase cloud firestore]: <https://pub.dev/packages/cloud_firestore>
  [http]: <https://pub.dev/packages/http>
  [url launcher]: <https://pub.dev/packages/url_launcher>
  [image picker]: <https://pub.dev/packages/image_picker>
  [connectivity]: <https://pub.dev/packages/connectivity>
  [flushbar]: <https://pub.dev/packages/flushbar>
  [Email Validator]: <https://pub.dev/packages/email_validator>
  [Fancy Bottom Navigation]: <https://pub.dev/packages/fancy_bottom_navigation>
  [Google Sign In]: <https://pub.dev/packages/google_sign_in>
  [Flutter Slidable]: <https://pub.dev/packages/flutter_slidable>  
  
  
