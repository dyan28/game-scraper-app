import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tap_two_play/env/env_state.dart';
import 'package:tap_two_play/main/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Supabase.initialize(
    url: 'https://xenqevlspunabyqacndp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhlbnFldmxzcHVuYWJ5cWFjbmRwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc2OTkyODMsImV4cCI6MjA3MzI3NTI4M30.60y95J3HGCRaVx7-GcK0sNPSPZYLEBKeZuJP5vMjaz0',
  );
  setupAndRunApp(env: EnvValue.production);
}
