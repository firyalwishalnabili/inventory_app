import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://pxkjeaqufbryzxqfcwdy.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InB4a2plYXF1ZmJyeXp4cWZjd2R5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU4NDkyOTEsImV4cCI6MjA2MTQyNTI5MX0.jTNSH8dHCljrpxtfKK_uQF0ApA_gc8Z86CW-ly1IK5U';

  static Future<void> init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
