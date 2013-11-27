//
//*******
//
//	filename: VoronoiParabola.h
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import <Foundation/Foundation.h>

@class VoronoiCircleEvent;
@class VoronoiSiteEvent;

@interface VoronoiParabola : NSObject

@property (nonatomic, readonly) BOOL isLeafNode;
@property (nonatomic, readonly) VoronoiCircleEvent *circleEvent;
@property (nonatomic, readonly) VoronoiSiteEvent *siteEvent;
@property (nonatomic, readonly) VoronoiParabola *parentParabola;
@property (nonatomic, readonly) VoronoiParabola *leftParabola;
@property (nonatomic, readonly) VoronoiParabola *rightParabola;

- (id)initWithSiteEvent:(VoronoiSiteEvent *)siteEvent;

- (VoronoiParabola *)leftParentParabola;
- (VoronoiParabola *)rightParentParabola;
- (VoronoiParabola *)leftChildParabola;
- (VoronoiParabola *)rightChildParabola;

@end