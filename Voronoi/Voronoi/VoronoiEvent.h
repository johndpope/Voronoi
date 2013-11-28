//
//*******
//
//	filename: VoronoiEvent.h
//	author: Zack Brown
//	date: 26/11/2013
//
//*******
//

#import <Foundation/Foundation.h>

@interface VoronoiEvent : NSObject

@property (nonatomic) CGPoint position;

- (id)initWithPosition:(CGPoint)position;

@end