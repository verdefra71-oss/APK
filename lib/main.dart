import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const AudioChurchApp());

class AudioChurchApp extends StatelessWidget {
  const AudioChurchApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Dimensionamento Audio Chiese',
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink), useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final l = TextEditingController(text: '30');
  final w = TextEditingController(text: '12');
  final h = TextEditingController(text: '8');
  final navate = TextEditingController(text: '1');
  String forma = 'Navata rettangolare';
  String riverbero = 'Normale';
  String diffusore = 'Automatico';
  String risultato = '';
  int nDiff = 0;

  void calcola() {
    final length = double.tryParse(l.text.replaceAll(',', '.')) ?? 0;
    final width = double.tryParse(w.text.replaceAll(',', '.')) ?? 0;
    final height = double.tryParse(h.text.replaceAll(',', '.')) ?? 0;
    final n = math.max(1, int.tryParse(navate.text) ?? 1);
    if (length <= 0 || width <= 0 || height <= 0) {
      setState(() => risultato = 'Inserisci dimensioni valide.');
      return;
    }

    final passo = riverbero == 'Normale' ? 7.0 : riverbero == 'Riverberante' ? 5.5 : 4.5;
    int count;
    switch (forma) {
      case 'Circolare':
        count = math.max(4, (math.pi * width / passo).ceil());
        break;
      case 'Quadrata':
        count = math.max(4, (4 * width / passo).ceil());
        break;
      case 'Croce latina':
        count = math.max(2, (length / passo).ceil()) + math.max(2, (width / passo).ceil());
        break;
      case 'Croce greca':
        count = math.max(4, 2 * (length / passo).ceil());
        break;
      default:
        count = math.max(2, (length / passo).ceil()) * n;
    }

    final scelta = diffusore == 'Automatico'
        ? (riverbero == 'Normale' ? 'Colonna 50 W' : 'DAP CS-330')
        : diffusore;
    final presa = scelta == 'DAP CS-330' ? 20.0 : 25.0;
    final prese = scelta == 'DAP CS-330' ? '10 W / 20 W' : '12,5 W / 25 W / 50 W';
    final carico = count * presa;
    final ampli = ((carico * 1.30) / 50).ceil() * 50;
    final altezza = math.max(2.5, math.min(3.5, height * .35));

    setState(() {
      nDiff = count;
      risultato = '''Forma: $forma
Numero di navate: $n
Passo preliminare: ${passo.toStringAsFixed(1)} m

Diffusore: $scelta
Quantità: $count
Presa 100 V utilizzata: ${presa.toStringAsFixed(1)} W
Prese disponibili: $prese
Carico totale: ${carico.toStringAsFixed(1)} W
Amplificatore consigliato: circa $ampli W
Altezza indicativa: ${altezza.toStringAsFixed(1)} m

I diffusori devono essere orientati verso la zona di ascolto,
in avanti lungo la direzione utile, evitando pareti, volte e superfici riflettenti.''';
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dimensionamento Audio Chiese'),
      backgroundColor: Colors.pink, foregroundColor: Colors.white),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('Dati della chiesa', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _select('Forma della chiesa', forma,
          ['Navata rettangolare','Circolare','Quadrata','Croce latina','Croce greca'],
          (v) => setState(() => forma = v)),
        if (forma == 'Navata rettangolare') ...[
          const SizedBox(height: 12),
          TextField(controller: navate, keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Numero di navate', hintText: 'Es. 1, 2, 3',
              border: OutlineInputBorder(), prefixIcon: Icon(Icons.account_balance))),
        ],
        const SizedBox(height: 12), _field(l, 'Lunghezza (m)'),
        const SizedBox(height: 12), _field(w, 'Larghezza complessiva (m)'),
        const SizedBox(height: 12), _field(h, 'Altezza (m)'),
        const SizedBox(height: 12),
        _select('Riverberazione', riverbero, ['Normale','Riverberante','Molto riverberante'],
          (v) => setState(() => riverbero = v)),
        const SizedBox(height: 12),
        _select('Diffusore', diffusore, ['Automatico','DAP CS-330','Colonna 50 W'],
          (v) => setState(() => diffusore = v)),
        const SizedBox(height: 16),
        FilledButton.icon(onPressed: calcola, icon: const Icon(Icons.calculate),
          label: const Text('CALCOLA DIMENSIONAMENTO')),
        if (risultato.isNotEmpty) ...[
          const SizedBox(height: 20),
          Card(child: Padding(padding: const EdgeInsets.all(16),
            child: Text(risultato, style: const TextStyle(fontSize: 16, height: 1.4)))),
          const SizedBox(height: 12),
          SizedBox(height: 360, child: Card(child: CustomPaint(
            painter: ChurchPainter(forma, math.max(1, int.tryParse(navate.text) ?? 1), nDiff)))),
          const SizedBox(height: 8),
          const Text('Le frecce indicano la direzione orientativa dei diffusori verso la zona di ascolto.',
            textAlign: TextAlign.center, style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          const Text('Pre-dimensionamento: il progetto definitivo richiede verifica di SPL, direttività, riverberazione, rumore di fondo e misure acustiche reali.', style: TextStyle(fontSize: 13)),
        ],
      ]),
    ),
  );

  Widget _field(TextEditingController c, String label) => TextField(
    controller: c, keyboardType: const TextInputType.numberWithOptions(decimal: true),
    decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()));

  Widget _select(String label, String value, List<String> items, ValueChanged<String> onChanged) =>
    DropdownButtonFormField<String>(
      value: value, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: (v) => onChanged(v!));
}

