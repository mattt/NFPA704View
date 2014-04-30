// NFPA704View.m
//
// Copyright (c) 2014 Mattt Thompson
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "NFPA704View.h"

NSString * const NFPA704OxidizerSymbol = @"OX";
NSString * const NFPA704ReactsWithWaterSymbol = @"￦";
NSString * const NFPA704SimpleAsphyxiantGas = @"SA";

#pragma mark -

static NFPA704HazardLevel NFPA704NormalizedHazardLevel(NFPA704HazardLevel level) {
    return MAX(MIN(level, NFPA704ExtremeHazard), NFPA704MinimalHazard);
}

static NSString * NSStringFromNFPA704HazardLevel(NFPA704HazardLevel level) {
    return [@(level) stringValue];
}

#pragma mark -

@interface NFPA704View ()
@property (readwrite, nonatomic, strong) UILabel *flammabilityLabel;
@property (readwrite, nonatomic, strong) UILabel *healthLabel;
@property (readwrite, nonatomic, strong) UILabel *reactivityLabel;
@property (readwrite, nonatomic, strong) UILabel *specialNoticeLabel;
@end

@implementation NFPA704View

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    [self commonInit];

    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self commonInit];
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;

    self.flammabilityColor = [UIColor redColor];
    self.healthColor = [UIColor blueColor];
    self.reactivityColor = [UIColor yellowColor];
    self.specialNoticeColor = [UIColor whiteColor];

    self.strokeColor = [UIColor blackColor];
    self.lineWidth = 4.0f;

    self.flammabilityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.healthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reactivityLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.specialNoticeLabel = [[UILabel alloc] initWithFrame:CGRectZero];

    for (UILabel *label in @[self.flammabilityLabel, self.healthLabel, self.reactivityLabel, self.specialNoticeLabel]) {
        label.font = [UIFont boldSystemFontOfSize:36];
        label.adjustsFontSizeToFitWidth = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        [self addSubview:label];
    }

    self.flammability = NFPA704MinimalHazard;
    self.health = NFPA704MinimalHazard;
    self.reactivity = NFPA704MinimalHazard;
}

#pragma mark -

- (void)setMaterial:(id<NFPA704Material>)material {
    _material = material;

    self.flammability = material.flammability;
    self.health = material.health;
    self.reactivity = material.reactivity;
    if ([material respondsToSelector:@selector(specialNotice)]) {
        self.specialNotice = material.specialNotice;
    }
}

- (void)setFlammability:(NFPA704HazardLevel)flammability {
    _flammability = NFPA704NormalizedHazardLevel(flammability);

    self.flammabilityLabel.text = NSStringFromNFPA704HazardLevel(self.flammability);
}

- (void)setHealth:(NFPA704HazardLevel)health {
    _health = NFPA704NormalizedHazardLevel(health);

    self.healthLabel.text = NSStringFromNFPA704HazardLevel(self.health);
}

- (void)setReactivity:(NFPA704HazardLevel)reactivity {
    _reactivity = NFPA704NormalizedHazardLevel(reactivity);

    self.reactivityLabel.text = NSStringFromNFPA704HazardLevel(self.reactivity);
}

- (void)setSpecialNotice:(NSString *)specialNotice {
    _specialNotice = specialNotice;

    self.specialNoticeLabel.text = self.specialNotice;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];

    for (UILabel *label in @[self.flammabilityLabel, self.healthLabel, self.reactivityLabel, self.specialNoticeLabel]) {
        label.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width / 4.0f, self.bounds.size.height / 4.0f);
    }

    self.flammabilityLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) / 2.0f);
    self.healthLabel.center = CGPointMake(CGRectGetMidX(self.bounds) / 2.0, CGRectGetMidY(self.bounds));
    self.reactivityLabel.center = CGPointMake(CGRectGetMidX(self.bounds) * 3.0 / 2.0f, CGRectGetMidY(self.bounds));
    self.specialNoticeLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds) * 3.0 / 2.0f);
}

