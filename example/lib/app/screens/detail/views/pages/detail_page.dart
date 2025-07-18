import 'package:flutter/material.dart';
import 'package:uloc/uloc.dart';

import 'package:uloc_example/app/screens/detail/controllers/detail_controller.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  DetailController get watch => context.watch<DetailController>();
  DetailController get controller => context.read<DetailController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(watch.name)),
      body: Center(
        child: Text(watch.count.toString(), style: TextStyle(fontSize: 40)),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          FloatingActionButton.small(
            heroTag: 'increment',
            onPressed: controller.increment,
            child: Icon(Icons.add),
          ),
          FloatingActionButton.small(
            heroTag: 'decrement',
            onPressed: controller.decrement,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
