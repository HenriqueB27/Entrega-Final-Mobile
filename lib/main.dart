import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingListScreen(),
    );
  }
}

class ShoppingListScreen extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  List<String> _shoppingItems = [];
  Set<String> _checkedItems = {};

  void _addItem(String item) {
    setState(() {
      _shoppingItems.add(item);
    });
  }

  void _removeCheckedItems() {
    setState(() {
      _shoppingItems.removeWhere((item) => _checkedItems.contains(item));
      _checkedItems.clear();
    });
  }

  void _toggleItem(String item) {
    setState(() {
      if (_checkedItems.contains(item)) {
        _checkedItems.remove(item);
      } else {
        _checkedItems.add(item);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Compras'),
      ),
      body: ListView(
        children: _shoppingItems.map((item) {
          return ListTile(
            title: Text(item),
            trailing: Checkbox(
              value: _checkedItems.contains(item),
              onChanged: (value) {
                _toggleItem(item);
              },
            ),
          );
        }).toList(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String newItem = '';
                  return AlertDialog(
                    title: const Text('Adicionar Item'),
                    content: TextField(
                      onChanged: (value) {
                        newItem = value;
                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Adicionar'),
                        onPressed: () {
                          _addItem(newItem);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            tooltip: 'Adicionar Item',
            child: const Icon(Icons.add),
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              _removeCheckedItems();
            },
            tooltip: 'Remover Itens Marcados',
            child: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
