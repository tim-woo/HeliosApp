//
//  MapViewAnnotation.m
//  HeliosApp
//
//  Created by Tim Woo on 8/19/11.
//  Copyright 2011 Helios Interactive. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize title, coordinate, image;

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {
	[super init];
	title = ttl;
	coordinate = c2d;
	return self;
}

- (void)dealloc {
	[title release];
	[super dealloc];
}

@end