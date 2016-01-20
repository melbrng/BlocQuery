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
@property (weak, nonatomic) IBOutlet UILabel *profileFirstnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *profileLastnameLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;
@property (nonatomic, strong) UITapGestureRecognizer *imageViewTapGestureRecognizer;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;

- (IBAction)saveButton:(id)sender;

@end

@implementation ProfileViewController

static void * SavingImageOrVideoContext = &SavingImageOrVideoContext;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.profileUsernameLabel.text = self.profileUser.username;
    self.profileFirstnameLabel.text = self.profileUser[@"firstname"];
    self.profileLastnameLabel.text = self.profileUser[@"lastname"];
    self.profileDescriptionTextField.text = self.profileUser[@"description"];
    
    PFFile *userImageFile = [self.profileUser objectForKey:@"profileImage"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error)
        {
            UIImage *profileImage = [UIImage imageWithData:imageData];
            self.profileImageView.image = profileImage;
            
            if (profileImage == nil)
            {
                self.profileImageView.image = [UIImage imageNamed:@"BlocQuery.png"];
            }
            
        }
    }];
    
    if ([PFUser currentUser].username  != self.profileUser.username)
    {
        [self.saveBarButton setEnabled:NO];
    }
    
    //add gesture recognizer to imageView
    self.imageViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapFired:)];
    [self.profileImageView addGestureRecognizer:self.imageViewTapGestureRecognizer];
    self.profileImageView.userInteractionEnabled = YES;
    
    
    self.indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
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
//        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
//                                                               style:UIAlertActionStyleCancel
//                                                             handler:nil];
//        [notYouAlert addAction:cancelAction];
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



-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    NSParameterAssert(contextInfo == SavingImageOrVideoContext);
    NSLog(@"didFinishSavingWithError");
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveButton:(id)sender
{
    
    NSData *imageData = UIImagePNGRepresentation(self.profileImage);
    PFFile *imageFile = [PFFile fileWithName:@"profileImage.png" data:imageData];
    self.profileUser[@"profileImage"] = imageFile;

    [self.indicator startAnimating];
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.indicator stopAnimating];
    } progressBlock:^(int percentDone) {
       // self.progress = (float)percentDone*0.9/100;
    }];
    
    //[self.profileUser saveInBackground];

}
@end
