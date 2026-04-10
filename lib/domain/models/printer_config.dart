import 'package:freezed_annotation/freezed_annotation.dart';

part 'printer_config.freezed.dart';
part 'printer_config.g.dart';

enum PrinterConnectionType {
  bluetooth,
  usb,
  network,
  rawbt
}

enum PrinterPaperSize {
  mm58,
  mm80
}

@freezed
class PrinterConfig with _$PrinterConfig {
  const factory PrinterConfig({
    @Default(PrinterConnectionType.rawbt) PrinterConnectionType connectionType,
    @Default(PrinterPaperSize.mm58) PrinterPaperSize paperSize,
    String? address, // Mac address for BT, IP for Network, VendorID/ProductID for USB
    @Default(9100) int port,
    @Default('Default Printer') String name,
    @Default(true) bool autoPrintKOT,
    @Default(true) bool autoPrintBill,
  }) = _PrinterConfig;

  factory PrinterConfig.fromJson(Map<String, dynamic> json) => _$PrinterConfigFromJson(json);
}
