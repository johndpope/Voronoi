//
//  main.m
//  Voronoi
//
//  Created by Zack Brown on 04/11/2013.
//  Copyright (c) 2013 Zack Brown. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

int main(int argc, char *argv[])
{
	[NSApplication sharedApplication];
	
	AppDelegate *appDelegate = [[AppDelegate alloc] init];
	
	[NSApp setDelegate:appDelegate];
	
	[NSApp run];
	
	return 0;
}