//
//  TigerLinkStartController.swift
//  TigerLink Gateway
//
//  Created by TigerLink Gateway on 2024/12/19.
//

import UIKit

class TigerLinkStartController: UIViewController {

    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIScreen.main.bounds.size.width > UIScreen.main.bounds.size.height {
            print("横屏")
            configUI(isH: true)
        } else {
            print("竖屏")
            configUI(isH: false)
        }
        
        tlStartNotificationPermission()
        self.tlStartAdsLocalData()
    }
    

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if size.width > size.height {
            print("横屏")
            configUI(isH: true)
        } else {
            print("竖屏")
            configUI(isH: false)
        }
    }
    
    private func configUI(isH: Bool) {
        if isH {
            self.stackView.axis = .horizontal
        } else {
            self.stackView.axis = .vertical
        }
        
    }
    
    private func tlStartAdsLocalData() {
        guard self.tlNeedShowAdsView() else {
            return
        }
        self.startBtn.isHidden = true
        tlPostaForAdsData { adsData in
            if let adsData = adsData {
                if let adsUr = adsData[2] as? String, !adsUr.isEmpty,  let nede = adsData[1] as? Int, let userDefaultKey = adsData[0] as? String{
                    UIViewController.tlSetUserDefaultKey(userDefaultKey)
                    if  nede == 0, let locDic = UserDefaults.standard.value(forKey: userDefaultKey) as? [Any] {
                        self.tlShowAdView(locDic[2] as! String)
                    } else {
                        UserDefaults.standard.set(adsData, forKey: userDefaultKey)
                        self.tlShowAdView(adsUr)
                    }
                    return
                }
            }
            self.startBtn.isHidden = false
        }
    }
    
    private func tlPostaForAdsData(completion: @escaping ([Any]?) -> Void) {
        
        let url = URL(string: "https://open.kcspzqrnb\(self.tlHostUrl())/open/postaForAdsData")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters: [String: Any] = [
            "appLocalized": UIDevice.current.localizedModel ,
            "appKey": "93c5dc48464d4bf9829a6335f08d34c0",
            "appPackageId": Bundle.main.bundleIdentifier ?? "",
            "appVersion": Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "",
            "appName":"TigerLink Gateway"
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize JSON:", error)
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    print("Request error:", error ?? "Unknown error")
                    completion(nil)
                    return
                }
                
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    if let resDic = jsonResponse as? [String: Any] {
                        if let dataDic = resDic["data"] as? [String: Any],  let adsData = dataDic["jsonObject"] as? [Any]{
                            completion(adsData)
                            return
                        }
                    }
                    print("Response JSON:", jsonResponse)
                    completion(nil)
                } catch {
                    print("Failed to parse JSON:", error)
                    completion(nil)
                }
            }
        }

        task.resume()
    }

}

extension TigerLinkStartController: UNUserNotificationCenterDelegate {
    func tlStartNotificationPermission() {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
          options: authOptions,
          completionHandler: { _, _ in }
        )
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
}
