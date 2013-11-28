//
//*******
//
//	filename: VoronoiCircleEvent.h
//	author: Zack Brown
//	date: 26/11/2013
//
//*******
//

#import "VoronoiEvent.h"

@class VoronoiParabola;

@interface VoronoiCircleEvent : VoronoiEvent

@property (nonatomic) VoronoiParabola *parabola;

@end