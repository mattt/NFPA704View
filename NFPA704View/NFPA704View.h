// NFPA704View.h
//
// Copyright (c) 2014 Mattt (https://mat.tt/)
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

@import UIKit;

typedef NS_ENUM(NSUInteger, NFPA704HazardLevel) {
    NFPA704MinimalHazard = 0,
    NFPA704SlightHazard = 1,
    NFPA704ModerateHazard = 2,
    NFPA704SeriousHazard = 3,
    NFPA704ExtremeHazard = 4,
};

@protocol NFPA704Material;
@interface NFPA704View : UIView

@property (nonatomic, strong) id <NFPA704Material> material;
@property (nonatomic, assign) NFPA704HazardLevel flammability;
@property (nonatomic, assign) NFPA704HazardLevel health;
@property (nonatomic, assign) NFPA704HazardLevel reactivity;
@property (nonatomic, copy) NSString *specialNotice;

@property (nonatomic, copy) UIColor *flammabilityColor;
@property (nonatomic, copy) UIColor *healthColor;
@property (nonatomic, copy) UIColor *reactivityColor;
@property (nonatomic, copy) UIColor *specialNoticeColor;

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, assign) UIColor *strokeColor;

@property (readonly, nonatomic, strong) UILabel *flammabilityLabel;
@property (readonly, nonatomic, strong) UILabel *healthLabel;
@property (readonly, nonatomic, strong) UILabel *reactivityLabel;
@property (readonly, nonatomic, strong) UILabel *specialNoticeLabel;

@end

///

extern NSString * const NFPA704OxidizerSymbol;
extern NSString * const NFPA704ReactsWithWaterSymbol;
extern NSString * const NFPA704SimpleAsphyxiantGas;

///

@protocol NFPA704Material <NSObject>
@required
@property (nonatomic, assign) NFPA704HazardLevel flammability;
@property (nonatomic, assign) NFPA704HazardLevel health;
@property (nonatomic, assign) NFPA704HazardLevel reactivity;

@optional
@property (nonatomic, copy) NSString *specialNotice;
@end
