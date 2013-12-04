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
@class VoronoiEdge;
@class VoronoiSiteEvent;

@interface VoronoiParabola : NSObject

@property (nonatomic, readonly) BOOL isLeafNode;
@property (nonatomic, retain, readonly) VoronoiParabola *parentParabola;
@property (nonatomic, retain, readonly) VoronoiParabola *leftParabola;
@property (nonatomic, retain, readonly) VoronoiParabola *rightParabola;
@property (nonatomic, retain, readonly) VoronoiSiteEvent *siteEvent;
@property (nonatomic, retain) VoronoiCircleEvent *circleEvent;
@property (nonatomic, retain) VoronoiEdge *edge;

- (id)initWithSiteEvent:(VoronoiSiteEvent *)siteEvent;
- (void)setLeftParabola:(VoronoiParabola *)leftParabola;
- (void)setRightParabola:(VoronoiParabola *)rightParabola;
- (VoronoiParabola *)leftParentParabola;
- (VoronoiParabola *)rightParentParabola;
- (VoronoiParabola *)leftChildParabola;
- (VoronoiParabola *)rightChildParabola;
- (VoronoiParabola *)childParabolaIntersectingSiteEvent:(VoronoiSiteEvent *)siteEvent;

@end