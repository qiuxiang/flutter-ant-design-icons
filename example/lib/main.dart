import 'package:flutter/material.dart';

import 'filled.dart';
import 'outlined.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage();

  @override
  Widget build(BuildContext context) {
    Icons;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ant Design Icons'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(34),
            child: TabBar(
              labelPadding: EdgeInsets.symmetric(vertical: 8),
              tabs: [Text('Filled'), Text('Outlined')],
            ),
          ),
        ),
        body: const TabBarView(children: [
          GridIcons(filledIcons),
          GridIcons(outlinedIcons),
        ]),
      ),
    );
  }
}

class GridIcons extends StatelessWidget {
  final List icons;
  const GridIcons(this.icons);

  @override
  Widget build(BuildContext context) {
    final gridCount = MediaQuery.of(context).size.width ~/ 150;
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: gridCount),
      itemBuilder: (_, i) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icons[i][0] as IconData, size: 50),
            const SizedBox(height: 8),
            Text(icons[i][1] as String,
                style: Theme.of(context).textTheme.caption),
          ],
        );
      },
      itemCount: icons.length,
    );
  }
}
