import 'dart:convert';
import 'package:engravedstudios/features/games/domain/store_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class StoreDataService {
  final http.Client _client;

  StoreDataService({http.Client? client}) : _client = client ?? http.Client();

  // Cache to avoid spamming APIs
  final Map<String, StoreData> _cache = {};

  Future<StoreData?> fetchSteamData(String appId) async {
    if (_cache.containsKey(appId)) return _cache[appId];

    try {
      // NOTE: Client-side CORS might block this on Web. 
      // In production, use a proxy or backend function.
      final url = Uri.parse('https://store.steampowered.com/api/appdetails?appids=$appId');
      final response = await _client.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final data = json[appId]['data'];
        
        if (json[appId]['success'] == true && data != null) {
          final isFree = data['is_free'] == true;
          final priceOverview = data['price_overview'];
          
          StoreData storeData;
          
          if (isFree) {
            storeData = const StoreData(isFree: true);
          } else if (priceOverview != null) {
             final currency = priceOverview['currency'] == 'EUR' ? '€' : '\$'; // Simple map
             final finalPrice = priceOverview['final'] / 100.0;
             final initialPrice = priceOverview['initial'] / 100.0;
             final discount = priceOverview['discount_percent'] as int;
             
             storeData = StoreData(
               price: finalPrice,
               originalPrice: initialPrice,
               discountPercent: discount,
               currency: currency,
             );
          } else {
            // Coming soon or no price data
            storeData = const StoreData();
          }
          
          _cache[appId] = storeData;
          return storeData;
        }
      }
    } catch (e) {
      // Fallback or log error
      print('Steam API Error: $e');
    }
    return null;
  }
}

final storeDataServiceProvider = Provider<StoreDataService>((ref) {
  return StoreDataService();
});

// Helper provider for specific game
final steamDataProvider = FutureProvider.family<StoreData?, String>((ref, appId) async {
  final service = ref.watch(storeDataServiceProvider);
  return service.fetchSteamData(appId);
});
