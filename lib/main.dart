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
  Result(this.count, this.model, this.tap, this.load, this.amp, this.spacing, this.height);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final length = TextEditingController(text: '30');
  final width = TextEditingController(text: '10');
  final roomHeight = TextEditingController(text: '8');
  String acoustics = 'Riverberante';
  String model = 'Automatico';
  Result? result;

  @override void dispose() { length.dispose(); width.dispose(); roomHeight.dispose(); super.dispose(); }

  void calculate() {
    final l = double.tryParse(length.text.replaceAll(',', '.'));
    final w = double.tryParse(width.text.replaceAll(',', '.'));
    final h = double.tryParse(roomHeight.text.replaceAll(',', '.'));
    if (l == null || w == null || h == null || l <= 0 || w <= 0 || h <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inserisci dimensioni valide.')));
      return;
    }
    final spacing = acoustics == 'Normale' ? 7.0 : acoustics == 'Riverberante' ? 5.5 : 4.5;
    var count = math.max(2, (l / spacing).ceil());
    if (w > 12) count *= 2;
    final selected = model == 'Automatico' ? (acoustics == 'Normale' ? 'Colonna 50 W' : 'DAP CS-330') : model;
    double tap;
    if (selected == 'DAP CS-330') tap = acoustics == 'Molto riverberante' ? 10 : 20;
    else tap = acoustics == 'Molto riverberante' ? 12.5 : 25;
    final load = count * tap;
    final amp = ((load * 1.30) / 50).ceil() * 50;
    final installHeight = math.min(3.5, math.max(2.5, h * .35));
    setState(() => result = Result(count, selected, tap, load, amp, spacing, installHeight));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dimensionamento Chiese Audio'), centerTitle: true),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Dati della chiesa', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(children: [Expanded(child: _field(length, 'Lunghezza (m)')), const SizedBox(width: 10), Expanded(child: _field(width, 'Larghezza (m)'))]),
          const SizedBox(height: 10), _field(roomHeight, 'Altezza (m)'),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(value: acoustics, decoration: const InputDecoration(labelText: 'Acustica', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'Normale', child: Text('Normale')), DropdownMenuItem(value: 'Riverberante', child: Text('Riverberante')), DropdownMenuItem(value: 'Molto riverberante', child: Text('Molto riverberante'))], onChanged: (v) => setState(() => acoustics = v!)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(value: model, decoration: const InputDecoration(labelText: 'Diffusore', border: OutlineInputBorder()), items: const [DropdownMenuItem(value: 'Automatico', child: Text('Automatico')), DropdownMenuItem(value: 'DAP CS-330', child: Text('DAP CS-330 — 10/20 W')), DropdownMenuItem(value: 'Colonna 50 W', child: Text('Colonna 50 W — 12,5/25/50 W'))], onChanged: (v) => setState(() => model = v!)),
          const SizedBox(height: 14),
          SizedBox(height: 50, child: FilledButton.icon(onPressed: calculate, icon: const Icon(Icons.calculate), label: const Text('CALCOLA DIMENSIONAMENTO'))),
        ]))),
        if (result != null) ...[
          const SizedBox(height: 14),
          _resultCard(result!),
          const SizedBox(height: 14),
          Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Schema indicativo', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 8), SizedBox(height: 240, child: ChurchPainterView(result: result!, length: double.parse(length.text.replaceAll(',', '.')), width: double.parse(width.text.replaceAll(',', '.'))))])),
          const SizedBox(height: 10),
          const Card(color: Color(0xFFFFF8E1), child: Padding(padding: EdgeInsets.all(14), child: Text('NOTA TECNICA\nQuesto è un dimensionamento preliminare. Per il progetto definitivo occorre verificare direttività reale, riverbero, rumore di fondo, SPL richiesto e caratteristiche acustiche della chiesa.', style: TextStyle(fontWeight: FontWeight.w600)))),
        ]
      ]))),
    );
  }

  Widget _field(TextEditingController c, String label) => TextField(controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()));

  Widget _resultCard(Result r) => Card(elevation: 2, child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text('Configurazione consigliata', style: Theme.of(context).textTheme.titleLarge), const SizedBox(height: 10),
    _line('Diffusori', '${r.count} × ${r.model}'), _line('Presa 100 V', '${r.tap} W per diffusore'), _line('Carico totale', '${r.load.toStringAsFixed(1)} W'), _line('Amplificatore', '${r.amp} W — 100 V'), _line('Interasse indicativo', '${r.spacing.toStringAsFixed(1)} m'), _line('Altezza installazione', '${r.height.toStringAsFixed(1)} m'),
  ]));
  Widget _line(String a, String b) => Padding(padding: const EdgeInsets.symmetric(vertical: 5), child: Row(children: [Expanded(child: Text(a)), Text(b, style: const TextStyle(fontWeight: FontWeight.bold))]));
}

class ChurchPainterView extends StatelessWidget {
  final Result result; final double length, width;
  const ChurchPainterView({super.key, required this.result, required this.length, required this.width});
  @override Widget build(BuildContext context) => CustomPaint(painter: ChurchPainter(result), child: const SizedBox.expand());
}
class ChurchPainter extends CustomPainter {
  final Result result; ChurchPainter(this.result);
  @override void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(20, 25, size.width - 40, size.height - 50);
    paint.color = Colors.grey.shade200; canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(10)), paint);
    paint.color = Colors.amber.shade700;
    for (int i = 0; i < result.count; i++) {
      final x = rect.left + rect.width * ((i + .5) / result.count);
      final y = i.isEven ? rect.top + 25 : rect.bottom - 25;
      canvas.drawCircle(Offset(x, y), 7, paint);
    }
    final text = TextPainter(text: TextSpan(text: '${result.count} diffusori', style: const TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.bold)), textDirection: TextDirection.ltr)..layout();
    text.paint(canvas, Offset((size.width - text.width) / 2, size.height / 2 - 7));
  }
  @override bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
