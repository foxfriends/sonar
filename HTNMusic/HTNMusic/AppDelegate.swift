//
//  AppDelegate.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate let musicPlayer = MPMusicPlayerController.systemMusicPlayer()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        musicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.defaultCenter().addObserver(
            self,
            selector: "nowPlayingItemDidChange",
            name: MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
            object: nil
        )
        NotificationCenter.defaultCenter().addObserver(
            self,
            selector: "nowPlayingItemDidChange",
            name: MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
        func nowPlayingItemDidChange(notification: NSNotification) {
            var request = StatusAPIRouter = StatusAPIRouter.stop()
            if let item = musicPlayer.nowPlayingItem {
                let artist = item.artist
                let album = item.albumTitle
                let song = item.title
                request = StatusAPIRouter.play(song, artist, album)
            }
            Alamofire.request(request)
                .responseJSON { response in
                    if let result = response.result.value as? JSON {
                        switch APIResult<Void>(result) {
                        case .success: break
                        case .failure(let reason):
                            print("oo we fucked up: \(reason)")
                        }
                    }
                }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        musicPlayer.endGeneratingPlaybackNotifications()
    }
}
