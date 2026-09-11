import 'package:car_rental_customerPanel/Resources/Color.dart';
import 'package:car_rental_customerPanel/Resources/TextTheme.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:flutter/services.dart';


class GovIdPdfViewer extends StatefulWidget {
  final String? assetPath;
  final Uint8List? pdfBytes;
  final String title;

  const GovIdPdfViewer({
    super.key,
    this.assetPath,
    this.pdfBytes,
    required this.title,
  });

  @override
  State<GovIdPdfViewer> createState() => _GovIdPdfViewerState();
}

class _GovIdPdfViewerState extends State<GovIdPdfViewer> {
  final PdfViewerController _pdfViewerController = PdfViewerController();
  int _totalPages = 0;
  int _currentPage = 1;
  bool _isLoading = true;
  String? _errorMessage;

  bool get _isImage {
    if (widget.assetPath == null) return false;
    final path = widget.assetPath!.toLowerCase();
    return path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.webp');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor,
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        elevation: 0.5,
        title: Text(
          widget.title,
          style: TTextTheme.h2Style(context).copyWith(color: Colors.white),
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                     Icon(Icons.error_outline, color: AppColors.primaryColor, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      _errorMessage!,
                      style: TTextTheme.titleThree(context).copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else if (widget.pdfBytes != null)
            SfPdfViewer.memory(
              widget.pdfBytes!,
              controller: _pdfViewerController,
              onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                setState(() {
                  _totalPages = details.document.pages.count;
                  _isLoading = false;
                });
              },
              onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = "PDF Load Failed: ${details.description}";
                });
              },
              onPageChanged: (PdfPageChangedDetails details) {
                setState(() {
                  _currentPage = details.newPageNumber;
                });
              },
            )
          else if (widget.assetPath != null && _isImage)
              Center(
                child: InteractiveViewer(
                  child: Image.asset(
                    widget.assetPath!,
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_isLoading) setState(() => _isLoading = false);
                        });
                        return child;
                      }
                      return const SizedBox();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_isLoading || _errorMessage == null) {
                          setState(() {
                            _isLoading = false;
                            _errorMessage = "Image asset not found at:\n${widget.assetPath}";
                          });
                        }
                      });
                      return const SizedBox();
                    },
                  ),
                ),
              )
            else if (widget.assetPath != null)
                SfPdfViewer.asset(
                  widget.assetPath!,
                  controller: _pdfViewerController,
                  onDocumentLoaded: (PdfDocumentLoadedDetails details) {
                    setState(() {
                      _totalPages = details.document.pages.count;
                      _isLoading = false;
                    });
                  },
                  onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
                    setState(() {
                      _isLoading = false;
                      _errorMessage = "Document Load Failed!\nCheck if file exists at:\n${widget.assetPath}";
                    });
                  },
                  onPageChanged: (PdfPageChangedDetails details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });
                  },
                )
              else
                 Center(
                  child: Text(
                    "No Document Available",
                    style: TTextTheme.ErrorStyle(context),
                  ),
                ),
          if (_isLoading && _errorMessage == null)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            ),
          if (!_isLoading && _errorMessage == null && !_isImage && _totalPages > 0)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.blackColor.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    "Page $_currentPage / $_totalPages",
                    style: TTextTheme.titleThree(context).copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}