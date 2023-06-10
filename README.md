# Image and Audio Processing App

This is an Android application built with Flutter that provides various image processing functionalities such as resizing, transforming, and applying filters to images. Additionally, it offers audio processing capabilities, specifically audio compression.

## Features

The app includes the following features:

### Image Processing

- **Image Resize:** Allows the user to resize an image to a specific width and height.
- **Image Transformation:** Provides functionality to rotate and flip to an image.
- **Image Filtering:** Offers various filters such as grayscale, sepia, blur, and more.

### Audio Processing

- **Audio Compression:** Enables the user to compress an audio file, reducing its size while maintaining an acceptable level of quality.

## Installation

To use the app, follow these steps:

1. Clone the repository: `git clone https://github.com/syhrlanwr/multimedia-tools.git`
2. Navigate to the project directory: `cd multimedia-tools`
3. Install the dependencies by running: `flutter pub get`
4. Connect an Android device or start an Android emulator.
5. Run the app: `flutter run`

Ensure that you have Flutter and Dart installed and configured on your system before running the application.

## Usage

Once the app is installed and running on your Android device or emulator, you can perform the following actions:

1. **Image Processing:**
   - Select an image from your device's gallery or capture a new photo using the camera.
   - Choose the desired image processing option (resize, transform, filter).
   - Adjust the parameters for the selected option (e.g., width and height for resizing, rotation or flip for transformation, filter type for filtering).
   - Apply the chosen processing option to the image.
   - Save the processed image to your device.

2. **Audio Processing:**
   - Select an audio file from your device.
   - Choose the audio compression option.
   - Compress the audio file.
   - Save the compressed audio file to your device.

## License

The Image and Audio Processing App is open-source software released under the [MIT License](https://opensource.org/licenses/MIT).

## Acknowledgments

This project makes use of the following libraries and packages:

- Flutter: [https://flutter.dev](https://flutter.dev)
- image package: [https://pub.dev/packages/image](https://pub.dev/packages/image)
- just_audio package: [https://pub.dev/packages/just_audio](https://pub.dev/packages/just_audio)
- ffmpeg: [https://ffmpeg.org](https://ffmpeg.org)
