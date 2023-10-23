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
      home: ShoppingListScreenState(),
    );
  }
}


class ShoppingListScreenState extends StatefulWidget {
  @override
  _ShoppingListScreenState createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreenState> {
  final List<Item> _shoppingItems = [];
  final Set<Item> _checkedItems = {};

  void _addItem(String name, double value) {
    setState(() {
      _shoppingItems.add(Item(name, value));
    });
  }

  void _removeCheckedItems() {
    setState(() {
      _shoppingItems.removeWhere((item) => _checkedItems.contains(item));
      _checkedItems.clear();
    });
  }

  void _toggleItem(Item item) {
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
            title: Text(item.name),
            subtitle: Text('R\$ ${item.value.toStringAsFixed(2)}'),
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
                  String newItemName = '';
                  double newItemValue = 0.0;
                  return AlertDialog(
                    title: const Text('Adicionar Item'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          onChanged: (value) {
                            newItemName = value;
                          },
                          decoration: const InputDecoration(labelText: 'Nome do Item'),
                        ),
                        TextField(
                          onChanged: (value) {
                            newItemValue = double.tryParse(value) ?? 0.0;
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Valor do Item (R\$)'),
                        ),
                      ],
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
                          _addItem(newItemName, newItemValue);
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
          const SizedBox(height: 16),
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

class Item {
  String name;
  double value;

  Item(this.name, this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Item && runtimeType == other.runtimeType && name == other.name && value == other.value;

  @override
  int get hashCode => name.hashCode ^ value.hashCode;
}
