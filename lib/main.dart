import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: HomeScreen()));
}

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  static const List<Icon> icons = [
    Icon(Icons.home),
    Icon(Icons.search),
    Icon(Icons.settings),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> index = useState(0);
    final ValueNotifier<List<int>> navStack = useState([0]);

    final void Function() onPop = useCallback(
      () {
        if (navStack.value.isNotEmpty) {
          index.value = navStack.value.last;
          navStack.value.removeLast();
        }
      },
    );

    return MaterialApp(
      home: PopScope(
        canPop: navStack.value.length == 1,
        onPopInvoked: (bool value) {
          onPop();
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: IndexedStack(
                  index: index.value,
                  children: const [
                    DemoScreen(title: 'Screen 1'),
                    DemoScreen(title: 'Screen 2'),
                    DemoScreen(title: 'Screen 3'),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(3, (itemIndex) {
                    return BottomNavItem(
                      onPressed: () {
                        if (itemIndex != index.value) {
                          navStack.value.add(index.value);
                          index.value = itemIndex;
                        }
                      },
                      icon: icons[itemIndex],
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DemoScreen extends StatelessWidget {
  final String title;
  const DemoScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title),
      ],
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  const BottomNavItem({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      onPressed: () {
        onPressed();
      },
    );
  }
}
