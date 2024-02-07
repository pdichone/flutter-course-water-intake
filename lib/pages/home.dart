import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_intake/data/water_data.dart';
import 'package:water_intake/model/water_mode.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final amountController = TextEditingController();
  var _isLoading = true;

  @override
  void initState() {
    Provider.of<WaterData>(context, listen: false).getWater();
    super.initState();
  }

  void saveWater() async {
    Provider.of<WaterData>(context, listen: false).addWater(WaterModel(
        amount: double.parse(amountController.text.toString()),
        dateTime: DateTime.now(),
        unit: 'ml'));

    if (!context.mounted) {
      return; // if the widget is not mounted, don't do anthing
    }
  }

  void addWater() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add Water'),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add water to your daily intake'),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Amount'),
                  )
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel')),
                TextButton(
                    onPressed: () {
                      //save data to db
                      saveWater();
                      Navigator.of(context).pop();
                    },
                    child: Text('Save')),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding Build ...");
    return Consumer<WaterData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          elevation: 4,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  // saveWater();
                },
                icon: const Icon(Icons.map))
          ],
          title: const Text('Water'),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: FloatingActionButton(
            onPressed: addWater, child: const Icon(Icons.add)),
        body: ListView.builder(
            itemCount: value.waterDataList.length,
            itemBuilder: (context, index) {
              final waterModel = value.waterDataList[index];

              return ListTile(
                title: Text(waterModel.amount.toString()),
                subtitle: Text(waterModel.id!),
              );
            }),
      ),
    );
  }
}
