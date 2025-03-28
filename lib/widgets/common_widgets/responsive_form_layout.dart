import 'package:easeops_web_hrms/app_export.dart';

class ResponsiveFormLayout extends StatelessWidget {
  const ResponsiveFormLayout({
    required this.children,
    required this.childPerRow,
    super.key,
    this.buttons,
    this.wrapAlignment,
    this.wrapSpacing,
    this.runSpacing,
    this.flex,
    this.flexForChildren = 0,
  });
  final List<Widget> children;
  final int childPerRow;
  final List<Widget>? buttons;
  final WrapAlignment? wrapAlignment;
  final double? wrapSpacing;
  final double? runSpacing;
  final int? flex;
  final int flexForChildren;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: childPerRow > 1 ? _buildRows(childPerRow) : _buildCols(),
    );
  }

  List<Widget> _buildRows(int childrenPerRow) {
    final rows = <Widget>[];

    for (var i = 0; i < children.length; i += childrenPerRow) {
      final rowChildren = <Widget>[];

      for (var j = 0; j < childrenPerRow; j++) {
        final currentIndex = i + j;
        if (currentIndex < children.length) {
          rowChildren.add(
            Expanded(
              flex: flex != null && j == flexForChildren ? flex! : 1,
              child: children[currentIndex],
            ),
          );

          if (j < childrenPerRow - 1) {
            rowChildren.add(const SizedBox(width: 16));
          }
        } else {
          rowChildren.add(const Spacer());
          // break; ** I have comment this because if item has only 1 in row so need to add 2 Spacer
        }
      }

      rows
        ..add(
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: rowChildren,
            ),
          ),
        )
        ..add(const SizedBox(height: 16));
    }
    if (buttons != null) rows.add(buttonsView());
    return rows;
  }

  List<Widget> _buildCols() {
    final cols = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      cols
        ..add(children[i])
        ..add(const SizedBox(height: 16));
    }
    if (buttons != null) cols.add(buttonsView());
    return cols;
  }

  Widget buttonsView() {
    return ListView(
      shrinkWrap: true,
      children: [
        Wrap(
          alignment: wrapAlignment == null
              ? childPerRow == 1
                  ? WrapAlignment.center
                  : WrapAlignment.start
              : wrapAlignment!,
          spacing: wrapSpacing ?? 16.0,
          runSpacing: runSpacing ?? 16.0,
          children: buttons!,
        ),
      ],
    );
  }
}
