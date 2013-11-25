//
//*******
//
//	filename: NumberFormatter.m
//	author: Zack Brown
//	date: 25/11/2013
//
//*******
//

#import "NumberFormatter.h"

@implementation NumberFormatter

#pragma mark - NumberFormatter

#pragma mark - NSNumberFormatter

- (BOOL)isPartialStringValid:(NSString *)partialString newEditingString:(NSString *__autoreleasing *)newString errorDescription:(NSString *__autoreleasing *)error
{
	if([partialString length] == 0)
	{
		return YES;
	}
	
	NSScanner *scanner = [NSScanner scannerWithString:partialString];
	
	if(![scanner scanInt:0] && ![scanner isAtEnd])
	{
		return NO;
	}
	
	return YES;
}

@end