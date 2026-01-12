import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://absoaoqiwhyyfdmlxfje.supabase.co';

  static const String supabaseKey =
      'sb_publishable_59ItdnLndKYCeOvS1xGn5g_NoOFpA6V';
  static get client => Supabase.instance.client;
}
