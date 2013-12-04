//
//*******
//
//	filename: VoronoiView.h
//	author: Zack Brown
//	date: 13/11/2013
//
//*******
//

#import <Cocoa/Cocoa.h>

@interface VoronoiView : NSView

@property (nonatomic, copy) NSArray *cells;
@property (nonatomic) NSRect contentFrame;

@end