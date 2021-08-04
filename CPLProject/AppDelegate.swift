

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//First Fn: 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    func sharedInstance() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }

    lazy var datastoreCoordinator: DatastoreCoordinator = {
        return DatastoreCoordinator()
    }()

    lazy var contextManager: ContextManager = {
        return ContextManager()
    }()
}
