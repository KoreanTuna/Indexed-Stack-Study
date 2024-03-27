import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends HookConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ValueNotifier<int> index = useState(0);
    final ValueNotifier<List<int>> navStack = useState([0]);

    final bool Function() onPop = useCallback(
      () {
        if (navStack.value.isNotEmpty) {
          index.value = navStack.value.last;
          navStack.value.removeLast();
          return false;
        }
        return true;
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
                  children: [
                    _BottomNavItem(
                      onPressed: () {
                        navStack.value.add(index.value);
                        index.value = 0;
                      },
                      icon: const Icon(Icons.home),
                    ),
                    _BottomNavItem(
                      onPressed: () {
                        navStack.value.add(index.value);
                        index.value = 1;
                      },
                      icon: const Icon(Icons.search),
                    ),
                    _BottomNavItem(
                      onPressed: () {
                        navStack.value.add(index.value);
                        index.value = 2;
                      },
                      icon: const Icon(Icons.settings),
                    ),
                  ],
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

class _BottomNavItem extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  const _BottomNavItem({
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
