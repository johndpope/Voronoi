//
//*******
//
//	filename: VoronoiCorner.h
//	author: Zack Brown
//	date: 28/11/2013
//
//*******
//

#import <Foundation/Foundation.h>

@class VoronoiEdge;

@interface VoronoiCorner : NSObject

@property (nonatomic, readonly) NSPoint position;
@property (nonatomic, readonly) VoronoiEdge *leftEdge;
@property (nonatomic, readonly) VoronoiEdge	*rightEdge;

- (id)initWithPosition:(NSPoint)position leftEdge:(VoronoiEdge *)leftEdge rightEdge:(VoronoiEdge *)rightEdge;

@end