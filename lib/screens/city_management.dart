import 'package:flutter/material.dart';
import 'package:weather/models/city.dart';
import 'package:weather/models/search_result.dart';
import 'package:weather/utilities/api.dart';
import 'package:weather/utilities/database.dart';

class CityManagement extends StatefulWidget {
  const CityManagement({super.key});

  @override
  State<CityManagement> createState() => _CityManagementState();
}

class _CityManagementState extends State<CityManagement> {
  late List<City> cities;
  late List<SearchResult> results;

  bool searched = false;
  bool isLoading = true;
  final search = TextEditingController();

  getCities() async {
    var db = Database();
    await db.getCities().then(
      (value) {
        setState(() {
          cities = value;
          isLoading = false;
        });
      },
    );
  }

  searchCity() async {
    setState(() {
      isLoading = true;
    });
    var api = Api();
    var res = await api.getCurrentWeather('search', search.text);
    var body = res.data;

    if (body.length != 0) {
      searched = true;
    }

    setState(() {
      results = List.generate(
        body.length,
        (index) => SearchResult(
          id: body[index]['id'],
          name: body[index]['name'],
          region: body[index]['region'],
          country: body[index]['country'],
        ),
      );
      isLoading = false;
    });
  }

  deleteCity(int id) async {
    var db = Database();
    await db.delete(id).then((value) => getCities());
  }

  addToDatabase(SearchResult result) async {
    var db = Database();
    await db
        .insert(City(
      id: result.id,
      name: result.name,
      isDefault: 0,
    ))
        .then((value) {
      setState(() {
        searched = false;
        getCities();
      });
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getCities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFF1A1C1E),
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'City Management',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.white,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() {
                          search.text = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter City Name',
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(255, 137, 137, 137),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: Colors.white,
                          ),
                          onPressed: () => searchCity(),
                        ),
                      ),
                    ),
                    Text(
                      searched ? 'Search Results' : '',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: searched
                          ? ListView.builder(
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                    results[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      addToDatabase(results[index]);
                                    },
                                  ),
                                );
                              },
                            )
                          : ListView.builder(
                              itemCount: cities.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => Navigator.pop(
                                    context,
                                    cities[index],
                                  ),
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            "Delete ${cities[index].name}"),
                                        content: Text(
                                          "Are you sure you want to delete ${cities[index].name}?",
                                        ),
                                        actions: [
                                          MaterialButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          MaterialButton(
                                            onPressed: () {
                                              deleteCity(cities[index].id);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Yes'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  title: Text(
                                    cities[index].name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
