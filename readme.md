# GSLog
A logging class built out of a need to view logs on-the-go

****

**GSLog** is an `NSLog` substitute, which follows predominantly the same syntax. In addition to logging to the console as is standard, it also saves logs to an array stored in 

## Usage
Simply drop **GSLog.swift** into your project and replace `NSLog()` with `GSLog()`. Then, add `GSLog.setupLog(OntoViewController: self)` into the `viewDidLoad` function of the View Controller(s) you would like to view logs on. To add it to all view controllers, I would suggest subclassing UIViewController and adding it into `viewDidLoad` there.

If you wish, you can also call `GSLog.appStarted(silent: BOOL)` in your AppDelegate to log device/app information, and show in the log when your app launches.

In order to view logs on device, tap anywhere on the screen with three fingers to show/hide the scrollable log. In addition, you can double tap with the log open to share the log.

### Standard log
Swift function:
`GSLog("So there is this thing that just happened which I need to log")`

Output to GSLog:
`01 Jan 12:00:00 [⚡️] So there is this thing that just happened which I need to log`

Output to console:
`[⚡️] So there is this thing that just happened which I need to log`

### Log with level
Swift function:
`GSLog("So there might be something dangerous happening which I need to log about", .warning)`

Output to GSLog:
`01 Jan 12:00:00 [🔥] So there might be something dangerous happening which I need to log about`

Output to console:
`[🔥] So there might be something dangerous happening which I need to log about`

## Logging levels
There are three logging levels built into GSLog, each of which will either show as the level name in brackets, or an emoji in brackets. Whilst this sounds naff, this makes it considerably easier to spot issues in a log at a skim.

* ⚡️ notice
* 🔥 warning
* 💥 error

Each of these are accessible by passing `.{levelname}` as the second parameter in a `GSLog()` call

## Contributers
* by [George Streten](https://github.com/grstreten)
* with contribution from [George Taylor](https://github.com/georgepstaylor)
