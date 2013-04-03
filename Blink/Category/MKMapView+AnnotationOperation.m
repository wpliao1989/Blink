//
//  MKMapView+AnnotationOperation.m
//  Blink
//
//  Created by 維平 廖 on 13/4/3.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "MKMapView+AnnotationOperation.h"

@implementation MKMapView (AnnotationOperation)

- (void)removeAnnotations:(NSArray *)annotations withoutUser:(BOOL)withoutUser {
    NSArray *newAnnotations = annotations;
    
    if (withoutUser && (self.userLocation != nil)) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:annotations];
        [array removeObject:self.userLocation];
        newAnnotations = [NSArray arrayWithArray:array];
    }
    
    [self removeAnnotations:newAnnotations];
}

@end
