//
//  BKNotifier.m
//  Blink
//
//  Created by 維平 廖 on 13/5/6.
//  Copyright (c) 2013年 flyingman. All rights reserved.
//

#import "BKNotifier.h"

#define ANIMATION_DURATION 0.2
#define NOTIFIER_HEIGHT 40.0

@interface BKNotifier()

@property (strong, nonatomic) UIView *viewToShowIn;

@property (nonatomic) CGRect startFrame;
@property (nonatomic) CGRect endFrame;

@end

@implementation BKNotifier

- (id)initWithTitle:(NSString *)title inView:(UIView *)parentView {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, NOTIFIER_HEIGHT)]){
        
        self.backgroundColor = [UIColor clearColor];
        
        _txtLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 12, self.frame.size.width - 0, 20)];
        [_txtLabel setFont:[UIFont fontWithName: @"Helvetica" size: 16]];
        [_txtLabel setBackgroundColor:[UIColor clearColor]];
        
        [_txtLabel setTextColor:[UIColor whiteColor]];
        
        _txtLabel.layer.shadowOffset = CGSizeMake(0, -0.5);
        _txtLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _txtLabel.layer.shadowOpacity = 1.0;
        _txtLabel.layer.shadowRadius = 1;
        
        _txtLabel.layer.masksToBounds = NO;
        
        [self addSubview:_txtLabel];
        
        self.title= title;        
        
        self.viewToShowIn = parentView;
    }
    
    return self;
}

- (void)showAnimation:(BKNotifierAnimation)animationType animated:(BOOL)animated {    
    CGRect startFrame = self.frame;
    CGRect endFrame;
    
    switch (animationType) {
        case BKNotifierAnimationShowFromBottom:
            startFrame.origin.y = self.viewToShowIn.frame.size.height;
            self.frame = startFrame;
            endFrame = startFrame;
            endFrame.origin.y -= NOTIFIER_HEIGHT;
            break;
            
        case BKNotifierAnimationShowFromTop:
            startFrame.origin.y = -NOTIFIER_HEIGHT;
            self.frame = startFrame;
            endFrame = startFrame;
            endFrame.origin.y = 0;
            break;
            
        default:
            break;
    }
    
    self.startFrame = startFrame;
    self.endFrame = endFrame;
    [self.viewToShowIn addSubview:self];
    
    NSTimeInterval animationTime = 0;
    if (animated) {
        animationTime = ANIMATION_DURATION;
    }
    
    [UIView animateWithDuration:animationTime animations:^{
        self.frame = endFrame;
    }];
}

- (void)hideIn:(double)seconds animated:(BOOL)animated {    
    NSTimeInterval animationTime = 0;
    if (animated) {
        animationTime = ANIMATION_DURATION;
    }
    
    double delayInSeconds = seconds;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:animationTime animations:^{
            self.frame = self.startFrame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    });    
}

- (void)drawRect:(CGRect)rect{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    
    //Background color
    CGRect rectangle = CGRectMake(0,0,320,40);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor colorWithWhite:0.800 alpha:0.750].CGColor);
    CGContextFillRect(context, rectangle);
    
    //First whiteColor
    //    CGContextSetLineWidth(context, 1.0);
    //    CGFloat componentsWhiteLine[] = {1.0, 1.0, 1.0, 0.35};
    //    CGColorRef Whitecolor = CGColorCreate(colorspace, componentsWhiteLine);
    //    CGContextSetStrokeColorWithColor(context, Whitecolor);
    //
    //    CGContextMoveToPoint(context, 0, 4.5);
    //    CGContextAddLineToPoint(context, 320, 4.5);
    //
    //    CGContextStrokePath(context);
    //    CGColorRelease(Whitecolor);
    
    //First whiteColor
    //    CGContextSetLineWidth(context, 1.0);
    //    CGFloat componentsBlackLine[] = {0.0, 0.0, 0.0, 1.0};
    //    CGColorRef Blackcolor = CGColorCreate(colorspace, componentsBlackLine);
    //    CGContextSetStrokeColorWithColor(context, Blackcolor);
    //
    //    CGContextMoveToPoint(context, 0, 3.5);
    //    CGContextAddLineToPoint(context, 320, 3.5);
    //
    //    CGContextStrokePath(context);
    //    CGColorRelease(Blackcolor);
    
    //Draw Shadow
    
    //    CGRect imageBounds = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 3.f);
    //	CGRect bounds = CGRectMake(0, 0, 320, 3);
    //	CGFloat alignStroke;
    //	CGFloat resolution;
    //	CGMutablePathRef path;
    //	CGRect drawRect;
    //	CGGradientRef gradient;
    //	NSMutableArray *colors;
    //	UIColor *color;
    //	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    //	CGPoint point;
    //	CGPoint point2;
    //	CGAffineTransform transform;
    //	CGMutablePathRef tempPath;
    //	CGRect pathBounds;
    //	CGFloat locations[2];
    //	resolution = 0.5f * (bounds.size.width / imageBounds.size.width + bounds.size.height / imageBounds.size.height);
    //
    //	CGContextSaveGState(context);
    //	CGContextTranslateCTM(context, bounds.origin.x, bounds.origin.y);
    //	CGContextScaleCTM(context, (bounds.size.width / imageBounds.size.width), (bounds.size.height / imageBounds.size.height));
    //
    //	// Layer 1
    //
    //	alignStroke = 0.0f;
    //	path = CGPathCreateMutable();
    //	drawRect = CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, 3.0f);
    //	drawRect.origin.x = (roundf(resolution * drawRect.origin.x + alignStroke) - alignStroke) / resolution;
    //	drawRect.origin.y = (roundf(resolution * drawRect.origin.y + alignStroke) - alignStroke) / resolution;
    //	drawRect.size.width = roundf(resolution * drawRect.size.width) / resolution;
    //	drawRect.size.height = roundf(resolution * drawRect.size.height) / resolution;
    //	CGPathAddRect(path, NULL, drawRect);
    //	colors = [NSMutableArray arrayWithCapacity:2];
    //	color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
    //	[colors addObject:(id)[color CGColor]];
    //	locations[0] = 0.0f;
    //	color = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.18f];
    //	[colors addObject:(id)[color CGColor]];
    //	locations[1] = 1.0f;
    //	gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef)colors, locations);
    //	CGContextAddPath(context, path);
    //	CGContextSaveGState(context);
    //	CGContextEOClip(context);
    //	transform = CGAffineTransformMakeRotation(-1.571f);
    //	tempPath = CGPathCreateMutable();
    //	CGPathAddPath(tempPath, &transform, path);
    //	pathBounds = CGPathGetPathBoundingBox(tempPath);
    //	point = pathBounds.origin;
    //	point2 = CGPointMake(CGRectGetMaxX(pathBounds), CGRectGetMinY(pathBounds));
    //	transform = CGAffineTransformInvert(transform);
    //	point = CGPointApplyAffineTransform(point, transform);
    //	point2 = CGPointApplyAffineTransform(point2, transform);
    //	CGPathRelease(tempPath);
    //	CGContextDrawLinearGradient(context, gradient, point, point2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
    //	CGContextRestoreGState(context);
    //	CGGradientRelease(gradient);
    //	CGPathRelease(path);
    //	
    //	CGContextRestoreGState(context);
    //	CGColorSpaceRelease(space);
    //
    //    CGColorSpaceRelease(colorspace);
}

@end
