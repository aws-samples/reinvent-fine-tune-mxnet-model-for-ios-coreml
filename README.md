#MXNet to CoreML Workshop

## Introduction

With the release of [Core
ML](https://developer.apple.com/machine-learning/) by Apple at [WWDC 2017](https://developer.apple.com/videos/play/wwdc2017/703/), iOS,macOS, watchOS and tvOS developers can now easily integrate a machine learning model into their app. This enables developers to bring intelligent new features to users with just a few lines of code. Core ML makes machine learning more accessible to mobile developers. It also enables rapid prototyping and the use of different sensors (like the camera, GPS, etc.) to create more powerful apps than ever.

Members of the MXNet community, including contributors from Apple and Amazon Web Services (AWS), have collaborated to produce a tool that converts machine learning models built using MXNet to Core ML format. This tool makes it easy for developers to build apps powered by machine learning for Apple devices. With this conversion tool, you now have a fast pipeline for your deep-learning-enabled applications. You can move from scalable and efficient distributed model training in the AWS Cloud using MXNet to fast run time inference on Apple devices.

To support the release of the converter tool we will use models trained on millions of examples for one dataset, and apply them to improve performance on a new problem with a much smaller dataset to infer whether a image is a hot dog or not a hot dog. Then we will convert this model from MXNet into CoreML and import it into a sample iOS app written in Swift. The iOS app feeds a picture to the model, which predicts whether the image we are looking at is a hot dog or not a hot dog. For performance, we recommend that you run the app on a physical iOS device (e.g., an iPhone) installed with iOS 11, but you can also try it on the Simulator that comes with the Xcode 9.0.

## Instructions

#### 1. Create A Training Compute Instance:
In the Amazon EC2 console, launch an instance. For step-by-step instructions, see Launching an AWS Marketplace Instance in the [Amazon EC2 User Guide for Linux Instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/launch-marketplace-console.html). As you follow the steps, use the following values:

   * Navigate to the EC2 Console in TODO:us-west-2: https://us-west-2.console.aws.amazon.com/ec2/v2/home?region=us-west-2

   * On the Choose an Amazon Machine Image (AMI) page, choose the `Community AMIs` tab, and search for `ami-eeae6696`. [Typically, you can launch the AWS Deep Learning AMI from the Marketplace tab. The AMI with ID `ami-eeae6696` is actually the Deep Learning AMI with the data already downloaded in the interest of time.]

   * On the Choose an Instance Type page, choose the `p2.xlarge` instance type.

   * On the Configure Instance Details page, do the following:
    * From the Network drop-down, choose your VPC.
    * From the Auto-assign Public IP list, choose Enable

   * On the Add Storage page, choose the default storage size. The AMI uses about 38 GB of disk space.
   * On the Add Tags page, add one tag with the key Name and any value (e.g. `mcl311`).
   * On the Configure Security Group page, leave the default settings which should be:
    * Protocol (TCP) rule.
    * Type : Custom TCP Rule
    * Protocol: TCP
    * Port Range: 22
    * Source: Anywhere (0.0.0.0/0,::/0)

   * Choose an existing or new key pair and click `Launch Instances`

#### 2. Connect
Once the instance is running (Status Check: 2/2), create an SSH tunnel to your instance. Enter the following into the terminal:
```
    ssh -L 8888:localhost:8888 -i <YOUR_CERT>.pem ubuntu@<DNS of your EC2 Instance>
```  

#### 3. Starting the Jupyter Notebook
   * Once logged in, change to the directory for this workshop
```
    cd mcl311
```

   * Start Jupyter Notebook. Enter the following into the terminal:
```
    jupyter notebook
```

   * Copy the URL output from the jupyter notebook startup command and paste it in your browser. The URL looks like `http://localhost:8888/SsomeCookieString`

#### 4. Run, Train & Model
Open notebook `fine-tuning-catsvsdogs.ipynb`

   * Run all cells in the notebook: select `Cell` menu and then click on `Run All`.

   * Go back to the Jupyter directory page, select the checkmark besides the file named `coreml.mlmodel` and then click `Download` to download the file on to your machine.

#### 5. Creating the iOS App
We will be using a sample iOS app to test our newly created CoreML model.
   * Download the app by:
```
TODO: git clone <github link>
```
   * Open the xcodeproj file in XCode.
   * Import the `coreml.mlmodel` file by dragging it into your XCode project folder.
   * TODO: Change the current model to `coreml().model`
   * Clean and build project
   * Test your iOS app

____

### IMAGE ATTRIBUTION
The following works of great photography were used in the iOS app:
* https://pixabay.com/en/puppy-dog-pet-animal-cute-white-1903313/
* https://pixabay.com/en/puppy-spaniel-dog-animal-young-2940583/
* https://pixabay.com/en/dog-forest-lake-view-dog-human-2939126/
* https://pixabay.com/en/cat-feline-animal-domestic-pet-2938019/
* https://pixabay.com/en/cat-young-animal-curious-wildcat-2083492/
* https://pixabay.com/en/cat-s-eyes-animal-shelter-mieze-2671903/
