import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class CustomImageCropperDialog extends StatefulWidget {
  final String imagePath;
  final double? aspectRatio;

  const CustomImageCropperDialog({
    Key? key,
    required this.imagePath,
    this.aspectRatio,
  }) : super(key: key);

  @override
  State<CustomImageCropperDialog> createState() =>
      _CustomImageCropperDialogState();
}

class _CustomImageCropperDialogState extends State<CustomImageCropperDialog> {
  final TransformationController _transformationController =
      TransformationController();
  Offset _cropPosition = Offset.zero;
  Size _cropSize = Size(250, 250);
  ui.Image? _image;
  Size _displayedImageSize = Size.zero;
  Offset _displayedImageOffset = Offset.zero;
  bool _isLoading = false;
  bool _imageLoaded = false;
  double _scale = 1.0;
  double _previousScale = 1.0;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    final file = File(widget.imagePath);
    final bytes = await file.readAsBytes();
    final decodedImage = await decodeImageFromList(bytes);

    setState(() {
      _image = decodedImage;
      _imageLoaded = true;
    });
  }

  // void _calculateImageDimensions(BoxConstraints constraints) {
  //   if (_image == null) return;

  //   final containerWidth = constraints.maxWidth;
  //   final containerHeight = constraints.maxHeight;
  //   final imageAspectRatio = _image!.width / _image!.height;
  //   final containerAspectRatio = containerWidth / containerHeight;

  //   double displayWidth;
  //   double displayHeight;

  //   if (imageAspectRatio > containerAspectRatio) {
  //     displayWidth = containerWidth;
  //     displayHeight = containerWidth / imageAspectRatio;
  //   } else {
  //     displayHeight = containerHeight;
  //     displayWidth = containerHeight * imageAspectRatio;
  //   }

  //   // Apply scale
  //   displayWidth *= _scale;
  //   displayHeight *= _scale;

  //   _displayedImageSize = Size(displayWidth, displayHeight);
  //   _displayedImageOffset = Offset(
  //     (containerWidth - displayWidth) / 2,
  //     (containerHeight - displayHeight) / 2,
  //   );

  //   // Initialize crop box at center if not set
  //   if (_cropPosition == Offset.zero) {
  //     double cropWidth;
  //     double cropHeight;

  //     if (widget.aspectRatio != null) {
  //       cropWidth =
  //           containerWidth * 0.9; // Much larger crop box - 90% of screen
  //       cropHeight = cropWidth / widget.aspectRatio!;

  //       if (cropHeight > containerHeight * 0.9) {
  //         cropHeight = containerHeight * 0.85;
  //         cropWidth = cropHeight * widget.aspectRatio!;
  //       }
  //     } else {
  //       final minDimension =
  //           containerWidth < containerHeight ? containerWidth : containerHeight;
  //       cropWidth = minDimension * 0.9; // Much larger crop box - 90%
  //       cropHeight = minDimension * 0.9;
  //     }

  //     _cropSize = Size(cropWidth, cropHeight);
  //     _cropPosition = Offset(
  //       (containerWidth - cropWidth) / 2,
  //       (containerHeight - cropHeight) / 2,
  //     );
  //   }
  // }

  void _calculateImageDimensions(BoxConstraints constraints) {
    if (_image == null) return;

    final containerWidth = constraints.maxWidth;
    final containerHeight = constraints.maxHeight;
    final imageAspectRatio = _image!.width / _image!.height;
    final containerAspectRatio = containerWidth / containerHeight;

    double displayWidth;
    double displayHeight;

    if (imageAspectRatio > containerAspectRatio) {
      displayWidth = containerWidth;
      displayHeight = containerWidth / imageAspectRatio;
    } else {
      displayHeight = containerHeight;
      displayWidth = containerHeight * imageAspectRatio;
    }

    // Apply zoom scale
    displayWidth *= _scale;
    displayHeight *= _scale;

    _displayedImageSize = Size(displayWidth, displayHeight);
    _displayedImageOffset = Offset(
      (containerWidth - displayWidth) / 2,
      (containerHeight - displayHeight) / 2,
    );

    // Force a vertical crop box (tall, narrow)
    if (_cropPosition == Offset.zero) {
      double cropHeight = containerHeight * 0.9; // almost full height
      double cropWidth =
          cropHeight * 0.6; // width smaller than height (adjust ratio)

      // Prevent overflow
      if (cropWidth > containerWidth) {
        cropWidth = containerWidth * 0.8;
        cropHeight = cropWidth * 1.6; // still taller
      }

      _cropSize = Size(cropWidth, cropHeight);
      _cropPosition = Offset(
        (containerWidth - cropWidth) / 2,
        (containerHeight - cropHeight) / 2,
      );
    }
  }

  void _handleResize(
      DragUpdateDetails details, String corner, BoxConstraints constraints) {
    setState(() {
      double newWidth = _cropSize.width;
      double newHeight = _cropSize.height;
      double newX = _cropPosition.dx;
      double newY = _cropPosition.dy;

      // Resize logic based on corner
      if (corner.contains('right')) {
        newWidth = (_cropSize.width + details.delta.dx)
            .clamp(80.0, constraints.maxWidth - _cropPosition.dx);
      } else if (corner.contains('left')) {
        double deltaWidth = -details.delta.dx;
        if (_cropSize.width + deltaWidth >= 80.0 &&
            _cropPosition.dx + details.delta.dx >= 0) {
          newWidth = _cropSize.width + deltaWidth;
          newX = _cropPosition.dx + details.delta.dx;
        }
      }

      if (corner.contains('bottom')) {
        newHeight = (_cropSize.height + details.delta.dy)
            .clamp(80.0, constraints.maxHeight - _cropPosition.dy);
      } else if (corner.contains('top')) {
        double deltaHeight = -details.delta.dy;
        if (_cropSize.height + deltaHeight >= 80.0 &&
            _cropPosition.dy + details.delta.dy >= 0) {
          newHeight = _cropSize.height + deltaHeight;
          newY = _cropPosition.dy + details.delta.dy;
        }
      }

      // ✅ Enforce flexible portrait: height >= width
      if (newHeight < newWidth) {
        newHeight = newWidth;
      }

      // Apply new size and position
      _cropSize = Size(newWidth, newHeight);
      _cropPosition = Offset(newX, newY);
    });
  }

  // void _handleResize(
  //     DragUpdateDetails details, String corner, BoxConstraints constraints) {
  //   setState(() {
  //     double newWidth = _cropSize.width;
  //     double newHeight = _cropSize.height;
  //     double newX = _cropPosition.dx;
  //     double newY = _cropPosition.dy;

  //     if (widget.aspectRatio != null) {
  //       // Maintain aspect ratio
  //       if (corner.contains('right')) {
  //         newWidth = (_cropSize.width + details.delta.dx)
  //             .clamp(80.0, constraints.maxWidth - _cropPosition.dx);
  //         newHeight = newWidth / widget.aspectRatio!;
  //         // Check if new height fits
  //         if (corner.contains('top')) {
  //           if (newY + _cropSize.height - newHeight < 0) {
  //             newHeight = _cropSize.height + newY;
  //             newWidth = newHeight * widget.aspectRatio!;
  //           }
  //           newY = _cropPosition.dy + _cropSize.height - newHeight;
  //         } else if (newY + newHeight > constraints.maxHeight) {
  //           newHeight = constraints.maxHeight - newY;
  //           newWidth = newHeight * widget.aspectRatio!;
  //         }
  //       } else if (corner.contains('left')) {
  //         final deltaWidth = -details.delta.dx;
  //         newWidth = (_cropSize.width + deltaWidth)
  //             .clamp(80.0, _cropPosition.dx + _cropSize.width);
  //         newHeight = newWidth / widget.aspectRatio!;
  //         newX = _cropPosition.dx + _cropSize.width - newWidth;
  //         // Check if new height fits
  //         if (corner.contains('top')) {
  //           if (newY + _cropSize.height - newHeight < 0) {
  //             newHeight = _cropSize.height + newY;
  //             newWidth = newHeight * widget.aspectRatio!;
  //             newX = _cropPosition.dx + _cropSize.width - newWidth;
  //           }
  //           newY = _cropPosition.dy + _cropSize.height - newHeight;
  //         } else if (newY + newHeight > constraints.maxHeight) {
  //           newHeight = constraints.maxHeight - newY;
  //           newWidth = newHeight * widget.aspectRatio!;
  //           newX = _cropPosition.dx + _cropSize.width - newWidth;
  //         }
  //       }

  //       if (corner.contains('bottom')) {
  //         newHeight = (_cropSize.height + details.delta.dy)
  //             .clamp(80.0, constraints.maxHeight - _cropPosition.dy);
  //         newWidth = newHeight * widget.aspectRatio!;
  //         // Check if new width fits
  //         if (corner.contains('left')) {
  //           if (newX + _cropSize.width - newWidth < 0) {
  //             newWidth = _cropSize.width + newX;
  //             newHeight = newWidth / widget.aspectRatio!;
  //           }
  //           newX = _cropPosition.dx + _cropSize.width - newWidth;
  //         } else if (newX + newWidth > constraints.maxWidth) {
  //           newWidth = constraints.maxWidth - newX;
  //           newHeight = newWidth / widget.aspectRatio!;
  //         }
  //       } else if (corner.contains('top')) {
  //         final deltaHeight = -details.delta.dy;
  //         newHeight = (_cropSize.height + deltaHeight)
  //             .clamp(80.0, _cropPosition.dy + _cropSize.height);
  //         newWidth = newHeight * widget.aspectRatio!;
  //         newY = _cropPosition.dy + _cropSize.height - newHeight;
  //         // Check if new width fits
  //         if (corner.contains('left')) {
  //           if (newX + _cropSize.width - newWidth < 0) {
  //             newWidth = _cropSize.width + newX;
  //             newHeight = newWidth / widget.aspectRatio!;
  //             newY = _cropPosition.dy + _cropSize.height - newHeight;
  //           }
  //           newX = _cropPosition.dx + _cropSize.width - newWidth;
  //         } else if (newX + newWidth > constraints.maxWidth) {
  //           newWidth = constraints.maxWidth - newX;
  //           newHeight = newWidth / widget.aspectRatio!;
  //         }
  //       }
  //     } else {
  //       // Free resize - can resize bigger and smaller
  //       if (corner.contains('right')) {
  //         newWidth = (_cropSize.width + details.delta.dx)
  //             .clamp(80.0, constraints.maxWidth - _cropPosition.dx);
  //       } else if (corner.contains('left')) {
  //         final proposedWidth = _cropSize.width - details.delta.dx;
  //         if (proposedWidth >= 80.0 &&
  //             _cropPosition.dx + details.delta.dx >= 0) {
  //           newWidth = proposedWidth;
  //           newX = _cropPosition.dx + details.delta.dx;
  //         }
  //       }

  //       if (corner.contains('bottom')) {
  //         newHeight = (_cropSize.height + details.delta.dy)
  //             .clamp(80.0, constraints.maxHeight - _cropPosition.dy);
  //       } else if (corner.contains('top')) {
  //         final proposedHeight = _cropSize.height - details.delta.dy;
  //         if (proposedHeight >= 80.0 &&
  //             _cropPosition.dy + details.delta.dy >= 0) {
  //           newHeight = proposedHeight;
  //           newY = _cropPosition.dy + details.delta.dy;
  //         }
  //       }
  //     }

  //     _cropSize = Size(newWidth, newHeight);
  //     _cropPosition = Offset(newX, newY);
  //   });
  // }

  Future<String?> _cropAndSaveImage() async {
    if (_image == null) return null;

    setState(() => _isLoading = true);

    try {
      final file = File(widget.imagePath);
      final bytes = await file.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) return null;

      // Calculate scale factors including zoom
      final scaleX = _image!.width / (_displayedImageSize.width / _scale);
      final scaleY = _image!.height / (_displayedImageSize.height / _scale);

      // Convert screen coordinates to image coordinates
      final cropX =
          ((_cropPosition.dx - _displayedImageOffset.dx) / _scale * scaleX)
              .round();
      final cropY =
          ((_cropPosition.dy - _displayedImageOffset.dy) / _scale * scaleY)
              .round();
      final cropWidth = (_cropSize.width / _scale * scaleX).round();
      final cropHeight = (_cropSize.height / _scale * scaleY).round();

      // Crop the image
      final croppedImage = img.copyCrop(
        originalImage,
        x: cropX.clamp(0, originalImage.width),
        y: cropY.clamp(0, originalImage.height),
        width: cropWidth.clamp(0, originalImage.width - cropX),
        height: cropHeight.clamp(0, originalImage.height - cropY),
      );

      // Resize if too large
      img.Image finalImage = croppedImage;
      if (croppedImage.width > 1200 || croppedImage.height > 1200) {
        finalImage = img.copyResize(
          croppedImage,
          width: croppedImage.width > 1200 ? 1200 : null,
          height: croppedImage.height > 1200 ? 1200 : null,
        );
      }

      // Save to temporary file
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final croppedFile = File(tempPath);
      await croppedFile.writeAsBytes(img.encodeJpg(finalImage, quality: 85));

      return tempPath;
    } catch (e) {
      print('Error cropping image: $e');
      return null;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.all(20),
      child: Column(
        children: [
          // Header with zoom controls
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crop Image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _scale = (_scale - 0.2).clamp(0.5, 3.0);
                          _displayedImageSize = Size.zero;
                        });
                      },
                      icon: Icon(Icons.zoom_out, color: Colors.white, size: 28),
                      tooltip: 'Zoom Out',
                    ),
                    Text(
                      '${(_scale * 100).toInt()}%',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _scale = (_scale + 0.2).clamp(0.5, 3.0);
                          _displayedImageSize = Size.zero;
                        });
                      },
                      icon: Icon(Icons.zoom_in, color: Colors.white, size: 28),
                      tooltip: 'Zoom In',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Image with crop overlay
          Expanded(
            child: !_imageLoaded
                ? Center(child: CircularProgressIndicator(color: Colors.white))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_image != null &&
                            _displayedImageSize == Size.zero) {
                          setState(() {
                            _calculateImageDimensions(constraints);
                          });
                        }
                      });

                      return Stack(
                        children: [
                          // The actual image with zoom
                          Center(
                            child: Transform.scale(
                              scale: _scale,
                              child: Image.file(
                                File(widget.imagePath),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),

                          // Dimmed overlay with crop area cutout
                          if (_displayedImageSize != Size.zero)
                            CustomPaint(
                              size: Size(
                                  constraints.maxWidth, constraints.maxHeight),
                              painter: CropOverlayPainter(
                                cropRect: Rect.fromLTWH(
                                  _cropPosition.dx,
                                  _cropPosition.dy,
                                  _cropSize.width,
                                  _cropSize.height,
                                ),
                              ),
                            ),

                          // Draggable crop box with grid and resize handles
                          if (_displayedImageSize != Size.zero)
                            Positioned(
                              left: _cropPosition.dx,
                              top: _cropPosition.dy,
                              child: GestureDetector(
                                onPanUpdate: (details) {
                                  setState(() {
                                    final newX =
                                        _cropPosition.dx + details.delta.dx;
                                    final newY =
                                        _cropPosition.dy + details.delta.dy;

                                    _cropPosition = Offset(
                                      newX.clamp(
                                          0.0,
                                          constraints.maxWidth -
                                              _cropSize.width),
                                      newY.clamp(
                                          0.0,
                                          constraints.maxHeight -
                                              _cropSize.height),
                                    );
                                  });
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      width: _cropSize.width,
                                      height: _cropSize.height,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                      ),
                                      child: CustomPaint(
                                        painter: GridPainter(),
                                      ),
                                    ),
                                    // Corner resize handles
                                    ..._buildResizeHandles(constraints),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
          ),

          // Bottom action buttons
          Container(
            padding: EdgeInsets.all(20),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context, null),
                      icon: Icon(Icons.close, size: 24),
                      label: Text('Cancel', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(0, 50),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: ElevatedButton.icon(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              final croppedPath = await _cropAndSaveImage();
                              if (croppedPath != null) {
                                Navigator.pop(context, croppedPath);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to crop image'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                      icon: _isLoading
                          ? SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Icon(Icons.check, size: 24),
                      label: Text('Crop', style: TextStyle(fontSize: 16)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        minimumSize: Size(0, 50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildResizeHandles(BoxConstraints constraints) {
    const handleSize = 30.0; // Larger handles for easier grabbing
    const handleColor = Colors.white;

    return [
      // Top-left
      _buildHandle(-handleSize / 2, -handleSize / 2, handleColor, (details) {
        _handleResize(details, 'top-left', constraints);
      }),
      // Top-right
      _buildHandle(
          _cropSize.width - handleSize / 2, -handleSize / 2, handleColor,
          (details) {
        _handleResize(details, 'top-right', constraints);
      }),
      // Bottom-left
      _buildHandle(
          -handleSize / 2, _cropSize.height - handleSize / 2, handleColor,
          (details) {
        _handleResize(details, 'bottom-left', constraints);
      }),
      // Bottom-right
      _buildHandle(_cropSize.width - handleSize / 2,
          _cropSize.height - handleSize / 2, handleColor, (details) {
        _handleResize(details, 'bottom-right', constraints);
      }),
      // Middle handles for easier resizing
      // Top-middle
      _buildHandle(
          _cropSize.width / 2 - handleSize / 2, -handleSize / 2, handleColor,
          (details) {
        _handleResize(details, 'top', constraints);
      }),
      // Bottom-middle
      _buildHandle(_cropSize.width / 2 - handleSize / 2,
          _cropSize.height - handleSize / 2, handleColor, (details) {
        _handleResize(details, 'bottom', constraints);
      }),
      // Left-middle
      _buildHandle(
          -handleSize / 2, _cropSize.height / 2 - handleSize / 2, handleColor,
          (details) {
        _handleResize(details, 'left', constraints);
      }),
      // Right-middle
      _buildHandle(_cropSize.width - handleSize / 2,
          _cropSize.height / 2 - handleSize / 2, handleColor, (details) {
        _handleResize(details, 'right', constraints);
      }),
    ];
  }

  Widget _buildHandle(double left, double top, Color color,
      Function(DragUpdateDetails) onDrag) {
    const handleSize = 30.0;
    return Positioned(
      left: left,
      top: top,
      child: GestureDetector(
        onPanUpdate: onDrag,
        child: Container(
          width: handleSize,
          height: handleSize,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }
}

class CropOverlayPainter extends CustomPainter {
  final Rect cropRect;

  CropOverlayPainter({required this.cropRect});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path = Path.combine(
      PathOperation.difference,
      Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
      Path()..addRect(cropRect),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CropOverlayPainter oldDelegate) =>
      cropRect != oldDelegate.cropRect;
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 1;

    for (int i = 1; i < 3; i++) {
      canvas.drawLine(
        Offset(size.width * i / 3, 0),
        Offset(size.width * i / 3, size.height),
        paint,
      );
      canvas.drawLine(
        Offset(0, size.height * i / 3),
        Offset(size.width, size.height * i / 3),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(GridPainter oldDelegate) => false;
}
