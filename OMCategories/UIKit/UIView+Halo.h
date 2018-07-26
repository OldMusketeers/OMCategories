//
//  UIView+Halo.h
//  HaloSlimFramework
//
//  Created by Jet on 16/1/22.
//
//

#import <UIKit/UIKit.h>

@interface UIView (Halo)
@property (nonatomic)CGFloat left;
@property (nonatomic)CGFloat top;
@property (nonatomic)CGFloat right;
@property (nonatomic)CGFloat bottom;
@property (nonatomic)CGFloat width;
@property (nonatomic)CGFloat height;
@property (nonatomic)CGFloat centerX;
@property (nonatomic)CGFloat centerY;

@property (nonatomic)CGPoint origin;
@property (nonatomic)CGSize size;
//有可能为nil
@property (nonatomic, readonly) UIViewController *viewController;

- (void)removeAllSubviews;

- (void)enableViewDebug;
/**
 Create a snapshot image of the complete view hierarchy.
 */
- (UIImage *)snapshotImage;

/**
 Create a snapshot image of the complete view hierarchy.
 @discussion It's faster than "snapshotImage", but may cause screen updates.
 See -[UIView drawViewHierarchyInRect:afterScreenUpdates:] for more information.
 */
- (UIImage *)snapshotImageAfterScreenUpdates:(BOOL)afterUpdates;


/**
 Converts a point from the receiver's coordinate system to that of the specified view or window.
 
 @param point A point specified in the local coordinate system (bounds) of the receiver.
 @param view  The view or window into whose coordinate system point is to be converted.
 If view is nil, this method instead converts to window base coordinates.
 @return The point converted to the coordinate system of view.
 */
- (CGPoint)convertPoint:(CGPoint)point toViewOrWindow:(UIView *)view;

/**
 Converts a point from the coordinate system of a given view or window to that of the receiver.
 
 @param point A point specified in the local coordinate system (bounds) of view.
 @param view  The view or window with point in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The point converted to the local coordinate system (bounds) of the receiver.
 */
- (CGPoint)convertPoint:(CGPoint)point fromViewOrWindow:(UIView *)view;

/**
 Converts a rectangle from the receiver's coordinate system to that of another view or window.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of the receiver.
 @param view The view or window that is the target of the conversion operation. If view is nil, this method instead converts to window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect toViewOrWindow:(UIView *)view;

/**
 Converts a rectangle from the coordinate system of another view or window to that of the receiver.
 
 @param rect A rectangle specified in the local coordinate system (bounds) of view.
 @param view The view or window with rect in its coordinate system.
 If view is nil, this method instead converts from window base coordinates.
 @return The converted rectangle.
 */
- (CGRect)convertRect:(CGRect)rect fromViewOrWindow:(UIView *)view;
@end
