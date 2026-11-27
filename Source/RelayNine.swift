import SwiftUI
import BackgroundTasks
import UIKit

@main struct Qv9:App {
 @UIApplicationDelegateAdaptor(Bc7.self) var bc
 var body:some Scene{WindowGroup{Uc8()}}
}
final class Bc7:NSObject,UIApplicationDelegate {
 func application(_ application:UIApplication,didFinishLaunchingWithOptions launchOptions:[UIApplication.LaunchOptionsKey:Any]?=nil)->Bool {
  BGTaskScheduler.shared.register(forTaskWithIdentifier:"com.matchcenter.app-d353a8df8958.refresh",using:nil){t in
   let work=Task{@MainActor in Hx8.schedule();let ok=await Hx8.shared.refresh();t.setTaskCompleted(success:ok)}
   t.expirationHandler={work.cancel()}
  };return true
 }
 func application(_ application:UIApplication,performFetchWithCompletionHandler handler:@escaping(UIBackgroundFetchResult)->Void){Task{@MainActor in let ok=await Hx8.shared.refresh();handler(ok ? .newData:.failed)}}
}
