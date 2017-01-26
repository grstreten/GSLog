//
//  GSLog.swift
//  Logging framework to display logs in-app, useful for untethered debugging
//

import UIKit

//Enum for severity of log
enum logLevel {
    case notice, warning, error
}

/**
 Log to both the console and a locally stored array which can be retrieved using a 3 finger tap
 Using **GSLog** can log ( `GSLog("LoggedString")` ) or setup/open/close the log view ( `GSLog.setupLog(self)`, `GSLog.openLog()`, `GSLog.closeLog()` )
 
 - parameter text: The text to print to the log
 
 - returns: nil
 */
public class GSLog: NSObject {
    
    ///Enable or disable saving logs to device (existing logs will still be visible and logs will still be printed into the console)
    var loggingEnabled = true
    var emojiful = true
    static let numberOfTouches = 2
    
    //Primary function
    @discardableResult init(_ text: String?, _ level: logLevel? = .notice) {
        super.init()

        //Allow for the use of other functions in the class
        if text != nil && loggingEnabled {
            //Get UserDefaults - this is where we store the log
            let defaults = UserDefaults.standard
            
            //Set up date formatting with easy-reference variables
            let date = Date()
            let calendar = Calendar.current
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            let seconds = calendar.component(.second, from: date)
            
            //Configure the date formatter
            let dateFormatter: DateFormatter = DateFormatter()
            let months = dateFormatter.shortMonthSymbols
            let monthSymbol = (months?[month-1])! as String
            
            //Add text to alert of the log level
            var levelText = String()
            
            if emojiful {
                switch level! {
                case logLevel.notice:
                    levelText = "[⚡️]"
                case logLevel.warning:
                    levelText = "[🔥]"
                case logLevel.error:
                    levelText = "[💥]"
                }
            } else {
                switch level! {
                case logLevel.notice:
                    levelText = "[Notice]"
                case logLevel.warning:
                    levelText = "[Warning]"
                case logLevel.error:
                    levelText = "[Error]"
                }
            }
            
            //Generate the text to log
            let logText = "\(day) \(monthSymbol) \(hour):\(minutes):\(seconds) \(levelText) \(text!)"
            
            //Add the log to UserDefaults, by storing it in an array (and initialising if needed)
            if defaults.array(forKey: "log") != nil{
                var array = defaults.array(forKey: "log")
                array?.append(logText)
                defaults.set(array, forKey: "log")
            } else {
                let array = [logText]
                defaults.set(array, forKey: "log")
            }
            
            //Print the logged text to the debug console, so as to be visible if running connected
            NSLog("\(levelText) \(text!)")
        } else if text != nil {
            NSLog(text!)
        }
    }
    
    /**
     Set up the log to appear on detection of a 3 finger tap from the user
     
     - parameters:
     - OntoView: The UIViewController over which the log should appear
     
     - returns:
     nil
     */
    class func setupLog(OntoViewController:UIViewController) {
        //Set up a gesture recogniser and add it to the view parameter
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GSLog.openLog))
        recognizer.numberOfTouchesRequired = numberOfTouches
        OntoViewController.view.addGestureRecognizer(recognizer)
    }
    
    ///Manually open the log (bypassing the need for a 3 finger tap from the user)
    class func openLog() {
        GSLog("3 finger tap recognised - opening log")
        
        //Set up a textView to display the log
        let textView = UITextView()
        
        textView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        //Print each log in the stored array to textView
        let log = UserDefaults.standard.array(forKey: "log")
        var logText = ""
        for item in log! {
            logText = "\(logText)\(item)\n"
        }
        textView.text = logText
        
        //Set up the textView UI
        textView.isEditable = false
        textView.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.85)
        textView.textColor = UIColor.white
        
        //Set up a recogniser to close the textView
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GSLog.closeLog))
        recognizer.numberOfTouchesRequired = numberOfTouches
        textView.addGestureRecognizer(recognizer)
        
        //Scroll to the bottom and set misc values
        textView.contentOffset = CGPoint(x: 0, y: textView.contentSize.height)
        textView.tag = 109 //For access in closing
        textView.contentInset.top = 20
        
        //Add the subview to be above other views
        UIApplication.shared.keyWindow!.addSubview(textView)
    }
    
    ///Manually close the log (bypassing the need for a 3 finger tap from the user)
    class func closeLog() {
        //Find the textView and remove it from the superview
        if let viewWithTag = UIApplication.shared.keyWindow!.viewWithTag(109) {
            viewWithTag.removeFromSuperview()
        }
    }
    
}
