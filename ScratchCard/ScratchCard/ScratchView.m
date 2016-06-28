//
//  ScratchView.m
//  ScratchCard
//
//  Created by joshuali on 16/6/28.
//  Copyright © 2016年 joshuali. All rights reserved.
//

#import "ScratchView.h"

@interface ScratchView ()
{
    CGPoint startPoint;
}
@property (nonatomic, strong) CALayer * maskLayer;
@end

@implementation ScratchView

- (void) awakeFromNib
{
    [super awakeFromNib];
    self.layer.mask = [CALayer new];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    startPoint = touchLocation;
}

- (void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    CAShapeLayer * layer = [CAShapeLayer new];
    layer.path = [self getPathFromPointA:startPoint toPointB:touchLocation].CGPath;
    if(!_maskLayer){
        _maskLayer = [CALayer new];
    }
    [_maskLayer addSublayer:layer];
    
    self.layer.mask = _maskLayer;
    startPoint = touchLocation;
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    CAShapeLayer * layer = [CAShapeLayer new];
    layer.path = [self getPathFromPointA:startPoint toPointB:touchLocation].CGPath;
    if(!_maskLayer){
        _maskLayer = [CALayer new];
    }
    [_maskLayer addSublayer:layer];
    
    self.layer.mask = _maskLayer;
}

- (UIBezierPath *) getPathFromPointA:(CGPoint)a toPointB : (CGPoint) b
{
    UIBezierPath * path = [UIBezierPath new];
    UIBezierPath * curv1 = [UIBezierPath bezierPathWithArcCenter:a radius:self.scratchLineWidth startAngle:angleBetweenPoints(a, b)+M_PI_2 endAngle:angleBetweenPoints(a, b)+M_PI+M_PI_2 clockwise:b.x >= a.x];
    [path appendPath:curv1];
    UIBezierPath * curv2 = [UIBezierPath bezierPathWithArcCenter:b radius:self.scratchLineWidth startAngle:angleBetweenPoints(a, b)-M_PI_2 endAngle:angleBetweenPoints(a, b)+M_PI_2 clockwise:b.x >= a.x];
    [path addLineToPoint:CGPointMake(b.x * 2 - curv2.currentPoint.x, b.y * 2 - curv2.currentPoint.y)];
    [path appendPath:curv2];
    [path addLineToPoint:CGPointMake(a.x * 2 - curv1.currentPoint.x, a.y * 2 - curv1.currentPoint.y)];
    [path closePath];
    return path;
}

CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
    CGFloat height = second.y - first.y;
    CGFloat width = first.x - second.x;
    CGFloat rads = atan(height/width);
    return -rads;
}

@end
