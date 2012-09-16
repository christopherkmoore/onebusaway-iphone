//
//  OBAScopeView.m
//  org.onebusaway.iphone
//
//  Created by Aaron Brethorst on 9/16/12.
//
//

#import "OBAScopeView.h"
#import <QuartzCore/QuartzCore.h>

@interface OBAScopeView ()
- (void)_configureOBAScopeView;
@end

@implementation OBAScopeView

+ (id)layerClass {
    return [CAGradientLayer class];
}

- (void)_configureOBAScopeView {
    self.backgroundColor = [UIColor clearColor];
    CAGradientLayer *gradient = (CAGradientLayer*)self.layer;
    gradient.colors = @[(id)(OBARGBCOLOR(213, 219, 223)).CGColor, (id)(OBARGBCOLOR(178, 187, 194)).CGColor];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _configureOBAScopeView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self _configureOBAScopeView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [OBARGBCOLOR(122, 137, 148) set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context,1.f);
    CGContextMoveToPoint(context, 0.f, CGRectGetHeight(self.frame) - 0.5f);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - 0.5f);
    CGContextStrokePath(context);
}

@end
