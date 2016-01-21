//
//  ProfileViewController.m
//  BlocQuery
//
//  Created by Melissa Boring on 1/13/16.
//  Copyright © 2016 melbo. All rights reserved.
//

#import "ProfileViewController.h"
#import "PFFile.h"

@interface ProfileViewController ()<UIImagePickerControllerDelegate>

@property (nonatomic) UIImagePickerController *imagePickerController;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (nonatomic, strong) UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *profileDescriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *profileUsernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (nonatomic, strong) UITapGestureRecognizer *imageViewTapGestureRecognizer;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

- (IBAction)saveProfileUpdates:(id)sender;

@end

@implementation ProfileViewController

static void * SavingImageOrVideoContext = &SavingImageOrVideoContext;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.profileUsernameLabel.text = self.profileUser.username;
    self.firstNameTextField.text = self.profileUser[@"firstName"];
    self.lastNameTextField.text = self.profileUser[@"lastName"];
    self.profileDescriptionTextField.text = self.profileUser[@"description"];
    
    PFFile *userImageFile = [self.profileUser objectForKey:@"profileImage"];
    
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error)
        {
            self.profileImage = [UIImage imageWithData:imageData];
           
            if (self.profileImage == nil)
            {
                
                self.profileImage = [UIImage imageNamed:@"BlocQuery.png"];
            }
            
             self.profileImageView.image = self.profileImage;
        }
    }];
    
    //disable the save button if the logged in user is not the profile user
    if ([PFUser currentUser].username  != self.profileUser.username)
    {
        [self.saveBarButton setEnabled:NO];
    }
    
    //add gesture recognizer to imageView
    self.imageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapFired:)];
    [self.profileImageView addGestureRecognizer:self.imageViewTapGestureRecognizer];
    self.profileImageView.userInteractionEnabled = YES;
    
    //activity indicator for when we are saving our profile updates
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.indicator.frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
    self.indicator.center = self.view.center;
    [self.view addSubview:self.indicator];
    [self.indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UIImagePickerController
- (void) imageViewTapFired:(UITapGestureRecognizer *)sender
{
    if ([PFUser currentUser].username  != self.profileUser.username)
    {
    
        UIAlertController* notYouAlert = [UIAlertController alertControllerWithTitle:@"OOPS!"
                                                                   message:@"You do not have permission to modify this profile!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [notYouAlert addAction:cancelAction];
        [notYouAlert.view setNeedsLayout];
        [self presentViewController:notYouAlert animated:YES completion:nil];
    }
    
    else
    {
    
    
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];


        UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * action) {
                                                                
                                                                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                picker.delegate = (id)self;
                                                                picker.allowsEditing = YES;
                                                                self.imagePickerController = picker;
                                                                [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                                                
                                                            }];

        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                                 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                 BOOL isCameraAvailable = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
                                                                 
                                                                 //checks to see if camera is available
                                                                 picker.sourceType = (isCameraAvailable) ? UIImagePickerControllerSourceTypeCamera :
                                                                 UIImagePickerControllerSourceTypePhotoLibrary;
                                                                 picker.delegate = (id)self;
                                                                 picker.allowsEditing = YES;
                                                                 self.imagePickerController = picker;
                                                                 [self presentViewController:self.imagePickerController animated:YES completion:nil];
                                                                 
                                                             }];

        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];

        [alert addAction:photoAction];
        [alert addAction:cameraAction];
        [alert addAction:cancelAction];

        [alert.view setNeedsLayout];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark  - UIImagePickerControllerDelegate

//image picker photo chosen that initiates photo view controller
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    self.profileImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = self.profileImage;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark  - Save profile
- (IBAction)saveProfileUpdates:(id)sender

{
    //TODO: Come up with a way of determing what needs to be saved to the cloud. IE. I only want to save a new image if i've selected one.
    
    self.profileUser[@"firstName"] = self.firstNameTextField.text;
    self.profileUser[@"lastName"] = self.lastNameTextField.text;
    self.profileUser[@"description"] = self.profileDescriptionTextField.text;
    
    //save the image
    NSData *imageData = UIImagePNGRepresentation(self.profileImage);
    PFFile *imageFile = [PFFile fileWithName:@"profileImage.png" data:imageData];
    self.profileUser[@"profileImage"] = imageFile;

    [self.indicator startAnimating];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        //lets push this back onto the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
             [self.indicator stopAnimating];
           
        });
       
        
    } progressBlock:^(int percentDone) {
        
        //TODO: Either grab a pod or play around with indicator to show progress of the save
        
    }];
    
    [self.profileUser saveInBackground];

}

@end
