#import "AppDelegate.h"
#import "Constants.h"
#import "SonomaAnalytics.h"
#import "SonomaCore.h"
#import "SonomaCrashes.h"
#import "SNMCrashesDelegate.h"

#import "SNMErrorAttachment.h"
#import "SNMErrorBinaryAttachment.h"
#import "SNMErrorReport.h"

@interface AppDelegate () <SNMCrashesDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Start Sonoma SDK.
  [SNMSonoma setLogLevel:SNMLogLevelVerbose];

  [SNMSonoma start:@"7dfb022a-17b5-4d4a-9c75-12bc3ef5e6b7" withFeatures:@[ [SNMAnalytics class], [SNMCrashes class] ]];

  if ([SNMCrashes hasCrashedInLastSession]) {
    SNMErrorReport *errorReport = [SNMCrashes lastSessionCrashReport];
    NSLog(@"We crashed with Signal: %@", errorReport.signal);
  }

  [SNMCrashes setDelegate:self];

  // Print the install Id.
  NSLog(@"%@ Install Id: %@", kPUPLogTag, [[SNMSonoma installId] UUIDString]);
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of
  // temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and
  // it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use
  // this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state
  // information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when
  // the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes
  // made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was
  // previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if appropriate. See also
  // applicationDidEnterBackground:.
}

#pragma mark - SNMCrashesDelegate

- (BOOL)crashes:(SNMCrashes *)crashes shouldProcessErrorReport:(SNMErrorReport *)errorReport {
  SNMLogVerbose(@"Should process error report with: %@", errorReport.exceptionReason);
  return YES;
}

- (SNMErrorAttachment *)attachmentWithCrashes:(SNMCrashes *)crashes forErrorReport:(SNMErrorReport *)errorReport {
  SNMLogVerbose(@"Attach additional information to error report with: %@", errorReport.exceptionReason);
  SNMErrorAttachment *attachment = [[SNMErrorAttachment alloc] init];
  attachment.textAttachment = @"Text Attachment";
  attachment.binaryAttachment = [[SNMErrorBinaryAttachment alloc] initWithFileName:@"binary.txt"
                                                                    attachmentData:[@"Hello World" dataUsingEncoding:NSUTF8StringEncoding]
                                                                       contentType:@"text/plain"];
  return attachment;
}

- (void)crashes:(SNMCrashes *)crashes willSendErrorReport:(SNMErrorReport *)errorReport {
  SNMLogVerbose(@"Will send error report with: %@", errorReport.exceptionReason);
}

- (void)crashes:(SNMCrashes *)crashes didSucceedSendingErrorReport:(SNMErrorReport *)errorReport {
  SNMLogVerbose(@"Did succeed error report sending with: %@", errorReport.exceptionReason);

}

- (void)crashes:(SNMCrashes *)crashes didFailSendingErrorReport:(SNMErrorReport *)errorReport withError:(NSError *)error {
  SNMLogVerbose(@"Did fail sending report with: %@, and error %@",
                errorReport.exceptionReason,
                error.localizedDescription);
}

@end
