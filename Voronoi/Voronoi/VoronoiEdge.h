//
//*******
//
//	filename: VoronoiEdge.h
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import <Foundation/Foundation.h>

@class VoronoiSiteEvent;

@interface VoronoiEdge : NSObject

@property (nonatomic) NSPoint start;
@property (nonatomic) NSPoint end;
@property (nonatomic, readonly) VoronoiSiteEvent *leftSiteEvent;
@property (nonatomic, readonly) VoronoiSiteEvent *rightSiteEvent;
@property (nonatomic, readonly) CGFloat direction;
@property (nonatomic, readonly) CGFloat f;
@property (nonatomic, readonly) CGFloat g;
@property (nonatomic, retain) VoronoiEdge *neighbour;

- (id)initWithStart:(NSPoint)start leftSiteEvent:(VoronoiSiteEvent *)leftSiteEvent rightSiteEvent:(VoronoiSiteEvent *)rightSiteEvent;

@end