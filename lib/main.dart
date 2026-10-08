import 'dart:math' as math;
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Audio Chiese',
    theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
    home: const Home(),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});
  @override State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final l = TextEditingController();
  final w = TextEditingController();
  final h = TextEditingController();
  String shape = 'Navata rettangolare';
  String acoustics = 'Riverberante';
  String speaker = 'Automatico';
  Map<String,dynamic>? result;

  double n(TextEditingController c) => double.tryParse(c.text.replaceAll(',', '.')) ?? 0;

  void calculate() {
    final length=n(l), width=n(w), height=n(h);
    if(length<=0 || width<=0 || height<=0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inserisci lunghezza, larghezza e altezza.')));
      return;
    }

    final spacing = acoustics=='Normale' ? 7.0 :
                    acoustics=='Molto riverberante' ? 4.5 : 5.5;

    int count;
    switch(shape) {
      case 'A ventaglio':
        count = math.max(4, (length/spacing).ceil() + 1);
        break;
      case 'Circolare':
        count = math.max(4, (2*math.pi*math.min(length,width)/spacing).ceil());
        break;
      case 'Quadrata':
        count = math.max(4, ((2*length+2*width)/spacing).ceil());
        break;
      case 'Croce latina':
        count = math.max(6, ((length/spacing).ceil() + (width/spacing).ceil()));
        break;
      case 'Croce greca':
        count = math.max(6, (2*((length/spacing).ceil() + (width/spacing).ceil())));
        break;
      default:
        count = math.max(2, (length/spacing).ceil());
    }

    if(shape=='Navata rettangolare' && width>12) count*=2;

    final chosen = speaker=='Automatico'
      ? (acoustics=='Normale' ? 'Colonna 50 W' : 'DAP CS-330')
      : speaker;

    final tap = chosen=='DAP CS-330'
      ? (acoustics=='Molto riverberante' ? 10.0 : 20.0)
      : (acoustics=='Molto riverberante' ? 12.5 : 25.0);

    final total=count*tap;
    final amp=((total*1.30)/50).ceil()*50;
    final install=math.min(3.5, math.max(2.5,height*0.35));

    setState(()=>result={
      'count':count,'model':chosen,'tap':tap,'total':total,
      'amp':amp,'spacing':spacing,'install':install,
      'length':length,'width':width,'shape':shape
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dimensionamento Audio Chiese')),
    body: ListView(padding: const EdgeInsets.all(16), children:[
      const Text('DATI DELLA CHIESA',
        style: TextStyle(fontSize:22,fontWeight:FontWeight.bold)),
      const SizedBox(height:14),
      _field(l,'Lunghezza (m)'), _field(w,'Larghezza (m)'), _field(h,'Altezza (m)'),
      _drop('Forma della chiesa', shape,
        ['Navata rettangolare','A ventaglio','Circolare','Quadrata','Croce latina','Croce greca'],
        (v)=>setState(()=>shape=v!)),
      _drop('Acustica', acoustics,
        ['Normale','Riverberante','Molto riverberante'],
        (v)=>setState(()=>acoustics=v!)),
      _drop('Diffusore', speaker,
        ['Automatico','DAP CS-330','Colonna 50 W'],
        (v)=>setState(()=>speaker=v!)),
      const SizedBox(height:14),
      FilledButton.icon(onPressed:calculate,
        icon:const Icon(Icons.calculate), label:const Text('CALCOLA')),
      if(result!=null) ...[
        const SizedBox(height:20),
        _result(result!),
      ]
    ]),
  );

  Widget _field(TextEditingController c,String label)=>Padding(
    padding:const EdgeInsets.only(bottom:10),
    child:TextField(controller:c,keyboardType:const TextInputType.numberWithOptions(decimal:true),
      decoration:InputDecoration(labelText:label,border:const OutlineInputBorder()))
  );

  Widget _drop(String label,String value,List<String> items,ValueChanged<String?> onChanged)=>Padding(
    padding:const EdgeInsets.only(bottom:10),
    child:DropdownButtonFormField<String>(
      initialValue:value, decoration:InputDecoration(labelText:label,border:const OutlineInputBorder()),
      items:items.map((x)=>DropdownMenuItem(value:x,child:Text(x))).toList(),
      onChanged:onChanged));

  Widget _result(Map<String,dynamic> r)=>Card(
    child:Padding(padding:const EdgeInsets.all(16),child:Column(
      crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('RISULTATO',style:TextStyle(fontSize:21,fontWeight:FontWeight.bold)),
        const SizedBox(height:10),
        _row('Forma',r['shape'].toString()),
        _row('Diffusori',r['count'].toString()),
        _row('Modello',r['model'].toString()),
        _row('Presa 100 V','${r['tap']} W'),
        _row('Carico totale','${r['total']} W'),
        _row('Amplificatore','${r['amp']} W / 100 V'),
        _row('Interasse indicativo','${r['spacing']} m'),
        _row('Altezza installazione','${r['install'].toStringAsFixed(2)} m'),
        const SizedBox(height:12),
        SizedBox(height:220,width:double.infinity,
          child:CustomPaint(painter:PlanPainter(r))),
        const SizedBox(height:8),
        const Text('Dimensionamento preliminare: la verifica definitiva richiede dati acustici e direttività reali.',
          style:TextStyle(fontSize:12))
      ])));

  Widget _row(String a,String b)=>Padding(
    padding:const EdgeInsets.symmetric(vertical:3),
    child:Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children:[
      Text(a),Flexible(child:Text(b,textAlign:TextAlign.right,style:const TextStyle(fontWeight:FontWeight.bold)))
    ]));
}

