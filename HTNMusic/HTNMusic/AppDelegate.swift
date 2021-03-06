//
//  AppDelegate.swift
//  HTNMusic
//
//  Created by Cameron Eldridge on 2017-09-16.
//  Copyright © 2017 Yeva Yu. All rights reserved.
//

import UIKit
import Alamofire
import MediaPlayer
import Gloss

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate let musicPlayer = MPMusicPlayerController.systemMusicPlayer()
    fileprivate let sessionManager = SessionManager()

    func nowPlayingItemDidChange(notification: NSNotification) {
        var request = StatusAPIRouter.stop()
        if let item = musicPlayer.nowPlayingItem {
            let artist = item.artist
            let album = item.albumTitle
            let title = item.title
            Session.sharedInstance.user?.currentListening?.title = title ?? "Unknown Title"
            Session.sharedInstance.user?.currentListening?.album = album ?? "Unknown Album"
            Session.sharedInstance.user?.currentListening?.artist = artist ?? "Unknown Artist"
            request = StatusAPIRouter.play(SongInfo(title: title, artist: artist, album: album))
        }
        
        if let authToken = Session.sharedInstance.authToken {
            sessionManager.adapter = AuthRequestAdapter(authToken: authToken)

            sessionManager.request(request)
                .responseJSON { response in
                    if let result = response.result.value as? JSON {
                        if String(describing: result["status"]) == "SUCCESS" {
                            print("k we're ok")
                        }
                    }
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        musicPlayer.beginGeneratingPlaybackNotifications()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(nowPlayingItemDidChange),
            name:    NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(nowPlayingItemDidChange),
            name:  NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
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
