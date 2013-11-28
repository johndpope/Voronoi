//
//*******
//
//	filename: VoronoiCell.h
//	author: Zack Brown
//	date: 27/11/2013
//
//*******
//

#import "VoronoiEvent.h"

@class VoronoiEdge;

@interface VoronoiCell : VoronoiEvent

- (void)addEdge:(VoronoiEdge *)edge;
- (void)addNeighbour:(VoronoiCell *)neighbour;
- (NSArray *)edges;
- (NSArray *)corners;
- (NSArray *)neighbours;

@end