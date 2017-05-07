//
//  ClientPropertyCell.h
//  Deluge Remote
//
//  Created by Yannis on 12/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface ClientPropertyCell : UITableViewCell

@property (nonatomic) IBInspectable NSString *keyString;
@property BOOL isShownClearly;
@property (nonatomic) IBInspectable NSInteger dependentCells;
@property (nonatomic) IBInspectable NSString *necessaryProperty;

@end
