import 'package:easeops_web_hrms/app_export.dart';

class CustomShowNetworkImage extends StatelessWidget {
  const CustomShowNetworkImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.boxFit,
    super.key,
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        } else {
          return const CircularProgressIndicator();
        }
      },
      imageUrl,
      height: height,
      width: width,
      fit: boxFit ?? BoxFit.cover,
      errorBuilder: (
        BuildContext context,
        Object exception,
        StackTrace? stackTrace,
      ) {
        return SizedBox(
          height: height,
          width: width,
          child: const Icon(
            Icons.error,
            color: Colors.red,
            size: 20,
          ),
        );
      },
    );
  }
}
