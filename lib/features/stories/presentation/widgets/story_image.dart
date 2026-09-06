import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Resolves [url] and reports load completion exactly once via
/// [onLoaded]/[onError], independent of the widget's own rebuild cycle
/// (which ticks every frame alongside the progress bar animation). The
/// story viewer uses this to know when it's safe to start the timer.
class StoryImage extends StatefulWidget {
  const StoryImage({
    super.key,
    required this.url,
    required this.onLoaded,
    required this.onError,
  });

  final String url;
  final VoidCallback onLoaded;
  final VoidCallback onError;

  @override
  State<StoryImage> createState() => _StoryImageState();
}

class _StoryImageState extends State<StoryImage> {
  late final ImageProvider _provider;
  ImageStream? _stream;
  ImageStreamListener? _listener;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _provider = CachedNetworkImageProvider(widget.url);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolve();
  }

  void _resolve() {
    final ImageStream newStream =
        _provider.resolve(createLocalImageConfiguration(context));
    if (_stream?.key == newStream.key) return;
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _stream = newStream;
    _listener = ImageStreamListener(
      (image, synchronousCall) {
        if (_resolved) return;
        _resolved = true;
        widget.onLoaded();
      },
      onError: (error, stackTrace) {
        if (_resolved) return;
        _resolved = true;
        widget.onError();
      },
    );
    _stream!.addListener(_listener!);
  }

  @override
  void dispose() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image(
      image: _provider,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
