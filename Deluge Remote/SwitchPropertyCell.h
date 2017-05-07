//
//  SwitchPropertyCell.h
//  Deluge Remote
//
//  Created by Yannis on 13/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "ClientPropertyCell.h"

@interface SwitchPropertyCell : ClientPropertyCell

@property (weak, nonatomic) IBOutlet UISwitch *mainSwitch;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
