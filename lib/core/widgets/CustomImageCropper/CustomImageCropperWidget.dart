import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class CustomImageCropperWidget extends StatefulWidget {
  final String imagePath;
  final CropAspectRatio? aspectRatio;
  final Function(CroppedFile?) onCropped;
  final EdgeInsets? padding;
  final double? tickButtonTopPadding;

  const CustomImageCropperWidget({
    Key? key,
    required this.imagePath,
    required this.onCropped,
    this.aspectRatio,
    this.padding = const EdgeInsets.all(20),
    this.tickButtonTopPadding = 60, // Adjust this value to move tick button down
  }) : super(key: key);

  @override
  State<CustomImageCropperWidget> createState() => _CustomImageCropperWidgetState();
}

class _CustomImageCropperWidgetState extends State<CustomImageCropperWidget> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main cropping area with padding
            Positioned.fill(
              child: Padding(
                padding: widget.padding ?? EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Space for custom controls
                    SizedBox(height: widget.tickButtonTopPadding ?? 60),
                    
                    // Image cropping area
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: ClipRect(
                          child: Image.file(
                            File(widget.imagePath),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                    
                    // Bottom space for additional controls if needed
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            
            // Custom positioned tick button (easier to access)
            Positioned(
              top: widget.tickButtonTopPadding ?? 60,
              right: 20,
              child: GestureDetector(
                onTap: _isProcessing ? null : _cropImage,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _isProcessing ? Colors.grey : Colors.green,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _isProcessing 
                    ? CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                    : Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                ),
              ),
            ),
            
            // Cancel button
            Positioned(
              top: widget.tickButtonTopPadding ?? 60,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
            
            // Optional: Add crop guides overlay
            Positioned.fill(
              child: Padding(
                padding: widget.padding ?? EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: widget.tickButtonTopPadding ?? 60),
                    Expanded(
                      child: CustomPaint(
                        painter: CropGuidesPainter(),
                        size: Size.infinite,
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _cropImage() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: widget.imagePath,
        aspectRatio: widget.aspectRatio,
        compressQuality: 85,
        maxWidth: 1200,
        maxHeight: 1200,
        uiSettings: [
          AndroidUiSettings(
            cropStyle: CropStyle.rectangle,
            toolbarTitle: '',
            hideBottomControls: true,
            lockAspectRatio: widget.aspectRatio != null,
            showCropGrid: true,
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            cropFrameColor: Colors.white,
            cropFrameStrokeWidth: 2,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: widget.aspectRatio != null,
          ),
        ],
      );

      widget.onCropped(croppedFile);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      print("Error cropping image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error cropping image. Please try again."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}

// Custom painter for crop guides (rule of thirds)
class CropGuidesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1.0;

    // Draw rule of thirds lines
    final double thirdWidth = size.width / 3;
    final double thirdHeight = size.height / 3;

    // Vertical lines
    canvas.drawLine(
      Offset(thirdWidth, 0),
      Offset(thirdWidth, size.height),
      paint,
    );
    canvas.drawLine(
      Offset(thirdWidth * 2, 0),
      Offset(thirdWidth * 2, size.height),
      paint,
    );

    // Horizontal lines
    canvas.drawLine(
      Offset(0, thirdHeight),
      Offset(size.width, thirdHeight),
      paint,
    );
    canvas.drawLine(
      Offset(0, thirdHeight * 2),
      Offset(size.width, thirdHeight * 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}