static void CGContextAddQuadrantOfRect(CGContextRef ctx, CGRect rect, CGRectEdge edge) {
    CGFloat length = fminf(CGRectGetHeight(rect), CGRectGetWidth(rect)) / 2.0f;
    CGPoint origin;

    switch (edge) {
        case CGRectMinYEdge:
            origin = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
            break;
        case CGRectMaxXEdge:
            origin = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            break;
        case CGRectMaxYEdge:
            origin = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
            break;
        case CGRectMinXEdge:
            origin = CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect));
            break;
    }
    CGContextAddRect(ctx, CGRectMake(origin.x, origin.y, length, length));
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    rect = ({
        CGFloat length = fminf(CGRectGetHeight(rect), CGRectGetWidth(rect));
        CGRectMake((CGRectGetWidth(rect) - length) / 2.0f, (CGRectGetHeight(rect) - length) / 2.0f, length, length);
    });

    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetStrokeColorWithColor(ctx, [self.strokeColor CGColor]);
    CGContextSetLineWidth(ctx, self.lineWidth);
    CGContextSetLineCap(ctx, kCGLineCapSquare);
    CGContextSaveGState(ctx);
    {
        CGContextTranslateCTM(ctx, CGRectGetWidth(rect) / 2.0f, 0.0f);
        CGContextRotateCTM(ctx, M_PI_4);
        CGContextScaleCTM(ctx, 1.0f / M_SQRT2, 1.0f / M_SQRT2);

        CGContextAddQuadrantOfRect(ctx, rect, CGRectMinYEdge);
        CGContextSetFillColorWithColor(ctx, [self.flammabilityColor CGColor]);
        CGContextFillPath(ctx);

        CGContextAddQuadrantOfRect(ctx, rect, CGRectMaxXEdge);
        CGContextSetFillColorWithColor(ctx, [self.reactivityColor CGColor]);
        CGContextFillPath(ctx);

        CGContextAddQuadrantOfRect(ctx, rect, CGRectMinXEdge);
        CGContextSetFillColorWithColor(ctx, [self.healthColor CGColor]);
        CGContextFillPath(ctx);

        CGContextAddQuadrantOfRect(ctx, rect, CGRectMaxYEdge);
        CGContextSetFillColorWithColor(ctx, [self.specialNoticeColor CGColor]);
        CGContextFillPath(ctx);

        CGContextAddRect(ctx, CGRectInset(rect, self.lineWidth / 2.0f, self.lineWidth / 2.0f));
        CGContextStrokePath(ctx);

        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMidX(rect) - self.lineWidth / 2.0f, CGRectGetMinY(rect));
        CGContextAddLineToPoint(ctx, CGRectGetMidX(rect) - self.lineWidth / 2.0f, CGRectGetMaxY(rect));
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);

        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, CGRectGetMinX(rect), CGRectGetMidY(rect) - self.lineWidth / 2.0f);
        CGContextAddLineToPoint(ctx, CGRectGetMaxX(rect), CGRectGetMidY(rect) - self.lineWidth / 2.0f);
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }
    CGContextRestoreGState(ctx);

    UIGraphicsEndImageContext();
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self) {
        return nil;
    }

    [self commonInit];

    self.material = [decoder decodeObjectForKey:NSStringFromSelector(@selector(material))];
    self.flammability = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(flammability))];
    self.health = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(health))];
    self.reactivity = [decoder decodeIntegerForKey:NSStringFromSelector(@selector(reactivity))];
    self.specialNotice = [decoder decodeObjectForKey:NSStringFromSelector(@selector(specialNotice))];

    self.lineWidth = [decoder decodeFloatForKey:NSStringFromSelector(@selector(lineWidth))];
    self.strokeColor = [decoder decodeObjectForKey:NSStringFromSelector(@selector(strokeColor))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [super encodeWithCoder:coder];

    if ([self.material conformsToProtocol:@protocol(NSCoding)]) {
        [coder encodeObject:self.material forKey:NSStringFromSelector(@selector(specialNotice))];
    }

    [coder encodeInteger:self.flammability forKey:NSStringFromSelector(@selector(flammability))];
    [coder encodeInteger:self.health forKey:NSStringFromSelector(@selector(health))];
    [coder encodeInteger:self.reactivity forKey:NSStringFromSelector(@selector(reactivity))];
    [coder encodeObject:self.specialNotice forKey:NSStringFromSelector(@selector(specialNotice))];

    [coder encodeFloat:self.lineWidth forKey:NSStringFromSelector(@selector(lineWidth))];
    [coder encodeObject:self.strokeColor forKey:NSStringFromSelector(@selector(strokeColor))];
}

@end
