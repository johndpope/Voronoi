//
//*******
//
//	filename: AppDelegate.h
//	author: Zack Brown
//	date: 04/11/2013
//
//*******
//

#import <Cocoa/Cocoa.h>

#import "RootWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain) NSWindow *window;
@property (nonatomic, retain) RootWindowController *rootWindowController;

@end