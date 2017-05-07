//
//  StepperPropertyCell.h
//  Deluge Remote
//
//  Created by Yannis on 13/04/2017.
//  Copyright © 2017 isklikas. All rights reserved.
//

#import "ClientPropertyCell.h"

@interface StepperPropertyCell : ClientPropertyCell

@property (weak, nonatomic) IBOutlet UIStepper *stepper;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
