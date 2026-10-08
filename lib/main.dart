import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const AudioChurchApp());

class AudioChurchApp extends StatelessWidget {
  const AudioChurchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dimensionamento Chiese Audio',
      theme: ThemeData(colorSchemeSeed: Colors.amber, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class Result {
  final int count;
  final String model;
  final double tap;
  final double load;
  final int amp;
  final double spacing;
  final double height;

  const Result({
    required this.count,
    required this.model,
    required this.tap,
    required this.load,
    required this.amp,
    required this.spacing,
    required this.height,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController lengthController = TextEditingController(text: '30');
  final TextEditingController widthController = TextEditingController(text: '10');
  final TextEditingController roomHeightController = TextEditingController(text: '8');

  String acoustics = 'Riverberante';
  String model = 'Automatico';
  Result? result;

  @override
  void dispose() {
    lengthController.dispose();
    widthController.dispose();
    roomHeightController.dispose();
    super.dispose();
  }

  void calculate() {
    final double? length = double.tryParse(lengthController.text.replaceAll(',', '.'));
    final double? width = double.tryParse(widthController.text.replaceAll(',', '.'));
    final double? roomHeight = double.tryParse(roomHeightController.text.replaceAll(',', '.'));

    if (length == null || width == null || roomHeight == null ||
        length <= 0 || width <= 0 || roomHeight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci dimensioni valide.')),
      );
      return;
    }

    final double spacing = switch (acoustics) {
      'Normale' => 7.0,
      'Riverberante' => 5.5,
      _ => 4.5,
    };

    int count = math.max(2, (length / spacing).ceil());
    if (width > 12) count *= 2;

    final String selectedModel = model == 'Automatico'
        ? (acoustics == 'Normale' ? 'Colonna 50 W' : 'DAP CS-330')
        : model;

    final double tap;
    if (selectedModel == 'DAP CS-330') {
      tap = acoustics == 'Molto riverberante' ? 10.0 : 20.0;
    } else {
      tap = acoustics == 'Molto riverberante' ? 12.5 : 25.0;
    }

    final double load = count * tap;
    final int amp = ((load * 1.30) / 50).ceil() * 50;
    final double installHeight = math.min(3.5, math.max(2.5, roomHeight * 0.35));

    setState(() {
      result = Result(
        count: count,
        model: selectedModel,
        tap: tap,
        load: load,
        amp: amp,
        spacing: spacing,
        height: installHeight,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final Result? currentResult = result;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dimensionamento Chiese Audio'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dati della chiesa', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _field(lengthController, 'Lunghezza (m)')),
                          const SizedBox(width: 10),
                          Expanded(child: _field(widthController, 'Larghezza (m)')),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _field(roomHeightController, 'Altezza (m)'),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: acoustics,
                        decoration: const InputDecoration(
                          labelText: 'Acustica',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Normale', child: Text('Normale')),
                          DropdownMenuItem(value: 'Riverberante', child: Text('Riverberante')),
                          DropdownMenuItem(value: 'Molto riverberante', child: Text('Molto riverberante')),
                        ],
                        onChanged: (String? value) {
                          if (value != null) setState(() => acoustics = value);
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        initialValue: model,
                        decoration: const InputDecoration(
                          labelText: 'Diffusore',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Automatico', child: Text('Automatico')),
                          DropdownMenuItem(value: 'DAP CS-330', child: Text('DAP CS-330 — 10/20 W')),
                          DropdownMenuItem(value: 'Colonna 50 W', child: Text('Colonna 50 W — 12,5/25/50 W')),
                        ],
                        onChanged: (String? value) {
                          if (value != null) setState(() => model = value);
                        },
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        height: 50,
                        child: FilledButton.icon(
                          onPressed: calculate,
                          icon: const Icon(Icons.calculate),
                          label: const Text('CALCOLA DIMENSIONAMENTO'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (currentResult != null) ...[
                const SizedBox(height: 14),
                _resultCard(currentResult),
                const SizedBox(height: 14),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Schema indicativo', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 240,
                          child: ChurchPainterView(
                            result: currentResult,
                            length: double.parse(lengthController.text.replaceAll(',', '.')),
                            width: double.parse(widthController.text.replaceAll(',', '.')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Card(
                  color: Color(0xFFFFF8E1),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Text(
                      'NOTA TECNICA\nQuesto è un dimensionamento preliminare. Per il progetto definitivo occorre verificare direttività reale, riverbero, rumore di fondo, SPL richiesto e caratteristiche acustiche della chiesa.',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
    );
  }

  Widget _resultCard(Result r) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Configurazione consigliata', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            _line('Diffusori', '${r.count} × ${r.model}'),
            _line('Presa 100 V', '${_formatWatts(r.tap)} W per diffusore'),
            _line('Carico totale', '${r.load.toStringAsFixed(1)} W'),
            _line('Amplificatore', '${r.amp} W — 100 V'),
            _line('Interasse indicativo', '${r.spacing.toStringAsFixed(1)} m'),
            _line('Altezza installazione', '${r.height.toStringAsFixed(1)} m'),
          ],
        ),
      ),
    );
  }

  Widget _line(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String _formatWatts(double value) {
    return value == value.roundToDouble() ? value.toStringAsFixed(0) : value.toStringAsFixed(1);
  }
}

class ChurchPainterView extends StatelessWidget {
  final Result result;
  final double length;
  final double width;

  const ChurchPainterView({
    super.key,
    required this.result,
    required this.length,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: ChurchPainter(result),
      child: const SizedBox.expand(),
    );
  }
}

class ChurchPainter extends CustomPainter {
  final Result result;

  ChurchPainter(this.result);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;
    final Rect rect = Rect.fromLTWH(20, 25, size.width - 40, size.height - 50);

    paint.color = Colors.grey.shade200;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(10)),
      paint,
    );

    paint.color = Colors.amber.shade700;
    for (int i = 0; i < result.count; i++) {
      final double x = rect.left + rect.width * ((i + 0.5) / result.count);
      final double y = i.isEven ? rect.top + 25 : rect.bottom - 25;
      canvas.drawCircle(Offset(x, y), 7, paint);
    }

    final TextPainter text = TextPainter(
      text: TextSpan(
        text: '${result.count} diffusori',
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    text.paint(
      canvas,
      Offset((size.width - text.width) / 2, size.height / 2 - 7),
    );
  }

  @override
  bool shouldRepaint(covariant ChurchPainter oldDelegate) {
    return oldDelegate.result.count != result.count ||
        oldDelegate.result.model != result.model;
  }
}