class ChurchPainter extends CustomPainter {
  final String forma; final int navate; final int speakers;
  ChurchPainter(this.forma, this.navate, this.speakers);

  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..style = PaintingStyle.stroke..strokeWidth = 3;
    final sp = Paint()..style = PaintingStyle.fill;
    final r = Rect.fromLTWH(35,35,s.width-70,s.height-70);
    final center = r.center;

    if (forma == 'Navata rettangolare') {
      c.drawRect(r,p);
      final rows = math.max(1, navate);
      final perRow = math.max(2,(speakers/rows).ceil());
      for (int row=0; row<rows; row++) {
        final y = r.top + r.height*(row+.5)/rows;
        for (int i=0;i<perRow;i++) {
          final x = r.left+r.width*(i+1)/(perRow+1);
          arrow(c, Offset(x,y), const Offset(0,-1), sp);
        }
      }
      label(c,'PRESBITERIO / ZONA DI ASCOLTO',Offset(center.dx,r.top-12));
    } else if (forma == 'Quadrata') {
      c.drawRect(r,p);
      final n=math.max(2,(speakers/2).ceil());
      for(int i=0;i<n;i++){
        final x=r.left+r.width*(i+1)/(n+1);
        arrow(c,Offset(x,r.bottom),const Offset(0,-1),sp);
        arrow(c,Offset(x,r.top),const Offset(0,1),sp);
      }
      label(c,'ZONA DI ASCOLTO',center);
    } else if (forma == 'Circolare') {
      c.drawOval(r,p);
      final n=math.max(4,speakers);
      for(int i=0;i<n;i++){
        final a=-math.pi/2+i*2*math.pi/n;
        final q=Offset(center.dx+r.width/2*math.cos(a),center.dy+r.height/2*math.sin(a));
        arrow(c,q,unit(center-q),sp);
      }
      label(c,'ZONA CENTRALE DI ASCOLTO',center);
    } else {
      final path=Path()
        ..moveTo(s.width*.40,35)..lineTo(s.width*.60,35)..lineTo(s.width*.60,s.height*.40)
        ..lineTo(s.width*.88,s.height*.40)..lineTo(s.width*.88,s.height*.60)
        ..lineTo(s.width*.60,s.height*.60)..lineTo(s.width*.60,s.height-35)
        ..lineTo(s.width*.40,s.height-35)..lineTo(s.width*.40,s.height*.60)
        ..lineTo(s.width*.12,s.height*.60)..lineTo(s.width*.12,s.height*.40)
        ..lineTo(s.width*.40,s.height*.40)..close();
      c.drawPath(path,p);
      final pos=[Offset(center.dx,55),Offset(center.dx,s.height-55),
        Offset(55,center.dy),Offset(s.width-55,center.dy)];
      for(final q in pos) arrow(c,q,unit(center-q),sp);
      label(c,'ZONA CENTRALE DI ASCOLTO',center);
      if(forma=='Croce latina') label(c,'PRESBITERIO',Offset(center.dx,52));
    }
  }

  Offset unit(Offset v){final d=math.sqrt(v.dx*v.dx+v.dy*v.dy);return d==0?const Offset(0,1):Offset(v.dx/d,v.dy/d);}
  void arrow(Canvas c,Offset q,Offset d,Paint p){
    c.drawCircle(q,6,p); final e=q+d*28; final z=Offset(-d.dy,d.dx);
    final path=Path()..moveTo(e.dx,e.dy)..lineTo(e.dx-d.dx*9+z.dx*5,e.dy-d.dy*9+z.dy*5)
      ..moveTo(e.dx,e.dy)..lineTo(e.dx-d.dx*9-z.dx*5,e.dy-d.dy*9-z.dy*5);
    c.drawPath(path,p);
  }
  void label(Canvas c,String t,Offset q){
    final tp=TextPainter(text:TextSpan(text:t,style:const TextStyle(fontSize:10,fontWeight:FontWeight.bold)),
      textDirection:TextDirection.ltr)..layout(maxWidth:190);
    tp.paint(c,Offset(q.dx-tp.width/2,q.dy-tp.height/2));
  }
  @override bool shouldRepaint(covariant ChurchPainter old) =>
    old.forma!=forma || old.navate!=navate || old.speakers!=speakers;
}
