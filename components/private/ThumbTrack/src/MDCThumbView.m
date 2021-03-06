// Copyright 2015-present the Material Components for iOS authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "MDCThumbView.h"

#import "MaterialShadowElevations.h"
#import "MaterialShadowLayer.h"

@interface MDCThumbView ()

@property(nonatomic, strong) UIImageView *iconView;

@end

@implementation MDCThumbView

+ (Class)layerClass {
  return [MDCShadowLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // TODO: Remove once MDCShadowLayer is rasterized by default.
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    _shadowColor = UIColor.blackColor;
  }
  return self;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  self.layer.cornerRadius = cornerRadius;
  [self setNeedsLayout];
}

- (MDCShadowElevation)elevation {
  return [self shadowLayer].elevation;
}

- (void)setElevation:(MDCShadowElevation)elevation {
  [self shadowLayer].elevation = elevation;
}

- (MDCShadowLayer *)shadowLayer {
  return (MDCShadowLayer *)self.layer;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.layer.shadowPath =
      [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius].CGPath;
  self.layer.shadowColor = self.shadowColor.CGColor;
}

- (void)setIcon:(nullable UIImage *)icon {
  if (icon == _iconView.image || [icon isEqual:_iconView.image])
    return;

  if (_iconView) {
    [_iconView removeFromSuperview];
    _iconView = nil;
  }
  if (icon) {
    _iconView = [[UIImageView alloc] initWithImage:icon];
    [self addSubview:_iconView];
    // Calculate the inner square of the thumbs circle.
    CGFloat sideLength = (CGFloat)sin(45.0 / 180.0 * M_PI) * _cornerRadius * 2;
    CGFloat topLeft = _cornerRadius - (sideLength / 2);
    _iconView.frame = CGRectMake(topLeft, topLeft, sideLength, sideLength);
  }
}

- (void)setShadowColor:(UIColor *)shadowColor {
  _shadowColor = shadowColor;
  self.layer.shadowColor = shadowColor.CGColor;
}

@end
