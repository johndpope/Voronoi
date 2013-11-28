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

@property (nonatomic) BOOL isLeafNode;
@property (nonatomic) VoronoiCircleEvent *circleEvent;
@property (nonatomic, readonly) VoronoiSiteEvent *siteEvent;
@property (nonatomic, readonly) VoronoiParabola *parentParabola;
@property (nonatomic, retain) VoronoiParabola *leftParabola;
@property (nonatomic, retain) VoronoiParabola *rightParabola;
@property (nonatomic, retain) VoronoiEdge *edge;

- (id)initWithSiteEvent:(VoronoiSiteEvent *)siteEvent;

- (VoronoiParabola *)leftParentParabola;
- (VoronoiParabola *)rightParentParabola;
- (VoronoiParabola *)leftChildParabola;
- (VoronoiParabola *)rightChildParabola;

@end