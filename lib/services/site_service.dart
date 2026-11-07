import '../models/streaming_site.dart';

class SiteService {
  // Collegamenti a servizi ufficiali. Catalogo modificabile in questo file.
  static const List<StreamingSite> sites = [
    StreamingSite(
      id: 'dazn',
      name: 'DAZN',
      description: 'Piattaforma sportiva in streaming',
      url: 'https://www.dazn.com/it-IT/home',
      category: 'Streaming sportivo',
      icon: 'sports_soccer',
    ),
    StreamingSite(
      id: 'now',
      name: 'NOW',
      description: 'Intrattenimento e sport in streaming',
      url: 'https://www.nowtv.it/',
      category: 'Streaming sportivo',
      icon: 'play_circle',
    ),
    StreamingSite(
      id: 'sky',
      name: 'Sky',
      description: 'Sito ufficiale e offerte Sky',
      url: 'https://www.sky.it/',
      category: 'TV e sport',
      icon: 'live_tv',
    ),
    StreamingSite(
      id: 'skygo',
      name: 'Sky Go',
      description: 'Accesso al servizio per clienti Sky',
      url: 'https://skygo.sky.it/',
      category: 'App e servizi',
      icon: 'devices',
    ),
    StreamingSite(
      id: 'raiplay',
      name: 'RaiPlay',
      description: 'Dirette e contenuti Rai disponibili online',
      url: 'https://www.raiplay.it/',
      category: 'Gratuito',
      icon: 'ondemand_video',
    ),
  ];
}
