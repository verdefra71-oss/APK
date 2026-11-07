import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/streaming_site.dart';
import '../services/site_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  String _query = '';
  Set<String> _favorites = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _favorites = (prefs.getStringList('favorites') ?? []).toSet();
      _loading = false;
    });
  }

  Future<void> _toggleFavorite(StreamingSite site) async {
    setState(() {
      if (_favorites.contains(site.id)) {
        _favorites.remove(site.id);
      } else {
        _favorites.add(site.id);
      }
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites.toList());
  }

  Future<void> _openSite(StreamingSite site) async {
    final uri = Uri.tryParse(site.url);
    if (uri == null || !await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossibile aprire il collegamento.')),
      );
    }
  }

  List<StreamingSite> get _visibleSites {
    Iterable<StreamingSite> items = SiteService.sites;
    if (_tab == 1) {
      items = items.where((site) => _favorites.contains(site.id));
    }
    final query = _query.trim().toLowerCase();
    if (query.isNotEmpty) {
      items = items.where((site) =>
          site.name.toLowerCase().contains(query) ||
          site.category.toLowerCase().contains(query) ||
          site.description.toLowerCase().contains(query));
    }
    return items.toList();
  }

  IconData _iconFor(String name) {
    switch (name) {
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'play_circle':
        return Icons.play_circle_outline;
      case 'live_tv':
        return Icons.live_tv;
      case 'devices':
        return Icons.devices;
      default:
        return Icons.ondemand_video;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sites = _visibleSites;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: const Color(0xFF31D17C).withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sports_soccer, color: Color(0xFF31D17C)),
            ),
            const SizedBox(width: 12),
            const Text('Calcio Live', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Informazioni',
            onPressed: _showInfo,
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final wide = constraints.maxWidth >= 760;
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1050),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 8, 18, 18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _hero(),
                            const SizedBox(height: 18),
                            TextField(
                              onChanged: (value) => setState(() => _query = value),
                              decoration: InputDecoration(
                                hintText: 'Cerca un servizio...',
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: const Color(0xFF142238),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                _filterChip('Tutti', 0),
                                const SizedBox(width: 8),
                                _filterChip('Preferiti', 1),
                                const Spacer(),
                                Text('${sites.length} servizi',
                                    style: const TextStyle(color: Colors.white54)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: sites.isEmpty
                                  ? _emptyState()
                                  : GridView.builder(
                                      itemCount: sites.length,
                                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: wide ? 2 : 1,
                                        mainAxisExtent: 116,
                                        crossAxisSpacing: 12,
                                        mainAxisSpacing: 12,
                                      ),
                                      itemBuilder: (context, index) {
                                        final site = sites[index];
                                        return _siteCard(site);
                                      },
                                    ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'I collegamenti portano ai siti ufficiali. Catalogo e disponibilità dei contenuti possono variare.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white38, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _hero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF173C35), Color(0xFF142238)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('IL CALCIO, IN UN SOLO POSTO',
              style: TextStyle(color: Color(0xFF8DE9B6), fontSize: 11,
                  letterSpacing: 1.4, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Scegli dove guardare.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          SizedBox(height: 5),
          Text('Accedi rapidamente alle piattaforme ufficiali.',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _filterChip(String label, int value) {
    final selected = _tab == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _tab = value),
      selectedColor: const Color(0xFF31D17C),
      labelStyle: TextStyle(
        color: selected ? const Color(0xFF07130D) : Colors.white70,
        fontWeight: FontWeight.w600,
      ),
      side: BorderSide.none,
      backgroundColor: const Color(0xFF142238),
    );
  }

  Widget _siteCard(StreamingSite site) {
    final favorite = _favorites.contains(site.id);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openSite(site),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF31D17C).withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_iconFor(site.icon), color: const Color(0xFF31D17C), size: 26),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(site.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(site.description, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    const SizedBox(height: 5),
                    Text(site.category, style: const TextStyle(color: Color(0xFF8DE9B6), fontSize: 10)),
                  ],
                ),
              ),
              IconButton(
                tooltip: favorite ? 'Rimuovi dai preferiti' : 'Aggiungi ai preferiti',
                onPressed: () => _toggleFavorite(site),
                icon: Icon(favorite ? Icons.star : Icons.star_border,
                    color: favorite ? const Color(0xFFFFC857) : Colors.white54),
              ),
              const Icon(Icons.open_in_new, size: 17, color: Colors.white54),
            ],
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off, size: 42, color: Colors.white38),
          const SizedBox(height: 10),
          Text(_tab == 1 ? 'Non hai ancora preferiti.' : 'Nessun servizio trovato.',
              style: const TextStyle(color: Colors.white60)),
        ],
      ),
    );
  }

  void _showInfo() {
    showAboutDialog(
      context: context,
      applicationName: 'Calcio Live',
      applicationVersion: '1.0.0',
      children: const [
        Text('Calcio Live è un raccoglitore di collegamenti a servizi ufficiali. '
            'Non trasmette partite e non fornisce accesso a contenuti non autorizzati.'),
      ],
    );
  }
}
