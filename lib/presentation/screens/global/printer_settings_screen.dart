import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/print_service.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/base_widgets.dart';

final printServiceProvider = Provider<PrintService>((ref) => PrintService());

class PrinterSettingsScreen extends ConsumerStatefulWidget {
  const PrinterSettingsScreen({super.key});

  @override
  ConsumerState<PrinterSettingsScreen> createState() => _PrinterSettingsScreenState();
}

class _PrinterSettingsScreenState extends ConsumerState<PrinterSettingsScreen> {
  String _selectedPaperSize = '58mm';
  bool _useRawBT = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedPaperSize = prefs.getString('printer_paper_size') ?? '58mm';
      _useRawBT = prefs.getBool('use_rawbt') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_paper_size', _selectedPaperSize);
    await prefs.setBool('use_rawbt', _useRawBT);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Printer settings saved successfully')),
      );
    }
  }

  Future<void> _handleTestPrint() async {
    try {
      final printService = ref.read(printServiceProvider);
      // Create simple test bytes
      final List<int> testBytes = [27, 64, 10, 84, 101, 115, 116, 32, 80, 114, 105, 110, 116, 10, 10, 27, 109];
      
      await printService.sendToRawBT(testBytes);
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Print Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: LoadingIndicator(message: 'Loading printer config...'));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer Settings'),
        actions: [
          IconButton(
            onPressed: _saveSettings,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ListView(
        children: [
          _buildSectionHeader(context, 'Configuration'),
          ListTile(
            title: const Text('Paper Size'),
            subtitle: Text('Current: $_selectedPaperSize'),
            leading: const Icon(Icons.straighten),
            onTap: () => _showPaperSizeDialog(),
          ),
          SwitchListTile(
            title: const Text('Use RawBT App'),
            subtitle: const Text('Recommended for Android Thermal Printers'),
            value: _useRawBT,
            onChanged: (val) {
              setState(() => _useRawBT = val);
            },
            secondary: const Icon(Icons.settings_remote),
          ),
          const Divider(),
          _buildSectionHeader(context, 'Tools'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: _handleTestPrint,
              icon: const Icon(Icons.print),
              label: const Text('Print Test Receipt'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton.icon(
              onPressed: () {
                ConfirmationDialog.show(
                  context: context,
                  title: 'Reset Printer Settings?',
                  message: 'This will revert all printer custom configurations to defaults.',
                  onConfirm: () {
                    setState(() {
                      _selectedPaperSize = '58mm';
                      _useRawBT = true;
                    });
                    _saveSettings();
                  },
                );
              },
              icon: const Icon(Icons.restart_alt, color: Colors.orange),
              label: const Text('Reset to Defaults', style: TextStyle(color: Colors.orange)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPaperSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Paper Size'),
        children: [
          RadioListTile<String>(
            title: const Text('58mm (2 inch)'),
            value: '58mm',
            groupValue: _selectedPaperSize,
            onChanged: (val) {
              setState(() => _selectedPaperSize = val!);
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('80mm (3 inch)'),
            value: '80mm',
            groupValue: _selectedPaperSize,
            onChanged: (val) {
              setState(() => _selectedPaperSize = val!);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.blueAccent,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
