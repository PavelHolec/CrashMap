import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        guard let keysPath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            fatalError("Keys.plist file is missing")
        }
        
        guard let baseURL = NSDictionary(contentsOfFile: keysPath)?.value(forKey: "NasaBaseURL") as? String else {
            fatalError("API [NasaBaseURL] is missing from Keys.plist")
        }
        
        guard let appToken = NSDictionary(contentsOfFile: keysPath)?.value(forKey: "NasaAppToken") as? String else {
            fatalError("API [NasaAppToken] is missing from Keys.plist")
        }
        
        guard let filterSinceYear = NSDictionary(contentsOfFile: keysPath)?.value(forKey: "FilterSinceYear") as? Int else {
            fatalError("[FilterSinceYear] is missing from Keys.plist")
        }
        
        guard let meteoriteListTableViewController = (window?.rootViewController as? UINavigationController)?.topViewController as? MeteoriteListTableViewController else {
            fatalError("MeteoriteListTableViewController is not a rootViewController")
        }
        
        meteoriteListTableViewController.configure(meteoriteService: MeteoriteService(url: baseURL, appToken: appToken),
                                                filterSinceYear: filterSinceYear)
    }
}
