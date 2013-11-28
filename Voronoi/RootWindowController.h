//
//*******
//
//	filename: RootWindowController.h
//	author: Zack Brown
//	date: 04/11/2013
//
//*******
//

#import <Cocoa/Cocoa.h>

#import "CreateDiagramPanel.h"

@interface RootWindowController : NSWindowController <NSWindowDelegate, CreateDiagramPanelDelegate>

@end