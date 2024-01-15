import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'https://dcnxhinfvgnhtvclivst.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRjbnhoaW5mdmduaHR2Y2xpdnN0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ5NTc3NzUsImV4cCI6MjAyMDUzMzc3NX0.07DdVXGgevC0voD7dJ0alBhZP9wOBXAs4q9NIZ9-bp0',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Province App',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await Supabase.instance.client
        .from('province')
        .select()
        .execute();

    print("Supabase Response: ${response.data}");

    if (response.error != null) {
      throw Exception(response.error!.message);
    }

    return response.data as List<Map<String, dynamic>>;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final provinces = snapshot.data!;
          return ListView.builder(
            itemCount: provinces.length,
            itemBuilder: ((context, index) {
              final province = provinces[index];
              return ListTile(
                leading: Icon(
                  Icons.location_city,
                  color: Colors.green,
                ),
                title: Text(
                  province['name'],
                  style: TextStyle(color: Colors.blue),
                ),
                subtitle: Text(
                    'Population: ${province['population']} - Capital: ${province['capital']} - Area: ${province['area']}'),
              );
            }),
          );
        },
      ),
    );
  }
}