class PlanPainter extends CustomPainter {
  final Map<String,dynamic> r;
  PlanPainter(this.r);
  @override void paint(Canvas c,Size s) {
    final p=Paint()..style=PaintingStyle.stroke..strokeWidth=2;
    final f=Paint()..style=PaintingStyle.fill;
    final cx=s.width/2, cy=s.height/2;
    final shape=r['shape'].toString();
    if(shape=='Circolare') {
      c.drawCircle(Offset(cx,cy),math.min(s.width,s.height)*.38,p);
    } else if(shape=='A ventaglio') {
      final path=Path()..moveTo(cx,20)..lineTo(s.width-15,s.height-20)..lineTo(15,s.height-20)..close();
      c.drawPath(path,p);
    } else if(shape=='Croce latina') {
      c.drawRect(Rect.fromLTWH(cx-28,15,56,s.height-30),p);
      c.drawRect(Rect.fromLTWH(25,cy-28,s.width-50,56),p);
    } else if(shape=='Croce greca') {
      c.drawRect(Rect.fromLTWH(cx-45,15,90,s.height-30),p);
      c.drawRect(Rect.fromLTWH(15,cy-45,s.width-30,90),p);
    } else {
      c.drawRect(Rect.fromLTWH(20,20,s.width-40,s.height-40),p);
    }
    final count=r['count'] as int;
    for(int i=0;i<count;i++) {
      double x,y;
      if(shape=='Circolare') {
        final a=2*math.pi*i/count;
        final rad=math.min(s.width,s.height)*.31;
        x=cx+rad*math.cos(a); y=cy+rad*math.sin(a);
      } else if(shape=='A ventaglio') {
        final t=count==1?0:i/(count-1);
        x=25+t*(s.width-50); y=s.height-35;
      } else {
        x=25+(i%math.max(1,(count/2).ceil()))*((s.width-50)/math.max(1,(count/2).ceil()-1));
        y=i.isEven?25:s.height-25;
      }
      c.drawCircle(Offset(x,y),6,f);
    }
  }
  @override bool shouldRepaint(covariant PlanPainter old)=>true;
}
