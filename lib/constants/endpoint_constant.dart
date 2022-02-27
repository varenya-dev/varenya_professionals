import 'package:flutter/foundation.dart' show kIsWeb;

const ENDPOINT = kIsWeb ? "http://127.0.0.1:5000/v1/api" : "http://10.0.2.2:5000/v1/api";
const RAW_ENDPOINT = kIsWeb ? "127.0.0.1:5000" : "10.0.2.2:5000";
