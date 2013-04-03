//
//  MKMapView+AnnotationOperation.h
//  Blink
//
//  Created by 維平 廖 on 13/4/3.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MKMapView (AnnotationOperation)

- (void)removeAnnotations:(NSArray *)annotations withoutUser:(BOOL)withoutUser;

@end
