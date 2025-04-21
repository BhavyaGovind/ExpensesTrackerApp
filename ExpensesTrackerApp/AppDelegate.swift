//
//  AppDelegate.swift
//  ExpensesTrackerApp
//
//  Created by Santosh Govind on 3/6/25.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import RealmSwift


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Set up Realm configuration with schema version and migration block
        let config = Realm.Configuration(
            schemaVersion: 2,  // Increment the version number each time your model changes
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    
                    migration.renameProperty(onType: Expense.className(), from: "title", to: "expenseDescription")
                    migration.enumerateObjects(ofType: Expense.className()) { oldObject, newObject in
                        newObject?["id"] = UUID().uuidString
                        // Handle 'date' being added
                        newObject!["date"] = Date()
                    }
                }
            }
        )
        
        // Apply this configuration globally
        Realm.Configuration.defaultConfiguration = config
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Configure Google Sign-In
        
        GIDSignIn.sharedInstance.configuration = GIDConfiguration(clientID: FirebaseApp.app()?.options.clientID ?? "")
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.blue // Replace with your desired color
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // Set title text color if needed
        // Apply the appearance globally
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = UIColor.white 
        
        let navigationController = UINavigationController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        //Load or clear expenses for UITesting
        if (ProcessInfo.processInfo.environment["UITest"] == "1") {
            if(CommandLine.arguments.contains("--reset-data")) {
                ExpenseManager.shared.clearAllExpenses()
            }
            if(CommandLine.arguments.contains("--seed-mock-expenses")) {
                ExpenseManager.shared.addMockExpensesForUITests()
            }
        }
        
        let coordinator = AppCoordinator(window: window!)
        coordinator.start()
        
        
        return true
    }
    
    // Google Sign-In URL handling
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

