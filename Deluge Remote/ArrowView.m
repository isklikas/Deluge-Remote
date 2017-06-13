//
//  ArrowView.m
//  Deluge Remote
//
//  Created by Yannis on 12/06/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "ArrowView.h"

@implementation ArrowView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    /* Set the color that we want to use to draw the line */
    if (self.downloadingColor == nil) {
        self.downloadingColor = [UIColor greenColor];
    }
    if (self.uploadingColor == nil) {
        self.downloadingColor = [UIColor blueColor];
    }
    CGFloat lineWidth = 0.0241*rect.size.width;
    CGFloat middleX = rect.size.width/2;
    UIColor *arrowColor = _isDownloading? self.downloadingColor: self.uploadingColor;
    [arrowColor set];
    /* Get the current graphics context */
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    /* Set the width for the line */
    CGContextSetLineWidth(currentContext,lineWidth);
    /* Start the line at this point */
    CGFloat margin = 0.06*rect.size.height;
    CGPoint startPoint = _isDownloading ? CGPointMake(middleX, margin) : CGPointMake(middleX, rect.size.height-margin);
    CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
    /* And end it at this point */
    CGPoint topPoint = _isDownloading? CGPointMake(middleX, rect.size.height-margin) : CGPointMake(middleX, margin);
    CGContextAddLineToPoint(currentContext, topPoint.x, topPoint.y);
    topPoint.y = _isDownloading? topPoint.y - lineWidth/4 : topPoint.y + lineWidth/4;
    CGContextMoveToPoint(currentContext,topPoint.x, topPoint.y);
    CGFloat angle = _isDownloading ? M_PI/4 : -M_PI/4;
    CGFloat arrowLength = 0.3*rect.size.height;
    
    CGContextAddLineToPoint(currentContext,topPoint.x - cos(angle)*arrowLength, topPoint.y - sin(angle)*arrowLength);
    CGContextMoveToPoint(currentContext,topPoint.x, topPoint.y);
    
    CGContextAddLineToPoint(currentContext,topPoint.x + cos(angle)*arrowLength, topPoint.y - sin(angle)*arrowLength);
    
    /* Use the context's current color to draw the line */
    CGContextStrokePath(currentContext);
    // Drawing code
}


@end
