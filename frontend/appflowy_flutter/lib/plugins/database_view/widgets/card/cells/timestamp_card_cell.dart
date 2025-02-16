import 'package:appflowy/plugins/database_view/application/cell/cell_controller_builder.dart';
import 'package:appflowy/plugins/database_view/widgets/card/bloc/timestamp_card_cell_bloc.dart';
import 'package:flowy_infra_ui/style_widget/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../define.dart';
import 'card_cell.dart';

class TimestampCardCell<CustomCardData> extends CardCell {
  final CellControllerBuilder cellControllerBuilder;
  final CellRenderHook<dynamic, CustomCardData>? renderHook;

  const TimestampCardCell({
    required this.cellControllerBuilder,
    this.renderHook,
    Key? key,
  }) : super(key: key);

  @override
  State<TimestampCardCell> createState() => _TimestampCardCellState();
}

class _TimestampCardCellState extends State<TimestampCardCell> {
  late TimestampCardCellBloc _cellBloc;

  @override
  void initState() {
    final cellController =
        widget.cellControllerBuilder.build() as TimestampCellController;

    _cellBloc = TimestampCardCellBloc(cellController: cellController)
      ..add(const TimestampCardCellEvent.initial());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cellBloc,
      child: BlocBuilder<TimestampCardCellBloc, TimestampCardCellState>(
        buildWhen: (previous, current) => previous.dateStr != current.dateStr,
        builder: (context, state) {
          if (state.dateStr.isEmpty) {
            return const SizedBox.shrink();
          }
          final Widget? custom = widget.renderHook?.call(
            state.data,
            widget.cardData,
            context,
          );
          if (custom != null) {
            return custom;
          }

          return Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: CardSizes.cardCellVPadding,
              ),
              child: FlowyText.regular(
                state.dateStr,
                fontSize: 13,
                color: Theme.of(context).hintColor,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> dispose() async {
    _cellBloc.close();
    super.dispose();
  }
}
