import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_pos_printer_platform_image_3/flutter_pos_printer_platform_image_3.dart';
import '../../providers/printer_provider.dart';
import '../../../domain/models/printer_config.dart';
import '../../../services/print_service.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/base_widgets.dart';
import '../../../core/app_theme.dart';


class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  final List<PrinterDevice> _bluetoothDevices = [];
  final List<PrinterDevice> _usbDevices = [];

  StreamSubscription? _scanSubscription;
  bool _isScanning = false;
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final config = ref.read(printerConfigProvider);
    _ipController.text = config.address ?? '';
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _ipController.dispose();
    super.dispose();
  }

  void _startScan() {
    setState(() {
      _bluetoothDevices.clear();
      _usbDevices.clear();
      _isScanning = true;
    });

    final config = ref.read(printerConfigProvider);
    PrinterType type;
    switch (config.connectionType) {
      case PrinterConnectionType.bluetooth:
        type = PrinterType.bluetooth;
        break;
      case PrinterConnectionType.usb:
        type = PrinterType.usb;
        break;
      default:
        setState(() => _isScanning = false);
        return;
    }

    _scanSubscription = PrinterManager.instance.discovery(type: type).listen((device) {
      if (!mounted) return;
      setState(() {
        if (type == PrinterType.bluetooth) {
          if (!_bluetoothDevices.any((d) => d.address == device.address)) {
            _bluetoothDevices.add(device);
          }
        } else if (type == PrinterType.usb) {
          if (!_usbDevices.any((d) => d.vendorId == device.vendorId)) {
            _usbDevices.add(device);
          }
        }
      });
    }, onDone: () {

      setState(() => _isScanning = false);
    }, onError: (e) {
      setState(() => _isScanning = false);
      _showError('Scan Error: $e');
    });
  }

  void _stopScan() {
    _scanSubscription?.cancel();
    setState(() => _isScanning = false);
  }

  Future<void> _handleTestPrint() async {
    try {
      final printService = ref.read(printServiceProvider);
      final config = ref.read(printerConfigProvider);
      
      // Basic ESC/POS Test
      final List<int> testBytes = [
        27, 64, // Initialize
        10, 
        ...utf8.encode('--- Shree Rajmandir ---\n'),
        ...utf8.encode('TEST PRINT SUCCESSFUL\n'),
        ...utf8.encode('Paper Size: ${config.paperSize.name}\n'),
        ...utf8.encode('Conn: ${config.connectionType.name}\n'),
        10, 10, 
        27, 109 // Cut
      ];
      
      await printService.printReceipt(testBytes, config);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Test print sent!'), backgroundColor: AppTheme.successGreen),
        );
      }
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Printer Error'),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(printerConfigProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: AppBar(
        title: const Text('Hardware Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppTheme.maroon,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildSectionHeader('Printer Connection'),
          _buildConnectionTypes(config),
          
          if (config.connectionType == PrinterConnectionType.network) ...[
            const SizedBox(height: 16),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Printer IP Address',
                hintText: 'e.g. 192.168.1.100',
                border: OutlineInputBorder(),
              ),
              onChanged: (val) => ref.read(printerConfigProvider.notifier).updateAddress(val),
            ),
          ],

          if (config.connectionType == PrinterConnectionType.bluetooth || 
              config.connectionType == PrinterConnectionType.usb) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available Devices', style: theme.textTheme.titleMedium),
                if (_isScanning)
                  const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                else
                  TextButton.icon(
                    onPressed: _startScan,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Scan'),
                  ),
              ],
            ),
            _buildDeviceList(config),
          ],

          const Divider(height: 48),
          _buildSectionHeader('Preferences'),
          _buildPaperSizeSelector(config),
          
          SwitchListTile(
            title: const Text('Auto-print KOT'),
            subtitle: const Text('Print KOT immediately after submission'),
            value: config.autoPrintKOT,
            activeColor: AppTheme.maroon,
            onChanged: (val) => ref.read(printerConfigProvider.notifier).toggleAutoKOT(val),
          ),
          SwitchListTile(
            title: const Text('Auto-print Bills'),
            subtitle: const Text('Print bill immediately after checkout'),
            value: config.autoPrintBill,
            activeColor: AppTheme.maroon,
            onChanged: (val) => ref.read(printerConfigProvider.notifier).toggleAutoBill(val),
          ),

          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _handleTestPrint,
            icon: const Icon(Icons.print),
            label: const Text('Send Test Receipt'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.maroon,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          
          TextButton(
            onPressed: () {
              ConfirmationDialog.show(
                context: context,
                title: 'Reset Hardware?',
                message: 'Clear all saved printer addresses and types?',
                onConfirm: () {
                  ref.read(printerConfigProvider.notifier).updateConfig(const PrinterConfig());
                  _ipController.clear();
                },
              );
            },
            child: const Text('Reset to Factory Defaults', style: TextStyle(color: Colors.grey)),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: AppTheme.maroon,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildConnectionTypes(PrinterConfig config) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _connectionTile(PrinterConnectionType.bluetooth, 'Bluetooth', Icons.bluetooth, config),
          _connectionTile(PrinterConnectionType.usb, 'USB', Icons.usb, config),
          _connectionTile(PrinterConnectionType.network, 'Network (IP)', Icons.lan, config),
          _connectionTile(PrinterConnectionType.rawbt, 'RawBT (Android)', Icons.android, config),
        ],
      ),
    );
  }

  Widget _connectionTile(PrinterConnectionType type, String title, IconData icon, PrinterConfig config) {
    final isSelected = config.connectionType == type;
    return RadioListTile<PrinterConnectionType>(
      title: Text(title),
      secondary: Icon(icon, color: isSelected ? AppTheme.maroon : Colors.grey),
      value: type,
      groupValue: config.connectionType,
      activeColor: AppTheme.maroon,
      onChanged: (val) {
        if (val != null) {
          ref.read(printerConfigProvider.notifier).updateConnectionType(val);
          _stopScan();
        }
      },
    );
  }

  Widget _buildDeviceList(PrinterConfig config) {
    final devices = config.connectionType == PrinterConnectionType.bluetooth ? _bluetoothDevices : _usbDevices;
    
    if (devices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        alignment: Alignment.center,
        child: const Text('No devices found. Tap Scan.', style: TextStyle(color: Colors.grey)),
      );
    }


    return Column(
      children: devices.map<Widget>((device) {
        String name = '';
        String address = '';
        if (config.connectionType == PrinterConnectionType.bluetooth) {
          name = device.name;
          address = device.address ?? '';
        } else if (config.connectionType == PrinterConnectionType.usb) {
          name = device.name;
          address = '${device.vendorId}:${device.productId}';
        }

        final isSelected = config.address == address;
        return ListTile(
          title: Text(name),
          subtitle: Text(address),
          trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.successGreen) : null,
          onTap: () {
            ref.read(printerConfigProvider.notifier).updateAddress(address);
            ref.read(printerConfigProvider.notifier).updateName(name);
          },
        );
      }).toList(),
    );

  }

  Widget _buildPaperSizeSelector(PrinterConfig config) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ChoiceChip(
            label: const Text('58mm'),
            selected: config.paperSize == PrinterPaperSize.mm58,
            onSelected: (val) => ref.read(printerConfigProvider.notifier).updatePaperSize(PrinterPaperSize.mm58),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('80mm'),
            selected: config.paperSize == PrinterPaperSize.mm80,
            onSelected: (val) => ref.read(printerConfigProvider.notifier).updatePaperSize(PrinterPaperSize.mm80),
          ),
        ],
      ),
    );
  }
}
